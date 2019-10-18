ai  = mdaqTask("ai");
dsp = mdaqTask("dsp");
ao  = mdaqTask("ao");

mdaqEncoderInit(2,0);
ao_data = 0.1:0.1:5;

ai.init(1, [-10,10], %f, 1000, 1);
ao.init(1, ao_data', [0,5], %f, 1000, 5);
//dsp.init("led_demo_scig/led_demo.out", 0.1, 4)

ao.setTrigger("encoderValue", 2, 0, 1)
ai.setTrigger("aoScan")

ai.start(); 
ao.start(); 
ao.waitUntilDone(10);

data = ai.read(1000, 10)

plot(data)
return 

ao.start()
ao.waitUntilDone(10)

dsp.start();
dsp.waitUntilDone(10);


