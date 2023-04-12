#ifndef __PWM_GEN_H
#define __PWM_GEN_H

#include "cli_common.h" // PWM_CNT

#define PWM_GEN_BASE 0x43C00000

#define PWM_CS_ENABLE    0x00000001  //!< Bit0 - enable/disable
#define PWM_CS_PWM_CNT_W 0x0000FF00  //!< Bits(15: 8) - PWM counter width
#define PWM_CS_PWM_CNT   0x00FF0000  //!< Bits(23:16) - PWM counters (number of outputs)

#define PWM_CS_PWM_CNT_SHIFT     16

typedef struct ch_pwm_ctrl_s {
    uint32_t ctrl;       // 0x10 + (0x08 * i) - ch. pwm ctrl (enable=bit0)
    uint32_t phase;      // 0x14 + (0x08 * i) - ch. pwm manual phase
} ch_pwm_ctrl_t;

typedef struct pwm_gen_s {
    uint32_t        pwm_ctrl_status;      // 0x00 - PWM Control/Status
                                          //      - bit(0)      - enable
					  //      - bit(1)      - phase array sync (reads 0)
                                          //      - bits(15: 8) - pwm_cnt_width
                                          //      - bits(23:16) - pwm_cnt
    uint32_t        pwm_period;           // 0x04 - PWM Period
    uint32_t        pwm_active;           // 0x08 - PWM Active ('high')
    uint32_t        reserved;             // 0x0C - reserved
    ch_pwm_ctrl_t   pwm_ch_ctrl[64];     // 0x10 + (0x8 * i)
} pwm_gen_t;

#endif // __PWM_GEN_H
