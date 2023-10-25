/*
 * File:   main.c
 * Author: colaa
 *
 * Created on 2023?10?19?, ?? 4:22
 */


#include <xc.h>

extern unsigned int lcm(unsigned int a, unsigned int b);

void main(void) {
    volatile unsigned int result = lcm(140, 3);
    while(1);
    return;
}
