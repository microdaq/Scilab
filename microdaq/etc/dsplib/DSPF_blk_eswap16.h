/* ======================================================================= */
/* DSPF_blk_eswap16.h -- Endian-swap a block of 16-bit values              */
/*                      Intrinsic C Implementation                         */
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

#ifndef DSPF_BLK_ESWAP16_H_
#define DSPF_BLK_ESWAP16_H_ 1

#ifndef __TI_COMPILER_VERSION__           // for non TI compiler
#include "assert.h"                       // intrinsics prototypes
#include "C6xSimulator.h"                 // intrinsics prototypes
#include "C6xSimulator_type_modifiers.h"  // define/undefine typing keywords
#endif

/** @ingroup MISC */
/* @{ */

/** @defgroup DSPF_blk_eswap16 */
/** @ingroup DSPF_blk_eswap16 */
/* @{ */

/**
 * 	   The data in the x[] array is endian swapped, meaning that 
 *     the byte-order of the bytes within each half-word of the r[] 
 *     array is reversed. This facilitates moving big-endian data 
 *     to a little-endian system or vice-versa.
 *     When the r pointer is non-NULL, the endian-swap occurs out-of-place, 
 *     similar to a block move. When the r pointer is NULL, the endian-swap 
 *     occurs in-place, allowing the swap to occur without using any 
 *     additional storage.
 * 
 * 			@param src      = Source data, must be double-word aligned.
 * 			@param dst      = Destination data, must be double-word aligned.
 * 			@param n_hwords = Number of 16-bit elements to swap.
 * 
 * @par Algorithm:
 * DSPF_blk_eswap16_cn.c is the natural C equivalent of the optimized 
 * intrinsic C code without restrictions note that the intrinsic C code 
 * is optimized and restrictions may apply.
 * 
 * @par Assumptions:
 * 		Input and output arrays do not overlap, except when �dst == NULL� so that
 *      the operation occurs in-place. <BR>
 * 		The input array and output array are double-word aligned. <BR>
 *		nx is a multiple of 8. <BR>
 * 
 * @par Implementation notes:
 * @b Endian Support: The code supports both big and little endian modes. <BR> 
 * @b Interruptibility: The code is interruptible. <BR> 
 * 
 */
 
 /* }@ */ /* ingroup */
 /* }@ */ /* ingroup */

void DSPF_blk_eswap16 (
    void *restrict src,
    void *restrict dst,
    int  n_hwords
);

#endif

/* ======================================================================== */
/*  End of file:  DSPF_blk_eswap16.h                                        */
/* ------------------------------------------------------------------------ */
/*            Copyright (c) 2011 Texas Instruments, Incorporated.           */
/*                           All Rights Reserved.                           */
/* ======================================================================== */

