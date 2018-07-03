function task = mdaqDSPTask()
   task = tlist(["dsptlist","init","start","read","write","stop","isDone","waitUntilDone"],..
                     mdaqDSPInit,..
                     mdaqDSPStart,..
                     mdaqDSPRead,..
                     mdaqDSPWrite,..
                     mdaqDSPStop,..
                     mdaqDSPIsDone,..
                     mdaqDSPWait);
endfunction



