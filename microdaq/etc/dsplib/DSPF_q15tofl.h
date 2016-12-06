/* ======================================================================= */
/* DSPF_q15tofl.h -- Q15 to Float conversion                               */
/*                  Optimized C Implementation (w/ Intrinsics)             */
/*                                                                         */
/* Rev 0.0.1                                                               */
/*                                                                         */
/* Copyright (C) 2011 Texas Instruments Incorporated - http://www.ti.com/  */ 
/*                                                                         */
/*                                                                         */
/*  Redistribution and use in source and binary forms, with or without     */
/*  modification, are permitted provided that the following conditions     */
/*  are met:                                                               */
/*                                                                         */
/*    Redistributions of source code must retain the above copyright       */
/*    notice, this list of conditions and the following disclaimer.        */
/*                                                                         */
/*    Redistributions in binary form must reproduce the above copyright    */
/*    notice, this list of conditions and the following disclaimer in the  */
/*    documentation and/or other materials provided with the               */
/*    distribution.                                                        */
/*                                                                         */
/*    Neither the name of Texas Instruments Incorporated nor the names of  */
/*    its contributors may be used to endorse or promote products derived  */
/*    from this software without specific prior written permission.        */
/*                                                                         */
/*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS    */
/*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT      */
/*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR  */
/*  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT   */
/*  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,  */
/*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT       */
/*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,  */
/*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY  */
/*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT    */
/*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE  */
/*  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.   */
/*                                                                         */
/* ======================================================================= */

#ifndef DSPF_Q15TOFL_H_
#define DSPF_Q15TOFL_H_ 1

#ifndef __TI_COMPILER_VERSION__           // for non TI compiler
#include "assert.h"                       // intrinsics prototypes
#include "C6xSimulator.h"                 // intrinsics prototypes
#include "C6xSimulator_type_modifiers.h"  // define/undefine typing keywords
#endif

/** @ingroup MISC */
/* @{ */

/** @defgroup DSPF_q15tofl */
/** @ingroup DSPF_q15tofl */
/* @{ */

/**
 * 	   Converts the values stored in vector x[ ] in Q.15 format to
 *     IEEE floating point numbers in output vector r[ ]
 * 
 * 			@param q15 = Pointer to Q.15 input vector of size nx
 * 			@param flt = Pointer to floating-point output data vector of size nx 
 *                   containing the floating-point equivalent of vector x
 * 			@param nx  = Length of input and output data vectors
 * 
 * @par Algorithm:
 * DSPF_q15tofl_cn.c is the natural C equivalent of the optimized intrinsic 
 * C code without restrictions note that the intrinsic C code is optimized
 * and restrictions may apply.
 * 
 * @par Assumptions:
 * 		nx must be a multiple of 4. <BR>
 * 		q15 and flt are double word aligned. <BR>
 * 
 * @par Implementation notes:
 * @b Endian Support: The code supports both big and little endian modes. <BR> 
 * @b Interruptibility: The code is interruptible. <BR> 
 * 
 */
 
 /* }@ */ /* ingroup */
 /* }@ */ /* ingroup */

void DSPF_q15tofl (
    const short *restrict q15,  /* Input Q15 array      */
    float *restrict flt,        /* Output float array   */
    int   nx                    /* Number of elements   */
);

#endif /* DSPF_Q15TOFL_H_ */

/* ======================================================================= */
/*  End of file:  DSPF_q15tofl.h                                           */
/* ----------------------------------------------------------------------- */
/*            Copyright (c) 2011 Texas Instruments, Incorporated.          */
/*                           All Rights Reserved.                          */
/* ======================================================================= */

