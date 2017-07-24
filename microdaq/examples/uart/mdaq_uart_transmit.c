/* Generated with MicroDAQ toolbox ver: 1.2.0 */
#include "scicos_block4.h"
#include <stdio.h>
#include <stdlib.h>

//#define _TMS320C6X
#ifdef _TMS320C6X
    #include "mdaq_uart.h"
#endif 
    

extern double get_scicos_time( void );

/* This function executed once at the beginning of model execution */
static void init(scicos_block *block)
{
    /* Block parameters */
    double *params = GetRparPtrs(block);

    /* param size = 1 */
    double param1 = params[0];

    /* Add block init code here */
#ifdef _TMS320C6X
    mdaq_uart_config_t uart;
    uart.baud_rate = B115200;
    uart.data_bits = 8;
    uart.parity = PARITY_NONE;
    uart.stop_bits = STOP_BITS_1;

    mdaq_uart_open(&uart);
#endif 

}

/* This function be executed on every model step */
static void inout(scicos_block *block)
{
    char buffer[64];
    int n;
    
    /* Block parameters */
    double *params = GetRparPtrs(block);
    /* param size = 1 */
    double param1 = params[0];

    /* Block input ports */
    double *u1 = GetRealInPortPtrs(block,1);
    int u1_size = GetInPortRows(block,1);    /* u1_size = 1 */

    n = sprintf(buffer, "value: %f\r\n", (float)*u1);

    /* Add block code here (executed every model step) */
#ifdef _TMS320C6X
    mdaq_uart_write((void*)buffer, n);
#endif 
}

/* This function be executed once at the end of model execution (only in Ext mode) */
static void end(scicos_block *block)
{
    /* Prameters */
    double *params = GetRparPtrs(block);

    /* param size = 1 */
    double param1 = params[0];

    /* Add block end code here */
}

void mdaq_uart_transmit(scicos_block *block,int flag)
{
    if (flag == 1){            /* set output */
        inout(block);
    }
    else if (flag == 5){       /* termination */
        end(block);
    }
    else if (flag == 4){       /* initialisation */
        init(block);
    }
}
 
 

