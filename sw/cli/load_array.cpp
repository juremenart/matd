#include <cstdio>
#include <cstdlib>

#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <stdint.h>

#include <string>

#include "matd.h"
#include "pwm_gen.h"
#include "phase_ctrl.h"

int main(int argc, char *argv[])
{
    if(!matd_init())
    {
        fprintf(stderr, "matd_init() failed!\n");
        return -1;
    }

    if(argc != 3)
    {
        fprintf(stderr, "Usage: %s <input phase folders> <delay>\n", argv[0]);
        return -1;
    }

    char *in_dir = argv[1];
    int   delay = strtod(argv[2], NULL);

    std::vector<std::vector<int>> array_seq = load_arrays(in_dir);

#if 1 // just debug
    for(auto iter = array_seq.begin(); iter != array_seq.end(); iter++)
    {
        std::vector<int> data = *iter;
        printf("Array:\n");
        for(int k = 0; k < matd_ctx.m_pwm_cnt; k++)
        {
            if(((k % 8) == 0) && (k != 0))
                printf("\n");
            printf("%03d ", data[k]);
        }
        printf("\n\n");
    }
#endif

    printf("Number of outputs: %d\n", matd_ctx.m_pwm_cnt);

    // load to HW and also enable manual mode
    for(auto iter = array_seq.begin(); iter != array_seq.end(); iter++)
    {
        std::vector<int> data = *iter;

        // check the size
        if(matd_ctx.m_pwm_cnt != data.size())
        {
            fprintf(stderr, "Input data size mismatch (%d != %d)\n",
                    matd_ctx.m_pwm_cnt, data.size());
            break;
        }

        printf("Loading array & enabling:\n");
        for(int k = 0; k < matd_ctx.m_pwm_cnt; k++)
        {
            matd_ctx.m_pwm_regs->pwm_ch_ctrl[k].phase = data[k];
            matd_ctx.m_pwm_regs->pwm_ch_ctrl[k].ctrl |= 1;
        }

    	matd_ctx.m_pwm_regs->pwm_ctrl_status |= 3; // sync & enable
	usleep(delay);
    }

    matd_destroy();

    return 0;
}
