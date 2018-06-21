function [x,y,typ] = mdaq_adc(job,arg1,arg2)
    global %microdaq;

    adc_desc = ["This block reads MicroDAQ analog inputs (AI). Block detects";
    "MicroDAQ analog inputs type and allows channel, range";
    "and measurement type selection.";
    "In order to select analog input channels scalar or vector";
    "containing channel number have to be provided.";
    "Input range can be selected by providing scalar or vector";
    "with range identifiers. If single range provided it will";
    "be applied for all selected channels."
    "Single-ended or differential measurement type can be selected.";
    "Scalar or vector with 1 and 0 values can be provided to enable";
    "and disable differential mode.";
    "If scalar is provided it will be applied for all used channels";
    "";
    "Averaging allows to increase measurement accuracy by calculating";
    "average from 4-256 ADC samples. ";
    "Averaging factor: ";
    "0 - averaging disabled";
    "1 - 4 ADC reads per channel";
    "2 - 16 ADC reads per channel";
    "3 - 64 ADC reads per channel";
    "4 - 256 ADC reads per channel";
    "";
    "Use mdaqHWInfo to get ADC parameters"
    "";
    "output - ADC value scaled to selected range";
    "";
    "Set block parameters:"];
    x=[];y=[];typ=[];
    select job
    case 'set' then
        x=arg1
        model=arg1.model;
        graphics=arg1.graphics;
        exprs=graphics.exprs;
        while %t do
            try
                getversion('scilab');
                [ok, channels, aiRange, aiMode, averaging,exprs]=..
                        scicos_getvalue(adc_desc,..
                            ['Channels:';
                            'Range:';
                            'Differential:';
                            'Averaging:'],..
                            list('row',-1,'mat',[-1,-1],'row',-1,'vec',1),exprs)
            catch
                [ok, channels, aiRange, aiMode, averaging, exprs]=..
                scicos_getvalue(adc_desc,..
                ['Channels:';
                'Range:';
                'Differential:';
                'Averaging:'],..
                list('row',-1,'mat',[-1,-1],'row',-1,'vec',1),exprs)
            end

            if ~ok then
                break
            end
            
            ch_count = size(channels, 'c');
            if %microdaq.private.mdaq_hwid <> [] then
                adc_id = %microdaq.private.mdaq_hwid(2);
                if ok & (find(adc_id == get_adc_list()) == []) then
                    ok = %f;
                    message("Configuration not detected - run mdaqHWInfo and try again!");
                end

                if ok & size(channels, 'r') > 1 then
                    message("Single row channel vector expected!")
                    ok = %f;
                end

                if ok & size(aiRange, 'c') <> 2 then
                    message("Vector range [low,high;low,high;...] expected!")
                    ok = %f;
                end

                if ok & size(aiMode, 'r') > 1 then
                    message("Single row measurement mode vector expected!")
                    ok = %f;
                end

                aiRangeSize = size(aiRange, 'r');
                if ok &  (aiRangeSize <> 1 & aiRangeSize <> ch_count) then
                    message("Range vector should match selected channels!")
                    ok = %f;
                end

                aiModeSize = size(aiMode, 'c');
                if ok & (aiModeSize <> 1 & aiModeSize <> ch_count) then
                    message("Mode vector should match selected channels!")
                    ok = %f;
                end

                if ok & (averaging < 0) | (averaging > 4) then
                    ok = %f;
                    message("Wrong averaging facator selected!");
                end

                if aiRangeSize == 1 & ok then
                    range_tmp = aiRange;
                    aiRange = ones(ch_count,2);
                    aiRange(:,1) = range_tmp(1);
                    aiRange(:,2) = range_tmp(2);
                end
                
                if aiModeSize == 1 & ok then
                    aiMode = ones(1, ch_count)*aiMode;
                end
                
                if ok & ~exists("%scicos_prob") then
                    result = adc_check_params(channels, aiRange, aiMode);
                    if result < 0 then
                        message(mdaq_error2(result));
                        ok = %f;
                    end
                end
            else
                ok = %f;
                message('Unable to detect MicroDAQ confituration - run mdaqHWInfo and try again!');
            end

            if ok then
                [model,graphics,ok] = check_io(model,graphics, [], ch_count, 1, []);
                graphics.exprs = exprs;
                model.ipar=[ch_count; averaging; channels'; aiMode'];            
                model.rpar= matrix(aiRange', 1, ch_count*2)';
                model.dstate = [];
                x.graphics = graphics;
                x.model = model;
                break;
            end
        end
    case 'define' then
        aiRange = [-10,10];
        aiMode = 0;
        adc_range_sim = 1;
        averaging= 0;
        ch_count = 1;
        channels = 1;
        model=scicos_model()
        model.sim=list('mdaq_adc_sim',5)
        model.out=[1]
        model.outtyp=[1]
        model.evtin=1
        model.rpar=aiRange;
        model.ipar= [ch_count; averaging; channels'; aiMode'];   
        model.dstate=[];
        model.blocktype='d'
        model.dep_ut=[%t %f]
        exprs=[sci2exp(channels); sci2exp(aiRange); sci2exp(aiMode); sci2exp(averaging)];
        gr_i=['xstringb(orig(1),orig(2),[''CH: '' ; string(channels)],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
        x.graphics.style=["blockWithLabel;verticalLabelPosition=center;displayedLabel=CH:%1$s;fontColor=#5f5f5f"]
    end
endfunction
