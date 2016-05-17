#ifndef MLINK_H
#define MLINK_H

#include <stdint.h>

#ifdef APP_BUILD
#define EXTERNC
#define MDAQ_API
#endif 

#ifdef __GNUC__
#define EXTERNC 
#define MDAQ_API extern
#endif 

#ifdef DLL_BUILD
#define EXTERNC extern "C" 
#define MDAQ_API __declspec(dllexport)
#endif 

#if !(__GNUC__ || APP_BUILD || DLL_BUILD)
#define EXTERNC extern "C" 
#define MDAQ_API __declspec(dllimport)
#endif 

/* AO range */ 
#define  AO_0_TO_5V             0
#define  AO_0_TO_10V            1
#define  AO_PLUS_MINUS_5V       2
#define  AO_PLUS_MINUS_10V      3
#define  AO_PLUS_MINUS_2V5      4

/* AI range */
#define AI_10V 					0
#define AI_5V 					1


/* AI polarity */
#define AI_BIPOLAR 				0
#define AI_UNIPOLAR				1

/* AI mode */
#define AI_SINGLE  				0
#define AI_DIFF    				1


/* Utility functions */ 
EXTERNC MDAQ_API char *mlink_error( int err );
EXTERNC MDAQ_API char *mlink_version( int *link_fd );
EXTERNC MDAQ_API int mlink_hwid( int *link_fd, int *hwid );

EXTERNC MDAQ_API int mlink_connect( const char *addr, uint16_t port, int *link );
EXTERNC MDAQ_API int mlink_disconnect( int link );

/* DSP handling functions */
EXTERNC MDAQ_API int mlink_dsp_load( int *link_fd, const char *dspapp, const char *param );
EXTERNC MDAQ_API int mlink_dsp_start( int *link_fd );
EXTERNC MDAQ_API int mlink_dsp_stop( int *link_fd );
EXTERNC MDAQ_API int mlink_dsp_upload( int *link_fd );

/* Digital IO functions */ 
EXTERNC MDAQ_API int mlink_dio_set_func( int *link_fd, uint8_t function, uint8_t enable );
EXTERNC MDAQ_API int mlink_dio_set_dir( int *link_fd, uint8_t pin, uint8_t dir, uint8_t init_value );
EXTERNC MDAQ_API int mlink_dio_set( int *link_fd, uint8_t pin, uint8_t value );
EXTERNC MDAQ_API int mlink_dio_get( int *link_fd, uint8_t pin, uint8_t *value );
EXTERNC MDAQ_API int mlink_led_set( int *link_fd, uint8_t led, uint8_t state );
EXTERNC MDAQ_API int mlink_func_key_get( int *link_fd, uint8_t key, uint8_t *state );

/* Encoder read functions */ 
EXTERNC MDAQ_API int mlink_enc_get( int *link_fd, uint8_t ch, uint8_t *dir, int32_t *value );
EXTERNC MDAQ_API int mlink_enc_reset( int *link_fd, uint8_t ch, int32_t init_value );

/* PWM functions */ 
EXTERNC MDAQ_API int mlink_pwm_config( int *link_fd, uint8_t module, uint32_t period, uint8_t active_low, float pwm_a, float pwm_b );
EXTERNC MDAQ_API int mlink_pwm_set( int *link_fd, uint8_t module, float channel_a, float channel_b );

/* PRU functions */ 
EXTERNC MDAQ_API int mlink_pru_exec( int *link_fd, const char *pru_fw, uint8_t pru_num, uint8_t build_in_fw );
EXTERNC MDAQ_API int mlink_pru_stop( int *link_fd, uint8_t pru_num );
EXTERNC MDAQ_API int mlink_pru_reg_get( int *link_fd, uint8_t pru_num, uint8_t reg, uint32_t *reg_value );
EXTERNC MDAQ_API int mlink_pru_reg_set( int *link_fd, uint8_t pru_num, uint8_t reg, uint32_t reg_value );

