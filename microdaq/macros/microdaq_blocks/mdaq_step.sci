// Generated with MicroDAQ toolbox ver: 1.1.
function [x,y,typ] = mdaq_step(job,arg1,arg2)
   block_desc = ['Set MicroDAQ block parameters';
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
               [ok,step_time,initial_value,final_value,exprs]=..
               scicos_getvalue( block_desc,..
               ['Step time (sec):';'Initial value:';'Final value:';],..
               list('vec',1,'vec',1,'vec',1), exprs)
           catch
               [ok,step_time,initial_value,final_value,exprs]=..
               getvalue(block_desc,..
               ['Step time:';'Initial value:';'Final value:';],..
               list('vec',1,'vec',1,'vec',1), exprs);
           end;

       if ~ok then
              break
       end

       if ok then
           [model,graphics,ok] = check_io(model,graphics, [], [1], 1, []);
           graphics.exprs = exprs;
           model.rpar = [step_time;initial_value;final_value;];
           model.ipar = [];
           model.dstate = [];
           x.graphics = graphics;
           x.model = model;
           break
       end

   end
   case 'define' then
       step_time = [1;];
       initial_value = [0;];
       final_value = [1;];
       model=scicos_model();
       model.sim=list('mdaq_step_sim',5);
       model.in=[];
       model.in2=1;
       model.out=[1];
       model.out2=1;
       model.outtyp=1;
       model.intyp=1;
       model.evtin=1;
       model.rpar=[step_time;initial_value;final_value;];
       model.ipar=[];
       model.dstate=[];
       model.blocktype='d';
       model.dep_ut=[%t %f];
       exprs=[sci2exp(step_time);sci2exp(initial_value);sci2exp(final_value);];
       gr_i=['xstringb(orig(1),orig(2),['''' ; ],sz(1),sz(2),''fill'');'];
       x=standard_define([3 2],model,exprs,gr_i);
       x.graphics.in_implicit=[];
       x.graphics.exprs=exprs;
   end
endfunction
