#include <cstdio>
#include <cstdlib>

#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <stdint.h>

#include "cli_common.h"
#include "matd.h"


int main(int argc, char *argv[])
{
    if(!matd_init())
    {
        fprintf(stderr, "matd_init() failed!\n");
        return -1;
    }

    if(argc != 1)
    {
        fprintf(stderr, "Usage: %s\n", argv[0]);
        return -1;
    }

    pwm_gen_t *pwm_gen = matd_ctx.m_pwm_regs;

    for(int i = 0; i < matd_ctx.m_pwm_cnt; i++)
    {
        pwm_gen->pwm_ch_ctrl[i].ctrl = 0;
    }

    pwm_gen->pwm_ctrl_status = 0;

    matd_destroy();
    return 0;
}
