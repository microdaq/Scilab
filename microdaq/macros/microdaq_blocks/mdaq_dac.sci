function [x,y,typ] = mdaq_dac(job,arg1,arg2)
    global %microdaq;
    range_validation = [];
    
    if %microdaq.private.mdaq_hwid <> [] then
        dac_info = get_dac_info(%microdaq.private.mdaq_hwid);
        range_base_opt = [" 0: 0-5V"; " 1: 0-10V"; " 2: ±5V"; " 3: ±10V";" 4: ±2.5V";];
        range_spec_opt = [];
        n = 1;

        for i=1:max(size(dac_info.range))
            for j=1:max(size(range_base_opt))
                if strindex(range_base_opt(j), dac_info.range(i)) <> [] then
                    range_spec_opt(n) = range_base_opt(j);
                    valid_num = range_base_opt(j);
                    valid_num = part(valid_num, 1:strindex(valid_num, ":"));
                    valid_num = strtod(valid_num);
                    range_validation(n) = valid_num;
                    n = n + 1;
                end
            end
        end


        dac_desc = ["This block sets MicroDAQ analog outputs (AO).";
        "DAC block allows to set terminate voltage which will be set at";
        "the end of simulation in Ext mode.";
        "";
        "User can use option Terminate all DACs with voltage to set";
        "same voltage at all DAC channels. Without selecting this option";
        "user can define different terminate voltages for DAC channel.";
        "";
        "input - input value in volts"
        "";
        "Detected DAC parameters:";
        "channels: "+dac_info.channel;
        "resolution: "+dac_info.resolution;
        "range: "+dac_info.range_desc;
        "";
        "DAC settings:"
        "Range:";
        range_spec_opt;
        "";
        "Set block parameters:"];
    else
        dac_desc = "";
    end

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
                [ok,channel,dac_mode,term_value,exprs]=..
                scicos_getvalue(dac_desc,..
                ['Channels:';
                'Range:';
                'Termination value:'],..
                list('vec',-1,'vec',1,'vec',-1),exprs)
            catch
                [ok,channel,dac_mode,term_value,exprs]=..
                scicos_getvalue(dac_desc,..
                ['Channels:';
                'Range:';
                'Termination value:'],..
                list('vec',-1,'vec',1,'vec',-1),exprs)
            end;

            if ~ok then
                break
            end

            if dac_info.id > 5 | dac_info.id < 1 then
                ok = %f;
                message("DAC not detected, run mdaq_hwinfo and try again!");
            end

            ch_count = 8;
            if dac_info.id > 3 then
                ch_count = 16;
            end

            n_channels = size(channel);
            if n_channels(2) > ch_count then
                ok = %f;
                error_msg = 'Too many channels selected for DAC0' + string(dac_info.id) + '!';
                message(error_msg);
            end

            if max(channel) > ch_count | min(channel) < 1 then
                ok = %f;
                error_msg = 'Wrong channel number selected for DAC0' + string(dac_info.id) + '!';
                message(error_msg);
            end

            if dac_mode > 4 | dac_mode < 0 then
                ok = %f;
                message("Wrong range selected, use 0,1,2,3 or 4!");
            end

            if range_validation <> [] then
                if find(range_validation == dac_mode) == [] then
                    ok = %f;
                    message("Wrong range selected!");
                end
            end

            if ok then
                n_channels = size(channel);
                n_term_value = size(term_value);
                if  n_term_value(2) > 1 then
                    if  n_term_value(2) <> n_channels(2) then
                        message('Set termination value for selected channels or set one value which will be used for all channels!')
                        ok = %f;
                    end
                    term_value = term_value';
                else
                    term_value(1:ch_count) = term_value;
                end
            end

            if ok then
                [model,graphics,ok] = check_io(model,graphics, n_channels(2), [], 1, []);
                graphics.exprs = exprs;
                model.rpar = [8; term_value];
                model.ipar = [dac_info.id;dac_mode;n_channels(2);channel'];
                model.dstate = [];
                x.graphics = graphics;
                x.model = model;
                break
            end
        end
    case 'define' then
        channel=1
        term_value=0

        if( range_validation <> []) then
            dac_mode = range_validation(1);
            converter = dac_info.id;
        else
            dac_mode = 3;//±10V
            converter = 1;//DAC01
        end

        model=scicos_model()
        model.sim=list('mdaq_dac_sim',5)
        model.in =1
        model.in2=1
        model.intyp=1
        model.out=[]
        model.evtin=1
        model.rpar = [1; term_value];
        model.ipar = [converter;dac_mode;1;channel'];
        model.dstate=[];
        model.blocktype='d'
        model.dep_ut=[%t %f]
        exprs=[sci2exp(channel);sci2exp(dac_mode);sci2exp(term_value)]
        gr_i=['xstringb(orig(1),orig(2),[''CH:'' ; string(channel)],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
        x.graphics.style=["blockWithLabel;verticalLabelPosition=center;displayedLabel=CH:%1$s;fontColor=#5f5f5f"]
    end
endfunction
