// Generated with MicroDAQ toolbox ver: 1.0.
function [x,y,typ] = mdaq_stop(job,arg1,arg2)
   x=[];y=[];typ=[];
   select job
   case 'set' then
       x=arg1;
   case 'define' then
       model=scicos_model();
       model.sim=list('mdaq_stop_sim',5);
       model.in=[1];
       model.in2=1;
       model.out=[];
       model.out2=[];
       model.outtyp=1;
       model.intyp=1;
       model.evtin=1;
       model.rpar=[];
       model.ipar=[];
       model.dstate=[];
       model.blocktype='d';
       model.dep_ut=[%t %f];
       exprs=[];
       gr_i=['xstringb(orig(1),orig(2),['''' ; ],sz(1),sz(2),''fill'');'];
       x=standard_define([4 3],model,exprs,gr_i);
       x.graphics.in_implicit=[];
       x.graphics.exprs=exprs;
   end
endfunction
