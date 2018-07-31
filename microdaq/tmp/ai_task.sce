ai = mdaqTask("ai");
dsp = mdaqTask("dsp"); 

//dsp.init("led_demo_scig/led_demo.out", -1, -1)
//dsp.start()



ai.init(1, [-10,10], %f, 1000, 1)

data = ai.read(1000, 10)

plot(data)

