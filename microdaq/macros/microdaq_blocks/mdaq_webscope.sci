function [x,y,typ] = mdaq_webscope(job,arg1,arg2)
   block_desc = ['Set WebScope parameters';
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
               [ok,ymax,ymin,trigger_level,trigger_offset,buffer_size,exprs]=..
               scicos_getvalue( block_desc,..
               ['Ymax:';'Ymin:';'Trigger level:';'Trigger offset:';'Buffer size:';],..
               list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1), exprs)
           catch
               [ok,ymax,ymin,trigger_level,trigger_offset,buffer_size,exprs]=..
               getvalue(block_desc,..
               ['Ymax:';'Ymin:';'Trigger level:';'Trigger offset:';'Buffer size:';],..
               list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1), exprs);
           end;

       if ~ok then
              break
       end

       if ok then
           [model,graphics,ok] = check_io(model,graphics, [-1], [], 1, []);
           graphics.exprs = exprs;
           model.rpar = [ymax;ymin;trigger_level;trigger_offset;buffer_size;];
           model.ipar = [];
           model.dstate = [];
           x.graphics = graphics;
           x.model = model;
           break
       end

   end
   case 'define' then
       ymax = [1;];
       ymin = [-1;];
       trigger_level = [0;];
       trigger_offset = [0;];
       buffer_size = [1000;];
       model=scicos_model();
       model.sim=list('mdaq_webscope_sim',5);
       model.in=[-1];
       model.in2=1;
       model.out=[];
       model.out2=1;
       model.outtyp=[];
       model.intyp=1;
       model.evtin=1;
       model.rpar=[ymax;ymin;trigger_level;trigger_offset;buffer_size;];
       model.ipar=[];
       model.dstate=[];
       model.blocktype='d';
       model.dep_ut=[%t %f];
       exprs=[sci2exp(ymax);sci2exp(ymin);sci2exp(trigger_level);sci2exp(trigger_offset);sci2exp(buffer_size);];
       gr_i=['xstringb(orig(1),orig(2),['''' ; ],sz(1),sz(2),''fill'');'];
       x=standard_define([4 3],model,exprs,gr_i);
       x.graphics.in_implicit=[];
       x.graphics.exprs=exprs;
   end
endfunction
