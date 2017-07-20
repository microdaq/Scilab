/* gpio_spi.h -- SPI driver for MicroDAQ device
 *
 * Copyright (C) 2013 Embedded Solutions
 * All rights reserved.
 *
 * This software may be modified and distributed under the terms
 * of the BSD license.  See the LICENSE file for details.
 */
 
#if (!defined MATLAB_MEX_FILE) && (!defined MDL_REF_SIM_TGT) 
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

typedef struct mdaq_spi_dev_{
    uint8_t cs;
    uint8_t miso;
    uint8_t mosi;
    uint8_t clk;
    uint8_t phrase;
    uint8_t polarity;
    uint8_t cs_active;
    uint8_t rsv;
}mdaq_spi_dev;



int mdaq_spi_init(mdaq_spi_dev *dev);
int mdaq_spi_xfer(mdaq_spi_dev *dev, int mode, void *in, void *out, int size);
#endif
