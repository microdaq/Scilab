mdaq_dio_func(1, %F)
mdaq_dio_func(2, %F)
mdaq_dio_func(3, %F)
mdaq_dio_func(4, %F)
mdaq_dio_func(5, %F)
mdaq_dio_func(6, %F)

state = 1;
mdaq_dio_write(9,state)
disp(mdaq_dio_read(1))


mdaq_dio_write(10,state)
disp(mdaq_dio_read(2))


mdaq_dio_write(11,state)
disp(mdaq_dio_read(3))


mdaq_dio_write(12,state)
disp(mdaq_dio_read(4))

input("Press any key...");

state = 0;
mdaq_dio_write(9,state)
disp(mdaq_dio_read(1))


mdaq_dio_write(10,state)
disp(mdaq_dio_read(2))


mdaq_dio_write(11,state)
disp(mdaq_dio_read(3))


mdaq_dio_write(12,state)
disp(mdaq_dio_read(4))

