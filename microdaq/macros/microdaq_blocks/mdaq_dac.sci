function [x,y,typ] = mdaq_dac(job,arg1,arg2)
    global %microdaq;
    if %microdaq.private.mdaq_hwid <> [] then
        dac_info = get_dac_info(%microdaq.private.mdaq_hwid);
        dac_converter = dac_info.id;
        channel_desc = dac_info.channel;
        resolution_desc = dac_info.resolution;
        range_desc = dac_info.c_params.c_range_desc;
        range_spec_opt = [];
        for i = 1:size(dac_info.c_params.c_range_desc, "r")
            range_spec_opt = [range_spec_opt; string(i) + ": " + dac_info.c_params.c_range_desc(i)];
        end
    else
        dac_converter = 1;
        channel_desc = "Unknown";
        resolution_desc = "Unknown";
        range_desc = "Unknown";
        range_spec_opt = "Unknown";
    end

    dac_desc = ["This block writes data to MicroDAQ analog output module (AO).";
    "Block detects MicroDAQ analog output type and allows";
    "setting output range and termination voltage.";
    "Single termination value will be used for all channels.";
    "If different termination values for selected channels needs ";
    "to be used a vector with termination values has to be provided.";
    "";
    "input - value in volts"
    "";
    "Analog outputs parameters:";
    "Channels: "+channel_desc;
    "Resolution: "+resolution_desc;
    "";
    "Output rage:";
    range_spec_opt;
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
                [ok,channel,dac_range,term_value,exprs]=..
                scicos_getvalue(dac_desc,..
                ['Channels:';
                'Output range:';
                'Termination value:'],..
                list('vec',-1,'vec',1,'vec',-1),exprs)
            catch
                [ok,channel,dac_range,term_value,exprs]=..
                scicos_getvalue(dac_desc,..
                ['Channels:';
                'Output range:';
                'Termination value:'],..
                list('vec',-1,'vec',1,'vec',-1),exprs)
            end;

            if ~ok then
                break
            end

            if %microdaq.private.mdaq_hwid <> [] then
                if dac_info.id > 5 | dac_info.id < 1 then
                    ok = %f;
                    message("Configuration not detected - run mdaq_hwinfo and try again!");
                end
                
                dac_ch_count = strtod(dac_info.channel);

                n_channels = size(channel);
                if n_channels(2) > dac_ch_count then
                    ok = %f;
                    error_msg = 'Too many channels selected!';
                    message(error_msg);
                end

                if max(channel) > dac_ch_count | min(channel) < 1 then
                    ok = %f;
                    error_msg = 'Wrong channel number selected!';
                    message(error_msg);
                end

                if dac_range > size(dac_info.c_params.c_range) | dac_range < 1 then
                    ok = %f;
                    error_msg = 'Wrong range selected!';
                    message(error_msg);
                end
            else
                ok = %f;
                error_msg = 'Unable to detect MicroDAQ analog outputs - run mdaq_hwinfo and try again!';
                message(error_msg);
            end

            if ok then
                dac_range = dac_info.c_params.c_range(dac_range);
                n_channels = size(channel);
                n_term_value = size(term_value);
                if  n_term_value(2) > 1 then
                    if  n_term_value(2) <> n_channels(2) then
                        message('Wrong termination value - scalar or vector for selected channels expected!')
                        ok = %f;
                    end
                    term_value = term_value';
                else
                    term_value(1:dac_ch_count) = term_value;
                end
            end

            if ok then
                [model,graphics,ok] = check_io(model,graphics, n_channels(2), [], 1, []);
                graphics.exprs = exprs;
                model.rpar = [dac_ch_count; term_value];
                model.ipar = [dac_converter;dac_range;n_channels(2);channel'];
                model.dstate = [];
                x.graphics = graphics;
                x.model = model;
                break
            end
        end
    case 'define' then
        channel=1
        term_value=0
        dac_range = 1;
        dac_converter = 1;  // TODO: to be removed
        model=scicos_model()
        model.sim=list('mdaq_dac_sim',5)
        model.in =1
        model.in2=1
        model.intyp=1
        model.out=[]
        model.evtin=1
        model.rpar = [1; term_value];
        model.ipar = [dac_converter;dac_range;1;channel'];
        model.dstate=[];
        model.blocktype='d'
        model.dep_ut=[%t %f]
        exprs=[sci2exp(channel);sci2exp(dac_range);sci2exp(term_value)]
        gr_i=['xstringb(orig(1),orig(2),[''CH:'' ; string(channel)],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
        x.graphics.style=["blockWithLabel;verticalLabelPosition=center;displayedLabel=CH:%1$s;fontColor=#5f5f5f"]
    end
endfunction