/* UART functions */ 
EXTERNC MDAQ_API int mlink_uart_config( int *link_fd, uint8_t module, uint8_t data_bits, uint8_t parity, uint8_t stop_bits, uint32_t baud_rate );
EXTERNC MDAQ_API int mlink_uart_read( int *link_fd, uint8_t module, char *data, uint32_t size, int32_t timeout );
EXTERNC MDAQ_API int mlink_uart_write( int *link_fd, uint8_t module, char *data, uint32_t size );
EXTERNC MDAQ_API int mlink_uart_close( int *link_fd, uint8_t module );

/* High Speed ADC functions */ 
EXTERNC MDAQ_API int mlink_hs_ai_init( int *link_fd );
EXTERNC MDAQ_API int mlink_hs_ai_read( int *link_fd, uint32_t count, uint32_t delay, uint32_t trig_duration, double *data );

/* AI function */ 
EXTERNC MDAQ_API int mlink_ai_read( int *link_fd, uint8_t adc, uint8_t *ch, uint8_t ch_count, uint8_t range, uint8_t polarity, uint8_t mode, float *data );
EXTERNC MDAQ_API int mlink_ao_write( int *link_fd, uint8_t dac, uint8_t *ch, uint8_t ch_count, uint8_t mode, float *data );
EXTERNC MDAQ_API int mlink_ao_ch_config(int *link_fd, uint8_t *ch, uint8_t ch_count, uint8_t *range);

EXTERNC MDAQ_API int mlink_ai_scan_init(int *link_fd, uint8_t *ch, uint8_t ch_count, uint8_t range, uint8_t polarity, uint8_t mode, float freq, int32_t scan_count);
EXTERNC MDAQ_API int mlink_ai_scan(double *data, uint32_t scan_count, int32_t blocking);
EXTERNC MDAQ_API void mlink_ai_scan_stop( void );

/* Scilab interface funcations */ 
EXTERNC MDAQ_API void scilab_dsp_start( const char *addr, int *port, const char *dspapp, int *link_id );
EXTERNC MDAQ_API void scilab_dsp_stop( int *link_id, int *result );
EXTERNC MDAQ_API void scilab_signal_register( int *link_id, int32_t *id, int32_t *size, int *result );
EXTERNC MDAQ_API void scilab_signal_read( int *link_id, double *data, int32_t *count, int *result );
EXTERNC MDAQ_API int  scilab_mem_read( int *link_id, int start_idx, int len, float *data );
EXTERNC MDAQ_API int  scilab_mem_write( int *link_id, int start_idx, float data[], int len );

#ifndef LABVIEW_LIB
EXTERNC MDAQ_API void sci_client_connect( const char *ip, int *port, int *link_fd, int *result );
EXTERNC MDAQ_API void sci_client_disconnect( int *connectID );
EXTERNC MDAQ_API void sci_mlink_mem_get2( int *link_fd, int *start_idx, int *len, float *data, int *result );
EXTERNC MDAQ_API void sci_mlink_mem_set2( int *link_fd, int *start_idx, float data[], int *len, int *result );
EXTERNC MDAQ_API void sci_mlink_pru_reg_get( int *link_fd, int *pru_num, int *reg, int *reg_value, int *result );
EXTERNC MDAQ_API void sci_mlink_pru_reg_set( int *link_fd, int *pru_num, int *reg, int *reg_value, int *result );
EXTERNC MDAQ_API void sci_signal_get( int32_t *id, double *signal, int32_t *result );
EXTERNC MDAQ_API void sci_signals_get( double *signal, int32_t *n_samples, int32_t *result );
EXTERNC MDAQ_API void sci_signals_get_config( int32_t *n_signals, int32_t *size );
EXTERNC MDAQ_API void sci_signal_register( int32_t *id, int32_t *size, int32_t *result );
EXTERNC MDAQ_API void sci_mlink_func_key_get( int *link_fd, int *key, int *state, int *result );
EXTERNC MDAQ_API void sci_mlink_pwm_set( int *link_fd, int *module, double *channel_a, double *channel_b, int *result );
EXTERNC MDAQ_API void sci_mlink_pwm_config( int *link_fd, int *module, int *period, int *active_low, double *pwm_a, double *pwm_b, int *result );
EXTERNC MDAQ_API void sci_mlink_ai_read( int *link_fd, int *ch, int *ch_count, int *range, int *polarity, int *mode, double *data, int *result );

