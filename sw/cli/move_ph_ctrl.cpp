#include <cstdio>
#include <cstdlib>

#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <stdint.h>

#include <string>
#include <vector>

#include "cli_common.h"
#include "matd.h"
#include "pwm_gen.h"
#include "phase_ctrl.h"

#define OFFLINE_BUILD
#define DEBUG

int main(int argc, char *argv[])
{
#ifndef OFFLINE_BUILD
    if(!matd_init())
    {
        fprintf(stderr, "matd_init() failed!\n");
        return -1;
    }
#else // OFFLINE_BUILD
    matd_ctx.m_pwm_cnt = 64;
#endif // OFFLINE_BUILD
    if(argc != 4)
    {
        fprintf(stderr, "Usage: %s <input phase diff> <factor> <steps>\n", argv[0]);
        return -1;
    }

    char    *in_file = argv[1];
    int      factor = strtod(argv[2], NULL);
    uint8_t  steps = strtod(argv[3], NULL);
    uint8_t  skip  = 0;

    std::vector<int> data = load_file(in_file);

    if(data.size() == 0)
    {
        fprintf(stderr, "Empty input file, quitting\n");
#ifndef OFFLINE_BUILD
        matd_destroy();
#endif // OFFLINE_BUILD
        return -1;
    }

    printf("Number of outputs: %d\n", matd_ctx.m_pwm_cnt);

    // first file we load to PWM generator and phase controller and enable it
    printf("Loading PH_CTRL and enabling the move\n");

#ifdef DEBUG
    printf("Diff array:\n");
#endif // DEBUG

    if(matd_ctx.m_pwm_cnt != data.size())
    {
        fprintf(stderr, "Input data size mismatch (%d != %d)\n",
                matd_ctx.m_pwm_cnt, data.size());
#ifndef OFFLINE_BUILD
        matd_destroy();
#endif // OFFLINE_BUILD
        return -1;
    }

#ifndef OFFLINE_BUILD
    matd_ctx.m_phase_regs->phase_ctrl = 0;
#endif // OFFLINE_BUILD

    for(int k = 0; k < data.size(); k++)
    {
        int16_t ph_shift = data[k] * factor;

        uint32_t ph_data = (ph_shift << 16) | (skip << 8) | steps;

#ifndef OFFLINE_BUILD
        matd_ctx.m_phase_regs->ch_phase[k].cnt_step = ph_data;
        matd_ctx.m_phase_regs->ch_phase[k].ctrl |= 0x13;
#endif // OFFLINE_BUILD

#ifdef DEBUG
        if(((k % 8) == 0) && (k != 0))
            printf("\n");
        printf("%03d (0x%08x) ", ph_shift, ph_data);
#endif // DEBUG
    }

#ifndef OFFLINE_BUILD
    matd_ctx.m_phase_regs->phase_ctrl = 1;
#endif // OFFLINE_BUILD

#ifdef DEBUG
    printf("\n");
#endif // DEBUG

#ifndef OFFLINE_BUILD
    matd_destroy();
#endif // OFFLINE_BUILD

    return 0;
}
