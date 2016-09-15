function [x,y,typ] = mdaq_square(job,arg1,arg2)
// Real-time square waveform. 
//
// Block Screenshot
//
// Description
//
// Real-time square waveform. The Square block lets you adjust amplitude [1], period
// [4] (s), pulse width [2] (s), bias [0], and delay [0] (s). You can also adjust parameters from
// xrtailab/qrtailab or other programs during real-time execution.
//
// Dialog box
//
// Amplitude: amplitude [1]
// Period: period [4] (s)
// Impulse width: pulse width [2] (s)
// Bias:bias [0]
// Delay:delay [0] (s)
//
  x=[];y=[];typ=[];
  select job
  case 'plot' then
    exprs=arg1.graphics.exprs;    
    standard_draw(arg1)
  case 'getinputs' then
    [x,y,typ]=standard_inputs(arg1)
  case 'getoutputs' then
    [x,y,typ]=standard_outputs(arg1)
  case 'getorigin' then
    [x,y]=standard_origin(arg1)
  case 'set' then
    x=arg1
    model=arg1.model;graphics=arg1.graphics;
    exprs=graphics.exprs;
    while %t do
      try
     getversion('scilab');
     [ok,A,prd,pulse,bias,delay,exprs]=..
      scicos_getvalue('Set MicroDAQ square block parameters',..
      ['Amplitude:';
       'Period (sec):';
       'Impulse width (sec):';
       'Bias:';
       'Delay (sec):'],..
      list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1),exprs)
     catch
 [ok,A,prd,pulse,bias,delay,exprs]=..
     getvalue('Set MicroDAQ square block parameters',..
      ['Amplitude:';
       'Period (sec):';
       'Impulse width (sec):';
       'Bias:';
       'Delay (sec):'],..
      list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1),exprs)
     end;
     
      if ~ok then break,end
      if exists('outport') then out=ones(outport,1), in=[], else out=1, in=[], end
      [model,graphics,ok]=check_io(model,graphics,in,out,1,[])
      if ok then
        graphics.exprs=exprs;
        model.rpar=[A;prd;pulse;bias;delay];
        model.ipar=[];
        model.dstate=[];
        x.graphics=graphics;x.model=model
        break
      end
    end
  case 'define' then
    A=1
    prd=4
    pulse=2
    bias=0
    delay=0
    model=scicos_model()
    model.sim=list('mdaq_square_sim',5)
    if exists('outport') then model.out=ones(outport,1), model.in=[], else model.out=1, model.in=[], end
    model.evtin=1
    model.rpar=[A;prd;pulse;bias;delay]
    model.ipar=[]
    model.dstate=[];
    model.blocktype='d'
    model.dep_ut=[%t %f]
    exprs=[sci2exp(A);sci2exp(prd);sci2exp(pulse);sci2exp(bias);sci2exp(delay)]
    gr_i=['xstringb(orig(1),orig(2),[''Square''],sz(1),sz(2),''fill'');']
    x=standard_define([3 2],model,exprs,gr_i)
  end
endfunction
