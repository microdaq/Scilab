ai = mdaqAITask();
ai.init(1, [-10 10], %F, 1000, -1);
ai.start();
ai.read(1000, 1);
ai.stop(); 

ai = mdaqAITask(); 
ai.init(1, [-10,10], %f, 100000, 0.005);
data = ai.read(500, 5);

ai = mdaqAITask(); 
ai.init(1, [-10,10], %f, 100000, 0.005);
[data result] = ai.read(20000, 1);

ai = mdaqAITask(); 
ai.init(1, [-10,10], %f, 100, 1);
[data result] = ai.read(1000, 1);
