function %aotlist_p(obj)
    mprintf("Signal generation object\n")
    mprintf("  .init() - configures signal generation parametes\n")
    mprintf("  .trigger() - confiures signal generation start trigges\n")
    mprintf("  .write() - queues data to be output\n")
    mprintf("  .start() - starts signal generation\n")
    mprintf("  .isDone() - checks if signal generation is complited\n")
    mprintf("  .waitUntilDone() - waits until signal generation is complited\n")
    mprintf("  .stop() - stops signal generation\n")
endfunction
