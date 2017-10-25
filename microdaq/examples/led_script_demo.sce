// Switch LED1/LED2 on/off every 0.5 sec
LEDState1 = %F;
for i=1:10 
    mdaqLEDWrite(1, LEDState1);
    mdaqLEDWrite(2, ~LEDState1);
    
    LEDState1 = ~LEDState1;
    sleep(500);
end

mdaqLEDWrite(1, %F);
mdaqLEDWrite(2, %F);
