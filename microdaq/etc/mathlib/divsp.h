/* ======================================================================== *
 * MATHLIB -- TI Floating-Point Math Function Library                       *
 *                                                                          *
 *                                                                          *
 * Copyright (C) 2011 Texas Instruments Incorporated - http://www.ti.com/   *
 *                                                                          *
 *                                                                          *
 *  Redistribution and use in source and binary forms, with or without      *
 *  modification, are permitted provided that the following conditions      *
 *  are met:                                                                *
 *                                                                          *
 *    Redistributions of source code must retain the above copyright        *
 *    notice, this list of conditions and the following disclaimer.         *
 *                                                                          *
 *    Redistributions in binary form must reproduce the above copyright     *
 *    notice, this list of conditions and the following disclaimer in the   *
 *    documentation and/or other materials provided with the                *
 *    distribution.                                                         *
 *                                                                          *
 *    Neither the name of Texas Instruments Incorporated nor the names of   *
 *    its contributors may be used to endorse or promote products derived   *
 *    from this software without specific prior written permission.         *
 *                                                                          *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS     *
 *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT       *
 *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR   *
 *  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT    *
 *  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,   *
 *  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT        *
 *  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,   *
 *  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY   *
 *  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT     *
 *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE   *
 *  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.    *
 * ======================================================================== */

/* ======================================================================= */
/* divsp.h - single precision floating point divide                        */
/*              optimized hand ASM single sample                           */ 
/* ======================================================================= */

#ifndef C674_DIVSP_H_
#define C674_DIVSP_H_ 1

/** @defgroup divsp */
/** @ingroup  divsp */
/* @{ */

/**
 * @par Description:
 *    The divsp_v function returns the division function of a real floating-point 
 *    argument a by b. The return value is the number resulting from a/b.
 * @par 
 * 	  @param[in] a = Input float dividend
 * 	  @param[in] b = Input float divisor
 * @par 
 * 	  @return Resultant float 
 * 
 *
 * @par Special Cases:
 *  - If | b | < 1.1755e-38, then the return value is NaN.
 *
 *
 * @sa 
 *  - divsp_i
 *  - divsp_v
 *
 *
 * @par Implementation Notes:
 *  - The code supports little endian mode. 
 *  
 */

float divsp   (float a, float b);
float divsp_c (float a, float b);


/** @} */

#endif /* C674_DIVSP_H_ */

/* ======================================================================== */
/*  End of file: divsp.h                                                    */
/* ======================================================================== */
