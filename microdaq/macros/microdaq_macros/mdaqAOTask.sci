function task = mdaqAOTask()
   task = tlist(["aotlist","init","start","write","stop","isDone","waitUntilDone", "setTrigger"],..
                     mdaqAOScanInit,..
                     mdaqAOScanStart,..
                     mdaqAOScanData,..
                     mdaqAOScanStop,..
                     mdaqAOScanIsDone,..
                     mdaqAOScanWait,..
                     mdaqAOScanTrigger);
endfunction



