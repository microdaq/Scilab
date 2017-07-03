// Generated with MicroDAQ toolbox ver: 1.1.
function [x,y,typ] = mdaq_pid_z(job,arg1,arg2)
   block_desc = [
   'This block is a PID controller in a discrete time domain.';
   'E - PID error input';
   'T - PID tracking input';
   'G - PID gains input (Kp, Ki, Kd)';
   '';
   'Set PID(z) parameters';
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
               [ok,filter_coefficient,upper_sat_limit,lower_sat_limit,back_calculation_kb,tracking_kt,sample_time,exprs]=..
               scicos_getvalue( block_desc,..
               ['Filter coefficient:';'Upper sat limit:';'Lower sat limit:';'Back calculation Kb:';'Tracking Kt:';'Sample time:';],..
               list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1), exprs)
           catch
               [ok,filter_coefficient,upper_sat_limit,lower_sat_limit,back_calculation_kb,tracking_kt,sample_time,exprs]=..
               getvalue(block_desc,..
               ['Filter coefficient:';'Upper sat limit:';'Lower sat limit:';'Back calculation Kb:';'Tracking Kt:';'Sample time:';],..
               list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1), exprs);
           end;

       if ~ok then
              break
       end

       if ok then
           [model,graphics,ok] = check_io(model,graphics, [1;1;3], [1], 1, []);
           graphics.exprs = exprs;
           model.rpar = [filter_coefficient;upper_sat_limit;lower_sat_limit;back_calculation_kb;tracking_kt;sample_time;];
           model.ipar = [];
           model.dstate = [];
           x.graphics = graphics;
           x.model = model;
           break
       end

   end
   case 'define' then
       filter_coefficient = [100;];
       upper_sat_limit = [10000000;];
       lower_sat_limit = [-10000000;];
       back_calculation_kb = [0;];
       tracking_kt = [0;];
       sample_time = [0.001;];
       model=scicos_model();
       model.sim=list('mdaq_pid_z',4);
       model.in=[1;1;3];
       model.in2=1;
       model.out=[1];
       model.out2=1;
       model.outtyp=1;
       model.intyp=1;
       model.evtin=1;
       model.rpar=[filter_coefficient;upper_sat_limit;lower_sat_limit;back_calculation_kb;tracking_kt;sample_time;];
       model.ipar=[];
       model.dstate=[];
       model.blocktype='d';
       model.dep_ut=[%t %f];
       exprs=[sci2exp(filter_coefficient);sci2exp(upper_sat_limit);sci2exp(lower_sat_limit);sci2exp(back_calculation_kb);sci2exp(tracking_kt);sci2exp(sample_time);];
       gr_i=['xstringb(orig(1),orig(2),['''' ; ],sz(1),sz(2),''fill'');'];
       x=standard_define([4 3],model,exprs,gr_i);
       x.graphics.in_implicit=[];
       x.graphics.exprs=exprs;
       x.graphics.style=[]
       x.graphics.in_label = ["E", "T", "G"];
   end
endfunction
