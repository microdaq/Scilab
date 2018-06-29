function task = mdaqDSPTask()
   task = tlist(["dsptlist","init","start","read","write","stop","isDone","waitUntilDone"],..
                     mdaqDSPTaskInit,..
                     mdaqDSPTaskStart,..
                     mdaqDSPTaskRead,..
                     mdaqDSPTaskWrite,..
                     mdaqDSPTaskStop,..
                     mdaqDSPIsDone,..
                     mdaqDSPWaitUntilDone);
endfunction



