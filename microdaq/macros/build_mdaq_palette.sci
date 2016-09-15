function [res] = build_mdaq_palette(palette_path)
    toolbox_dir = mdaq_toolbox_path();  
    xpal = list();

    //Create complete mdaq palette
    if isdef("gen_palette") == %T then
        //load xcos library
        if isdef("c_pass1") == %F then
            loadXcosLibs();
        end
    end

    //Temporary (load & use them somewhere else)
    blocks = [
    "mdaq_sinus"
    "mdaq_square"
    "mdaq_step"
    ];
    xpal_temp = tbx_build_pal(toolbox_dir, "temp_blocks", blocks);
    xcosPalAdd( xpal_temp, ['temp']);


    // MicroDAQ
    blocks = ["mdaq_adc"
    "mdaq_dac"
    "mdaq_dio_config"
    "mdaq_dio_get"
    "mdaq_dio_set"
    "mdaq_encoder"
    "mdaq_func_key"
    "mdaq_led"
    "mdaq_mem_read"
    "mdaq_mem_write"
    "mdaq_pru_reg_get"
    "mdaq_pru_reg_set"
    "mdaq_pwm"
    "mdaq_signal"
    "mdaq_param"
    "mdaq_tcp_recv"
    "mdaq_tcp_send"
    "mdaq_udp_recv"
    "mdaq_udp_send"
    "mdaq_to_file"
    "mdaq_uart_config"
    "mdaq_uart_read"
    "mdaq_uart_write"
    "mdaq_webscope"
    "mdaq_time"
    "mdaq_stop"
    "mdaq_setup"
    ];
    xpal($+1) = tbx_build_pal(toolbox_dir, "MicroDAQ", blocks);

    // Commonly Used Blocks
    blocks = ["mdaq_setup"
    "mdaq_signal"
    "mdaq_adc"
    "mdaq_dac"
    "CONST_m"
    "MUX"
    "DEMUX"
    "CLOCK_c"
    "IFTHEL_f"
    "CSCOPE"
    "TOWS_c"
    ];
    xpal($+1) = tbx_compose_pal('Commonly Used Blocks', blocks);

    //Continuous time systems
    blocks = ["CLSS"
    "DERIV"
    "INTEGRAL_m"
    "TCLSS"
    "VARIABLE_DELAY"
    ];
    xpal($+1) = tbx_compose_pal('Continuous time systems', blocks);

    //Discontinuities
    blocks = ["SATURATION"
    "BACKLASH"
    "DEADBAND"
    "HYSTHERESIS"
    "RATELIMITER"
    ];
    xpal($+1) = tbx_compose_pal('Discontinuities', blocks);

    //Discrete time systems
    blocks = ["mdaq_pid_z"
    "DLR"
    "DLSS"
    "DOLLAR"
    "DOLLAR_m"
    "REGISTER"
    "SAMPHOLD_m"
    "TCLSS"
    ];
    xpal($+1) = tbx_compose_pal('Discrete time systems', blocks);

    //Lookup Tables
    //    blocks = [];
    //    xpal($+1) = tbx_compose_pal('Lookup Tables', blocks);
    //   

    //Event handling
    blocks = ["CLOCK_c"
    "SampleCLK"
    "CLKFROM"
    "CLKGOTO"
    "CLKOUTV_f"
    "CLKSOMV_f"
    "EDGE_TRIGGER"
    "ESELECT_f"
    "EVTGEN_f"
    "Extract_Activation"
    "M_freq"
    "MCLOCK_f"
    "MFCLCK_f"
    "freq_div"
    "IFTHEL_f"
    ];
    xpal($+1) = tbx_compose_pal('Event handling', blocks);

    //Mathematical Operations
    blocks = ["ABS_VALUE"
    "BIGSOM_f"
    "EXPBLK_m"
    "GAINBLK"
    "MAXMIN"
    "PROD_f"
    "PRODUCT"
    "SIGNUM"
    "SQRT"
    "SUM_f"
    "SUMMATION"
    "TrigFun"
    ];
    xpal($+1) = tbx_compose_pal('Mathematical Operations', blocks);

    //Matrix
    blocks = ["CUMSUM"
    "EXTRACT"
    "MATCATV"
    "MATMAGPHI"
    "MATMUL"
    "MATRESH"
    "MATSUM"
    "SQRT"
    "SUBMAT"
    ];
    xpal($+1) = tbx_compose_pal('Matrix', blocks);

    //Integer
    blocks = ["BITCLEAR"
    "BITSET"
    "DLATCH"
    "EXTRACTBITS"
    "INTMUL"
    "JKFLIPFLOP"
    ];
    xpal($+1) = tbx_compose_pal('Integer', blocks);

    //Port & Subsystem
    blocks = ["CLKINV_f"
    "CLKOUTV_f"
    "SUPER_f"
    ];
    xpal($+1) = tbx_compose_pal('Port & Subsystem', blocks);

    //    //Zero crossing detection
    //    blocks = [];
    //    xpal($+1) = tbx_compose_pal('Zero crossing detection', blocks);   

    //Signal Routing
    blocks = ["DEMUX"
    "MUX"
    "FROM"
    "GOTO"
    "CLKFROM"
    "CLKGOTO"
    "ISELECT_m"
    "M_SWITCH"
    "SELECT_m"
    "SWITCH2_m"
    ];
    xpal($+1) = tbx_compose_pal('Signal Routing', blocks);

    //Signal Processing
    blocks = ["SAMPHOLD_m"];
    xpal($+1) = tbx_compose_pal('Signal Processing', blocks);

    //    //Implicit
    //    blocks = [];
    //    xpal($+1) = tbx_compose_pal('Implicit', blocks);

    //    //Annotations
    //    blocks = [];
    //    xpal($+1) = tbx_compose_pal('Annotations', blocks); 

    //Sinks
    blocks = ["AFFICH_m"
    "CLKOUTV_f"
    "CSCOPE"
    "CMSCOPE"
    "OUT_f"
    "TOWS_c"
    ];
    xpal($+1) = tbx_compose_pal('Sinks', blocks);   

    //Sources
    blocks = ["CLKINV_f"
    "CLOCK_c"
    "CONST_m"
    "CONST"
    "mdaq_sinus"
    "mdaq_square"
    "mdaq_step"];
    xpal($+1) = tbx_compose_pal('Sources', blocks);    

    //User-Defined Functions
    blocks = ["SUPER_f"];
    xpal($+1) = tbx_compose_pal('User-Defined Functions', blocks);


    for i=1:size(xpal)
        xcosPalAdd(xpal(i), ['MicroDAQ']);
        if i < 10 then 
            idx = "0"+string(i);
        else
            idx = string(i);
        end
        xcosPalExport(xpal(i), palette_path+filesep()+idx+".sod");
    end

    xcosPalDelete("temp");
    res = 0;
endfunction
