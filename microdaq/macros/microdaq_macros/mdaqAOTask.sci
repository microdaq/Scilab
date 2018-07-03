function task = mdaqAOTask()
   task = tlist(["aotlist","init","start","write","stop","isDone","waitUntilDone", "setTrigger"],..
                     mdaqAOScanInit,..
                     mdaqAOScan,..
                     mdaqAOScanData,..
                     mdaqAOScanStop,..
                     mdaqAOScanIsDone,..
                     mdaqAOScanWait,..
                     mdaqAOScanTrigger);
endfunction



