function [x,y,typ] = mdaq_dac(job,arg1,arg2)
    global %microdaq;
    dac_desc = ["This block writes data to MicroDAQ analog output module (AO).";
    "Block detects MicroDAQ analog output type and allows";
    "setting output range, initial and termination voltage.";
    "The Range value can be a scalar or a vector that must ";
    "be the same length as the channel vector. If scalar value";
    "is specified, that setting is replicated over the channel vector."; 
    "Different ranges can be set for each channel if ADC supports ";
    "more then one output range.";
    "The Initial and Termination property can be a scalar or a vector"; 
    "";
    "Use Init/Term parameter allows to enable or disable setting";
    "initial or/and termination voltage values. User can provide";
    "scalar or vector with following values:";
    "0 - Initial and termination voltage value is ignored";
    "1 - Initial voltage value is used";
    "2 - Termination voltage value is used";
    "3 - Initial and termination voltage value is used";
    "";
    "Use mdaqHWInfo to get DAC parameters"
    "";
    "input - value in volts"
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
                [ok,channels,dac_range,init_value,term_value,use_init_term,exprs]=..
                    scicos_getvalue(dac_desc,..
                                    ['Channels:';
                                    'Range:';
                                    'Initial value:';
                                    'Termination value:';
                                    'Use Init/Term:'],..
                                    list('vec',-1,'mat',[-1,-1],'vec',-1,'vec',-1,'vec',-1),exprs)
            catch
                [ok,channels,dac_range,init_value,term_value,use_init_term,exprs]=..
                    scicos_getvalue(dac_desc,..
                                    ['Channels:';
                                    'Range:';
                                    'Initial value:';
                                    'Termination value:';
                                    'Use Init/Term:'],..
                                    list('vec',-1,'mat',[-1,-1],'vec',-1,'vec',-1,'vec',-1),exprs)
            end;

            if ~ok then
                break
            end

            if %microdaq.private.mdaq_hwid <> [] then
                dac_id = %microdaq.private.mdaq_hwid(3);
                if find(dac_id == get_dac_list()) == [] then
                    ok = %f;
                    message("Configuration not detected - run mdaqHWInfo and try again!");
                end

                n_channels = size(channels, 'c');
                if ok & size(channels, 'r') > 1 then
                    message("Single row channel vector expected!")
                    ok = %f;
                end

                // check Range parameter
                if ok & size(dac_range, 'c') <> 2 then
                    message("Vector range [low,high;low,high;...] expected!")
                    ok = %f;
                end

                dac_range_size = size(dac_range, 'r');
                if ok & (dac_range_size > 1) & (dac_range_size <> n_channels) then
                    ok = %f;
                    error_msg = 'Wrong range vector - size should match channel vector!';
                    message(error_msg);
                end

                // check Init value parameter
                if ok & (size(init_value, 'r') > 1) then
                    ok = %f;
                    error_msg = 'Wrong Init value vector - single row vector expected!';
                    message(error_msg);
                end

                init_value_size = size(init_value, 'c');
                if ok & (init_value_size > 1) & (init_value_size <> n_channels) then
                    ok = %f;
                    error_msg = 'Wrong init value vector - scalar or vector for selected channels expected!';
                    message(error_msg);
                end

                // check Termination value parameter
                if ok & (size(term_value, 'r') > 1) then
                    ok = %f;
                    error_msg = 'Wrong termination value vector - single row vector expected!';
                    message(error_msg);
                end

                term_value_size = size(term_value, 'c');
                if ok & (term_value_size > 1) & (term_value_size <> n_channels) then
                    ok = %f;
                    error_msg = 'Wrong termination value vector - scalar or vector for selected channels expected!';
                    message(error_msg);
                end
                
                // check init term enable
                if ok & (find(use_init_term > 3) <> []) | (find(use_init_term < 0) <> []) then
                    ok = %f;
                    error_msg = 'Wrong Use init/term paremeter value!';
                    message(error_msg);
                end
                    
                if ok & (size(use_init_term, 'r') > 1) then
                    ok = %f;
                    error_msg = 'Wrong Use init/term paremeter vector - single row vector expected!';
                    message(error_msg);
                end

                use_init_term_size = size(use_init_term, 'c');
                if ok & (use_init_term_size > 1) & (use_init_term_size <> n_channels) then
                    ok = %f;
                    error_msg = 'Wrong Use init/term paremeter vector - scalar or vector for selected channels expected!';
                    message(error_msg);
                end
                
                if dac_range_size == 1 & ok then
                    range_tmp = dac_range;
                    dac_range = ones(n_channels,2);
                    dac_range(:,1) = range_tmp(1);
                    dac_range(:,2) = range_tmp(2);
                end
                
                if ok & ~exists("%scicos_prob") then
                    result = dac_check_params(channels, dac_range);
                    if result < 0 then
                        message(mdaq_error2(result));
                        ok = %f;
                    end
                end
            else
                ok = %f;
                error_msg = 'Unable to detect MicroDAQ analog outputs - run mdaqHWInfo and try again!';
                message(error_msg);
            end

            if ok then
                [model,graphics,ok] = check_io(model,graphics, n_channels, [], 1, []);
                graphics.exprs = exprs;

                // init value
                if init_value_size == 1 then
                    init_value = ones(n_channels, 1) * init_value;
                else
                    init_value = init_value';
                end
   
                // termination value
                if term_value_size == 1 then
                    term_value = ones(n_channels, 1) * term_value;
                else 
                    term_value = term_value';
                end

                // init term enable value
                if use_init_term_size == 1 then
                    use_init_term = ones(n_channels, 1) * use_init_term;
                else 
                    use_init_term = use_init_term';
                end
 
                // set IPAR and RPAR
                model.ipar = [n_channels; channels'; use_init_term];
                model.rpar = [init_value; term_value; matrix(dac_range', 1, n_channels*2)'];

                model.dstate = [];
                x.graphics = graphics;
                x.model = model;
                x.graphics.style=["mdaq_dac;blockWithLabel;verticalLabelPosition=center;displayedLabel=CH:%1$s;fontColor=#5f5f5f"]
                break
            end
        end
    case 'define' then 
        channels=1
        dac_range = [0,5];
        init_value = 0;
        term_value = 0;
        use_init_term = 2;
        n_channels = 1;
        model=scicos_model();
        model.sim=list('mdaq_dac_sim',5);
        model.in =1;
        model.in2=1;
        model.intyp=1;
        model.out=[];
        model.evtin=1;
        model.ipar = [n_channels; channels'; use_init_term];
        model.rpar = [init_value; term_value; dac_range'];
        model.dstate=[];
        model.blocktype='d';
        model.dep_ut=[%t %f];
        exprs=[sci2exp(channels);sci2exp(dac_range);sci2exp(init_value);sci2exp(term_value);sci2exp(use_init_term)];
        gr_i=['xstringb(orig(1),orig(2),[''CH:'' ; string(channels)],sz(1),sz(2),''fill'');'];
        x=standard_define([4 3],model,exprs,gr_i);
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
        x.graphics.style=["blockWithLabel;verticalLabelPosition=center;displayedLabel=CH:%1$s;fontColor=#5f5f5f"]
    end
endfunction
