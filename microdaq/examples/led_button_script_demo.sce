// Press F1 button to turn on LED1
// Press F2 button to stop demo 

linkID = mdaqOpen(); // for better performance 

while mdaqKeyRead(linkID, 2) == %F
    buttonState = mdaqKeyRead(linkID, 1);
    mdaqLEDWrite(linkID, 1, buttonState);
    sleep(50);
end

mdaqClose();

disp("Demo has been stopped.");


