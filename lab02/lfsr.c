#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

void lfsr_calculate(uint16_t *reg) {
    uint16_t temp = *reg;
    uint16_t reg0 = 1&temp;
    temp >>= 2;
    uint16_t reg2 = 1&temp;
    temp >>= 1;
    uint16_t reg3 = 1&temp;
    temp >>= 2;
    uint16_t reg5 = 1&temp;
    *reg >>= 1;
    uint16_t mask = ((reg0^reg2)^reg3)^reg5;
    mask <<= 15;
    *reg += mask;
}

