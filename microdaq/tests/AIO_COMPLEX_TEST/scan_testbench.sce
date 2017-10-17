//--------------- LOAD UTILS --------------------
clc;
mdaq_close();
mdaq_hwinfo();

if exists("mdaq_ao_test") == 0 then
    exec(mdaq_toolbox_path() + "tests\AIO_COMPLEX_TEST\mdaq_aio_test_utils.sci", -1);
end 
exec(mdaq_toolbox_path() + "tests\AIO_COMPLEX_TEST\test_defines.sce", -1);

//--------------- BEGIN TEST  --------------------

// Check errors 
exec(mdaq_toolbox_path() + "tests\AIO_COMPLEX_TEST\scan_errors_test.sce", -1);

// Stream mode 
exec(mdaq_toolbox_path() + "tests\AIO_COMPLEX_TEST\scan_stream1_test.sce", -1);

// Periodic mode 
exec(mdaq_toolbox_path() + "tests\AIO_COMPLEX_TEST\scan_periodic1_test.sce", -1);

// Simple test 
exec(mdaq_toolbox_path() + "tests\AIO_COMPLEX_TEST\ao_simple_test.sce", -1);
