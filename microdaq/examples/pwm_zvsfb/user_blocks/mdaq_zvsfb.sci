// Generated with MicroDAQ toolbox ver: 1.3.0
function [x,y,typ] = mdaq_zvsfb(job,arg1,arg2)
   block_desc = ['Set ZVSFB parameters';
   'This block uses PWM1 and PWM2 modules to generate ZVSFB waveform';
   'It allows to set constant PWM period(frequency).';
   'FED/RED waveform poperties can be adjusted by passing value to block input.';
   '';
   'FED - Falling Edge Delay';
   'RED - Rising Edge Delay';
   '';]

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
               [ok,pwm_period,default_duty,exprs]=..
               scicos_getvalue( block_desc,..
               ['PWM period[us]:';'Default duty[%]:';],..
               list('vec',1,'vec',1), exprs)
           catch
               [ok,pwm_period,default_duty,exprs]=..
               getvalue(block_desc,..
               ['PWM period[us]:';'Default duty[%]:';],..
               list('vec',1,'vec',1), exprs);
           end;

       if ~ok then
              break
       end

       if ok then
           [model,graphics,ok] = check_io(model,graphics, [4;1;1;1;1;1], [], 1, []);
           graphics.exprs = exprs;
           model.rpar = [pwm_period;default_duty;];
           model.ipar = [];
           model.dstate = [];
           x.graphics = graphics;
           x.model = model;
           break
       end

   end
   case 'define' then
       pwm_period = [1000;];
       default_duty = [50;];
       model=scicos_model();
       model.sim=list('mdaq_zvsfb_sim',5);
       model.in=[4;1;1;1;1;1];
       model.in2=1;
       model.out=[];
       model.out2=1;
       model.outtyp=1;
       model.intyp=1;
       model.evtin=1;
       model.rpar=[pwm_period;default_duty;];
       model.ipar=[];
       model.dstate=[];
       model.blocktype='d';
       model.dep_ut=[%t %f];
       exprs=[sci2exp(pwm_period);sci2exp(default_duty);];
       gr_i=['xstringb(orig(1),orig(2),['''' ; ],sz(1),sz(2),''fill'');'];
       x=standard_define([10 7],model,exprs,gr_i);
       x.graphics.in_implicit=[];
       x.graphics.in_label = ["Duty"; "PWM1 RED"; "PWM1 FED"; "PWM2 RED"; "PWM2 FED"; "Phase"];
       x.graphics.exprs=exprs;
       x.graphics.style=["blockWithLabel;verticalLabelPosition=center;displayedLabel=ZVSFB"]

   end
endfunction
