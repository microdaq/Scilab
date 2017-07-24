// Make 'UART Receive' block definition 
uartRead = mdaq_block() 
uartRead.name = "UART Receive";
uartRead.param_name = [];
uartRead.in = [];
uartRead.out = [1]; 
uartRead.use_sim_script = %T;

// Make 'UART Transmit' block definition  
uartWrite = mdaq_block() 
uartWrite.name = "UART Transmit";
uartWrite.param_name = [];
uartWrite.in = [1];
uartWrite.out = []; 
uartWrite.use_sim_script = %T;

mdaq_block_add(uartRead);
mdaq_block_add(uartWrite);
 
 
