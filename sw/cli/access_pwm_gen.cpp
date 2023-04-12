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
    pwm_gen_t *m_regs;

    if(!matd_init())
    {
        fprintf(stderr, "matd_init() failed!\n");
        return -1;
    }

    m_regs = matd_ctx.m_pwm_regs;

    if((argc < 2) || (argc > 3))
    {
        fprintf(stderr, "Usage: %s <address> [value]\n", argv[0]);
        return -1;
    }

    // Read-write?
    uint32_t address = 0;
    uint32_t value;
    uint32_t *base = (uint32_t *)m_regs;

    address = strtod(argv[1], NULL) / 4;

    if(argc == 3)
    {
        value = strtod(argv[2], NULL);
        *(base+address) = value;
    }
    else
    {
        value = *(base+address);
    }

    printf("register=0x%04x value=0x%08x\n", address, value);

    matd_destroy();
    return 0;
}
