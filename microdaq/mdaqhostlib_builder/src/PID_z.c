#include "PID_z.h"
 
void PID_z_Init(DW_PID_z_T *localDW, P_PID_z_T *localP) 
{
  localDW->Filter_DSTATE = localP->Filter_IC;
  localDW->Integrator_DSTATE = localP->Integrator_IC;
}

void PID_z(double rtu_error, double rtu_tracking, B_PID_z_T *localB, DW_PID_z_T *
           localDW, P_PID_z_T *localP)
{
  double rtb_Sum;
  double rtb_FilterCoefficient;
  rtb_FilterCoefficient = (localP->DerivativeGain_Gain * rtu_error -
    localDW->Filter_DSTATE) * localP->FilterCoefficient_Gain;
  rtb_Sum = (localP->ProportionalGain_Gain * rtu_error +
             localDW->Integrator_DSTATE) + rtb_FilterCoefficient;
  if (rtb_Sum >= localP->Saturation_UpperSat) {
    localB->Saturation = localP->Saturation_UpperSat;
  } else if (rtb_Sum <= localP->Saturation_LowerSat) {
    localB->Saturation = localP->Saturation_LowerSat;
  } else {
    localB->Saturation = rtb_Sum;
  }

  localDW->Filter_DSTATE += localP->Filter_gainval * rtb_FilterCoefficient;
  localDW->Integrator_DSTATE += (((localB->Saturation - rtb_Sum) *
    localP->Kb_Gain + localP->IntegralGain_Gain * rtu_error) + (rtu_tracking -
    localB->Saturation) * localP->Kt_Gain) * localP->Integrator_gainval;
}