EXTERNC MDAQ_API void sci_mlink_ai_scan_get_ch_count(int *count);
EXTERNC MDAQ_API void sci_mlink_ai_scan(double *data, int	*scan_count, int *blocking, int *result);
EXTERNC MDAQ_API void sci_mlink_ai_scan_init(int *link_fd, int *ch, int *ch_count, int *range, int *polarity, int *mode, double *freq, int *scan_count, int *result);

EXTERNC MDAQ_API void sci_mlink_ao_write( int *link_fd, int *dac, int *ch, int *ch_count, double *data, int *result );
EXTERNC MDAQ_API void sci_mlink_ao_ch_config(int *link_fd, int *ch, int *ch_count, int *range, int *result);
EXTERNC MDAQ_API void sci_mlink_hs_ai_init( int *link_fd, int *result );
EXTERNC MDAQ_API void sci_mlink_hs_ai_read( int *link_fd, int *count, int *delay, int *trig_duration, double *data, int *result );
EXTERNC MDAQ_API void sci_mlink_enc_reset( int *link_fd, int *ch, int *init_value, int *result );
EXTERNC MDAQ_API void sci_mlink_enc_get( int *link_fd, int *ch, int *value, int *dir, int *result );
EXTERNC MDAQ_API void sci_mlink_led_set( int *link_fd, int *led, int *state, int *result );
EXTERNC MDAQ_API void sci_mlink_dio_get( int *link_fd, int *pin, int *value, int *result );
EXTERNC MDAQ_API void sci_mlink_dio_set( int *link_fd, int *pin, int *value, int *result );
EXTERNC MDAQ_API void sci_mlink_dio_set_dir( int *link_fd, int *pin, int *dir, int *init_value, int *result );
EXTERNC MDAQ_API void sci_mlink_dio_set_func( int *link_fd, int *function, int *enable, int *result );
EXTERNC MDAQ_API void sci_mlink_mem_set2( int *link_fd, int *start_idx, float data[], int *len, int *result );
EXTERNC MDAQ_API void sci_mlink_hwid( int *link_fd, int *hwid, int *result ); 
EXTERNC MDAQ_API void sci_mlink_version(int *link_fd, int *version, int *result);

EXTERNC MDAQ_API int mlink_pru_mem_set( int *link_fd, uint8_t pru_num, uint32_t addr, uint8_t data[], uint32_t len );
EXTERNC MDAQ_API int mlink_pru_mem_get( int *link_fd, uint8_t pru_num, uint32_t addr, char data[], uint32_t len );
EXTERNC MDAQ_API int mlink_get_obj_size( int *link_fd, char *var_name, uint32_t *size );
EXTERNC MDAQ_API int mlink_get_obj( int *link_fd, char *obj_name, void *data, uint32_t size );
EXTERNC MDAQ_API int mlink_set_obj( int *link_fd, char *obj_name, void *data, uint32_t size );
EXTERNC MDAQ_API int mlink_mem_open( int *link_fd, uint32_t addr, uint32_t len );
EXTERNC MDAQ_API int mlink_mem_close( int *link_fd, uint32_t addr, uint32_t len );
EXTERNC MDAQ_API int mlink_mem_set( int *link_fd, uint32_t addr, int8_t *data, uint32_t len );
EXTERNC MDAQ_API int mlink_mem_get( int *link_fd, uint32_t addr, int8_t *data, uint32_t len );
#endif 

/* Private functions */ 
#ifdef MLINK_SERVICE
EXTERNC MDAQ_API int mlink_ao_calib(int *link_fd, uint32_t magic, double *A, double *B);
EXTERNC MDAQ_API int mlink_ao_calib_read(int *link_fd, uint32_t magic, double *A, double *B);
EXTERNC MDAQ_API void sci_mlink_ao_calib(int *link_fd, int *magic, double *A, double *B, int *result);
EXTERNC MDAQ_API void sci_mlink_ao_calib_read(int *link_fd, int *magic, double *A, double *B, int *result);
#endif 

#endif /* MLINK_H */ 
