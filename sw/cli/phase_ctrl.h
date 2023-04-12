#ifndef __PHASE_CTRL_H
#define __PHASE_CTRL_H

#define PHASE_CTRL_BASE 0x43C10000

// phase_ctrl registers:
// ctrl:
//   - bit[0] - automatic (1) or manual (0) control - self clearing when automatic action is done
//   - bit[1] - change on positive (0) or negative (1) pulse
//   - bits[7:4] - control mode:
//         - 4'h0 - static (no change stay at phase_start
//         - 4'h1 - full phase counts of phase_cnt_o with PHASE_STEP
// cnt_step:
//   - bits[ 7: 0] - phase count (signed integer)
//   - bits[15: 8] - phase skip
//   - bits[31:16] - phase step
// start_curr_rb:
//   - bits[11: 0] - current phase
//   - bits[27:16] - starting phase
typedef struct ch_phase_ctrl_s {
    uint32_t ctrl;           // 0x10 + (0x10 * i) - ch. phase control
    uint32_t cnt_step;       // 0x14 + (0x10 * i) - ch. phase change
    uint32_t start_curr_rb;  // 0x18 + (0x10 * i) - ch. start phase & current readback
    uint32_t reserved;       // 0x1C + (0x10 * i) - reserved
} ch_phase_ctrl_t;

typedef struct phase_ctrl_s {
    uint32_t         phase_ctrl;        // 0x00 - Phase ctrl
    uint32_t         reserved[3];       // 0x04 - 0x0C reserved
    ch_phase_ctrl_t *ch_phase;          // 0x10 + (0x10 * i)
} phase_ctrl_t;



#endif // __PHASE_CTRL_H
