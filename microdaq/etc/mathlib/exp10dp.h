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
/* exp10dp.h - double Precision Exponential Base 10                        */
/* ======================================================================= */

#ifndef C674_EXP10DP_H_
#define C674_EXP10DP_H_ 1

/** @defgroup exp10dp */
/** @ingroup  exp10dp */
/* @{ */

/**
 * @par Description:
 *    The exp10dp function returns the exponential function of a real 
 *    floating-point argument a.  The return value is the number 10 raised to the
 *    power a. If the magnitude of a is too large, the maximum double-precision 
 *    floating-point number (1.797693e+308 = 2^1024) is returned.
 * @par 
 * 	  @param[in] a = Input double 
 * @par 
 * 	  @return Resultant double 
 * 
 *
 * @par Special Cases:
 *  - If | a | < 3.34e-17, then the return value is 1.0 for small arguments.                                             
 *  - If a < -307.6527, then the return value is 0.0.                                                                    
 *  - If a > +308.2547, then the return value is 1.797693e+308 = 2^1024 (maximum double-precision 
 *    floating-point number).
 *
 *
 * @sa 
 *  - exp10dp_i
 *  - exp10dp_v
 *
 *
 * @par Implementation Notes:
 *  - The code supports little endian mode. 
 *  
 */

double exp10dp   (double a);
double exp10dp_c (double a);

/** @} */

#endif /* C674_EXP10DP_H_ */

/* ======================================================================== */
/*  End of file: exp10dp.h                                                  */
/* ======================================================================== */
