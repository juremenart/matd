#ifndef __MATD_H
#define __MATD_H

#include "phase_ctrl.h"
#include "pwm_gen.h"

typedef struct {
    int           m_pwm_cnt;
    int           m_phase_regs_fd;
    int           m_pwm_regs_fd;
    int           m_logic_freq;
    phase_ctrl_t *m_phase_regs;
    pwm_gen_t    *m_pwm_regs;
} matd_ctx_t;

extern matd_ctx_t matd_ctx;

bool matd_init(void);

void matd_destroy(void);

bool matd_set_pwm(int pwm_freq, int pwm_duty);

#endif // __MATD_H
