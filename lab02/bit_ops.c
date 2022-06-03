#include <stdio.h>
#include "bit_ops.h"

// Return the nth bit of x.
// Assume 0 <= n <= 31
unsigned get_bit(unsigned x,
                 unsigned n) {
    int mask = 1;
    x = x >> n;
    return x&mask;
}
// Set the nth bit of the value of x to v.
// Assume 0 <= n <= 31, and v is 0 or 1
void set_bit(unsigned * x,
             unsigned n,
             unsigned v) {
    if (v==0){
        *x = ~*x;
        int mask = 1;
        mask = mask<<n;
        *x = *x | mask;
        *x = ~*x;
    } else {
        int mask = 1;
        mask = mask<<n;
        *x = *x | mask;
    }
}
// Flip the nth bit of the value of x.
// Assume 0 <= n <= 31
void flip_bit(unsigned * x,
              unsigned n) {
    int mask = 1;
    mask = mask<<n;
    *x = *x^mask;
}

