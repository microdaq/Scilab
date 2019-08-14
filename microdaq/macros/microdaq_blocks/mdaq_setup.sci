function [x,y,typ] = mdaq_setup(job,arg1,arg2)
    setup_desc = ["Setup block";
    "";
    "This block sets model compilation and execution properties. Duration";
    "parameter defined in seconds sets execution duration for Ext mode.";
    "If Standalone mode is selected this parameter will be ignored";
    "and applicaiton will run infinitely.";
    "";
    "Build parameter allows to select Release or Debug build type."
    "Debug build type allows to debug generated application with ";
    "Code Composer Studio, while Release will result optimized application.";
    "";
    "Mode parameters allows to select between Ext and Standalone";
    "application. Profiling allows to enable model execution profiling";
    "Solver allows to select ODE solvers for continous time models."
    "";
    "Duration:";
    "-1 - INF (infinite time)"
    "";
    "Build:";
    "0 - Debug";
    "1 - Release";
    "";
    "Mode:";
    "0 - Standalone";
    "1 - Ext";
    "";
    "Solver:";
    "1,2,4 - ODE1, ODE2, ODE4";
    "";
    "Enter Setup block settings:";
    ];

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
                [ok,duration,build_mode,standalone,en_profile,solver_type,exprs]=..
                scicos_getvalue(setup_desc,..
                ['Duration:';
                'Build:';
                'Mode:';
                'Profiling:';
                'Solver:'],..
                list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1),exprs)
            catch
                [ok,duration,build_mode,standalone,en_profile,solver_type,exprs]=..
                scicos_getvalue(setup_desc,..
                ['Duration:';
                'Build:';
                'Mode:';
                'Profiling:';
                'Solver:'],..
                list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1),exprs)
            end;

            if ~ok then
                break
            end

           //Max value that we can compile normally 
            if duration > 99999999 then
                duration = 99999999;
            end
 
            if standalone > 1 | standalone < 0 then
                ok = %f;
                message("Use values 0 or 1 to set model mode.")
            end

            if build_mode > 1 | build_mode < 0 then
                ok = %f;
                message("Use values 0 or 1 to set build mode.")
            end

            if ok then
                [model,graphics,ok] = check_io(model,graphics, [], [], [], []);
                
                model.rpar = [duration];
                model.ipar=[build_mode;standalone;en_profile;solver_type];
                model.dstate = [];
  
                graphics.exprs = exprs;
                
                x.graphics = graphics;
                x.model = model;            
                
                if duration == -1 then
                    duration_style = "Duration:INF";
                else
                    duration_style = "Duration:%ss";
                end
  
                x.graphics.style=["mdaq_setup;blockWithLabel;displayedLabel="+duration_style+""]
                break
            end
        end
    case 'define' then
        duration = 10;
        build_mode = 0;
        standalone = 1;
        en_profile = 0;
        solver_type = 1;  
        model=scicos_model()
        model.sim=list('mdaq_setup',99)
        model.in =[];
        model.in2=[];
        model.intyp=[];
        model.out=[];
        model.evtin=[];
        model.rpar=[duration];
        model.ipar=[build_mode;standalone;en_profile;solver_type];
        model.dstate=[];
        model.blocktype='d'
        model.dep_ut=[%t %f]
        exprs=[sci2exp(duration);sci2exp(build_mode);sci2exp(standalone);sci2exp(en_profile);sci2exp(solver_type)]
        gr_i=['xstringb(orig(1),orig(2),[''SETUP'' ; string(duration)],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
        x.graphics.style=["mdaq_setup;blockWithLabel;displayedLabel=10s"]
    end
endfunction
