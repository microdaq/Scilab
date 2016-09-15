
#include <stddef.h>
#include <string.h>

typedef struct {
  double Saturation;
} B_PID_z_T;

typedef struct {
  double Filter_DSTATE;
  double Integrator_DSTATE;
} DW_PID_z_T;

typedef struct P_PID_z_T_ {
  double DerivativeGain_Gain;
  double Filter_gainval;
  double Filter_IC;
  double FilterCoefficient_Gain;
  double IntegralGain_Gain;
  double Integrator_gainval;
  double Integrator_IC;
  double ProportionalGain_Gain;
  double Saturation_UpperSat;
  double Saturation_LowerSat;
  double Kb_Gain;
  double Kt_Gain;
}P_PID_z_T;

typedef struct {
	DW_PID_z_T localDW;
	B_PID_z_T  localB;
	P_PID_z_T  localP; 
} PID_DATA_T; 

extern void PID_z_Init(DW_PID_z_T *localDW, P_PID_z_T *localP);
extern void PID_z(double rtu_error, double rtu_tracking, B_PID_z_T *localB,
                  DW_PID_z_T *localDW, P_PID_z_T *localP);



