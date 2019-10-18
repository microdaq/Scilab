function %aitlist_p(obj)
    mprintf("Data acquisition object\n")
    mprintf("  .init() - configures data acquisition parametes\n")
    mprintf("  .trigger() - confiures data acquisition start trigger\n")
    mprintf("  .sync() - synchronizes AI conversion with DIO rising/falling edge\n")
    mprintf("  .start() - starts data acquisition\n")
    mprintf("  .read() - reads acquired data from buffer\n")
    mprintf("  .stop() - stops data acquisition\n")

endfunction
