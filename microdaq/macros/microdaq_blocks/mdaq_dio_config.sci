// Generated with MicroDAQ toolbox ver: 1.0.
function [x,y,typ] = mdaq_dio_config(job,arg1,arg2)
    block_desc = ['This block sets DIO alternative functions';
    'and DIO bank direction.';
    '';
    'DIO alternative functions setting:';
    '0 - disable DIO alternative function (set DIO function)';
    '1 - enable DIO alternative function';
    '';
    'DIO bank direction setting:';
    '0 - configure DIO bank as an OUTPUT';
    '1 - configure DIO bank as an INPUT';
    '';
    'Warning: This block has limitations due to hardware.';
    'In case of MicroDaq E2000 bank direction is fixed. These'
    'parameters will be omitted.'
    '';
    "Set block parameters:"];

    x=[];y=[];typ=[];
    select job
    case 'set' then
        x=arg1;
        model=arg1.model;
        graphics=arg1.graphics;
        exprs=graphics.exprs;

        while %t do
            try
                getversion('scilab');
                [ok,enc1,enc2,pwm1,pwm2,pwm3,uart,bank_1_direction,bank_2_direction,bank_3_direction,bank_4_direction,exprs]=..
                scicos_getvalue( block_desc,..
                ['ENC1 function:';'ENC2 function:';'PWM1 function:';..
                'PWM2 function:';'PWM3 function:';'UART function:';..
                'DIO1...8 direction:';'DIO9...16 direction:';..
                'DIO17...24 direction:';'DIO25...32 direction:';],..
                list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1), exprs)
            catch
                [ok,enc1,enc2,pwm1,pwm2,pwm3,uart,bank_1_direction,bank_2_direction,bank_3_direction,bank_4_direction,exprs]=..
                getvalue(block_desc,..
                ['ENC1 function:';'ENC2 function:';'PWM1 function:';..
                'PWM2 function:';'PWM3 function:';'UART function:';..
                'DIO1...8 direction:';'DIO9...16 direction:';..
                'DIO17...24 direction:';'DIO25...32 direction:';],..
                list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1), exprs);
            end;

            if ~ok then
                break
            end

            if bank_1_direction == 0 then
                if uart | enc1 | enc2 then
                    ok = %f; 
                    message("Bank 1 configured as an OUTPUT - unable set selected DIO alternative functions!")
                end
            end

            if bank_2_direction <> 0 then
                if uart | pwm1 | pwm2 | pwm3 then
                    ok = %f; 
                    message("Bank 2 configured as an INPUT - unable set selected DIO alternative functions!")
                end
            end

            if ok then
                [model,graphics,ok] = check_io(model,graphics, [], [], [], []);
                graphics.exprs = exprs;
                model.ipar = [enc1;enc2;pwm1;pwm2;pwm3;uart;bank_1_direction;bank_2_direction;bank_3_direction;bank_4_direction;];
                model.rpar = [];
                model.dstate = [];
                x.graphics = graphics;
                x.model = model;
                break
            end

        end
    case 'define' then
        enc1 = [1];
        enc2 = [1];
        pwm1 = [1];
        pwm2 = [1];
        pwm3 = [1];
        uart = [1];
        bank_1_direction = [1];
        bank_2_direction = [0];
        bank_3_direction = [0];
        bank_4_direction = [1];
        model=scicos_model();
        model.sim=list('mdaq_dio_config_sim',5);
        model.in=[];
        model.in2=[];
        model.out=[];
        model.out2=[];
        model.outtyp=[];
        model.intyp=[];
        model.evtin=[];
        model.ipar=[enc1;enc2;pwm1;pwm2;pwm3;uart;bank_1_direction;bank_2_direction;bank_3_direction;bank_4_direction;];
        model.rpar=[];
        model.dstate=[];
        model.blocktype='d';
        model.dep_ut=[%t %f];
        exprs=[sci2exp(enc1);sci2exp(enc2);sci2exp(pwm1);sci2exp(pwm2);sci2exp(pwm3);sci2exp(uart);sci2exp(bank_1_direction);sci2exp(bank_2_direction);sci2exp(bank_3_direction);sci2exp(bank_4_direction);];
        gr_i=['xstringb(orig(1),orig(2),['''' ; ],sz(1),sz(2),''fill'');'];
        x=standard_define([4 3],model,exprs,gr_i);
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
    end
endfunction
