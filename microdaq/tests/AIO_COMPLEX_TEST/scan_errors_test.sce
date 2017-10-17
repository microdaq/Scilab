function test()
    assert_checkerror("mdaq_ai_scan_init(1, [-10.24 10.24], %F, 10000000000, 1)", "AI scan frequency out of range") 
    assert_checkerror("mdaq_ai_scan_init(1, [-101 101], %F, 1000, 1)", "Unsupported range") 
    assert_checkerror("mdaq_ao_scan_init(1, ones(1, 1000)'', [-10 10], %F, 10000000000, 1)", "Scan frequency out of range") 
    assert_checkerror("mdaq_ao_scan_init(1, ones(1, 1000)'', [-101 101], %F, 1000, 1)", "Unsupported range") 
endfunction

test();
clear test;
