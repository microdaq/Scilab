mdaqAITaskInit(1, [-10,10], %f, 10000, 5)
mdaqAITaskStart();
data = mdaqAITaskRead(50000, 10)
mdaqAITaskStop();

plot(data)
