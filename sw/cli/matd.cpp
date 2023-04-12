#include <stdio.h>
#include <stdint.h>

#include "matd.h"
#include "phase_ctrl.h"
#include "pwm_gen.h"

#define MATD_LOGIC_FREQ (50*1000000) // 50 [MHz]

matd_ctx_t matd_ctx = { 0, -1, -1, MATD_LOGIC_FREQ, NULL, NULL };

bool matd_init(void)
{
    matd_ctx.m_phase_regs =
        (phase_ctrl_t *)map_addr(PHASE_CTRL_BASE, sizeof(phase_ctrl_t), &matd_ctx.m_phase_regs_fd);
    if(matd_ctx.m_phase_regs == NULL)
    {
        return false;
    }

    matd_ctx.m_pwm_regs =
        (pwm_gen_t *)map_addr(PWM_GEN_BASE, sizeof(pwm_gen_t), &matd_ctx.m_pwm_regs_fd);
    if(matd_ctx.m_pwm_regs == NULL)
    {
        return false;
    }

    matd_ctx.m_pwm_cnt =
        (matd_ctx.m_pwm_regs->pwm_ctrl_status & PWM_CS_PWM_CNT) >> PWM_CS_PWM_CNT_SHIFT;
    if(matd_ctx.m_pwm_cnt == 0)
    {
        return false;
    }

    matd_ctx.m_logic_freq = MATD_LOGIC_FREQ;

    return true;
}

void matd_destroy(void)
{
    if(matd_ctx.m_pwm_regs)
    {
        unmap_addr(matd_ctx.m_pwm_regs_fd);
        matd_ctx.m_pwm_regs_fd = -1;
    }

    if(matd_ctx.m_phase_regs)
    {
        unmap_addr(matd_ctx.m_phase_regs_fd);
        matd_ctx.m_phase_regs_fd = -1;
    }

    matd_ctx.m_pwm_cnt = 0;
}

bool matd_set_pwm(int pwm_freq, int pwm_duty)
{
    int p_smpls = matd_ctx.m_logic_freq / pwm_freq;
    int p_active = (p_smpls * pwm_duty) / 100;

    if(!matd_ctx.m_pwm_regs)
    {
        return false;
    }

    matd_ctx.m_pwm_regs->pwm_period = p_smpls;
    matd_ctx.m_pwm_regs->pwm_active = p_active;

    return true;
}
