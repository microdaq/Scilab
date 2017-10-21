//--------------- LOAD UTILS --------------------
clc;
mdaqClose();
mdaqHWInfo();

if exists("mdaq_ao_test") == 0 then
    exec(mdaqToolboxPath() + "tests\AIO_COMPLEX_TEST\mdaq_aio_test_utils.sci", -1);
end 
exec(mdaqToolboxPath() + "tests\AIO_COMPLEX_TEST\test_defines.sce", -1);

//--------------- BEGIN TEST  --------------------

// Check errors 
exec(mdaqToolboxPath() + "tests\AIO_COMPLEX_TEST\scan_errors_test.sce", -1);

// Stream mode 
exec(mdaqToolboxPath() + "tests\AIO_COMPLEX_TEST\scan_stream1_test.sce", -1);

// Periodic mode 
exec(mdaqToolboxPath() + "tests\AIO_COMPLEX_TEST\scan_periodic1_test.sce", -1);

// Simple test 
exec(mdaqToolboxPath() + "tests\AIO_COMPLEX_TEST\ao_simple_test.sce", -1);
