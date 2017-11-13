function test()
    assert_checkerror("mdaqAIScanInit(1:18, [-100 123], %F, 10000000000, 0)"  ,           "Wrong AI channel settings - too many channels selected!")
    assert_checkerror("mdaqAIScanInit(18,   [-100 123], %F, 10000000000, 0)"  ,           "Wrong channel")
    assert_checkerror("mdaqAIScanInit(1,    [-100 123], %F, 10000000000, 0)"  ,           "Scan duration must be different from 0")
    assert_checkerror("mdaqAIScanInit(1,    [-10 10], 12, 10000000000, 0)"  ,             "Wrong mode - boolean value expected (%T/1, %F/0)")
    assert_checkerror("mdaqAIScanInit(1,    [-10 10], %F, 10000000000, 1)"  ,             "AI scan frequency out of range")
    assert_checkerror("mdaqAIScanInit(1,    [-10 10], %F, 0.9 , 1)"  ,                    "Scan frequency out of range")
    assert_checkerror("mdaqAIScanInit(1,    [-10 10], %F, 1 , 0.5)"  ,                    "Scan duration is lower than scan period")
    
    assert_checkerror("mdaqAOScanInit(1:18, ones(1000, 1),   [-10 10], %F, 10000000000, 1)",   "Wrong AO channel selected!") 
    assert_checkerror("mdaqAOScanInit(18,   ones(1000, 1),   [-101 101], %F, 1000, 1)",        "Wrong AO channel selected!") 
    assert_checkerror("mdaqAOScanInit(1,    ones(1000, 2),   [-101 101], %F, 1000, 1)",        "Wrong output data - colums should match selected channels!") 
    assert_checkerror("mdaqAOScanInit(1,    ones(1000, 1),   [-101 101], %F, 1000, 1)",        "Unsupported range")
    assert_checkerror("mdaqAOScanInit(1,    ones(1000, 1),   [-101 101], %F, 0.1, 1)",         "Scan frequency out of range")
    assert_checkerror("mdaqAOScanInit(1,    ones(1000, 1),   [-101 101], %F, 1, 0.5)",         "Scan duration is lower than scan period")
    assert_checkerror("mdaqAOScanInit(1,    ones(1000, 1),   [-10 10],   %F, 1, 0)",           "Scan duration must be different from 0")
    assert_checkerror("mdaqAOScanInit(1,    ones(1000, 1),   [-10 10],   132, 1, 0)",          "Wrong isContinuous - boolean value expected (%T/1, %F/0)")
    assert_checkerror("mdaqAOScanInit(1,    ones(2097153, 1),[-10 10],   %F, 1, 2)",           "Unable to allocate memory for AO data")
    assert_checkerror("mdaqAOScanInit(1,    ones(2097152/2 + 1, 1),[-10 10],   %T, 1, 2)",     "Unable to allocate memory for AO data")
endfunction

test();
clear test;
