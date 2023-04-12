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

    if(argc != 3)
    {
        fprintf(stderr, "Usage: %s <PWM freq [Hz]> <PWM duty cycle [%]\n", argv[0]);
        return -1;
    }

    int pwm_freq = strtod(argv[1], NULL);
    int pwm_duty = strtod(argv[2], NULL);

    matd_set_pwm(pwm_freq, pwm_duty);

    matd_destroy();

    return 0;
}
