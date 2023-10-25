/*
 * File:   main.c
 * Author: colaa
 *
 * Created on 2023?10?18?, ?? 10:16
 */
#include <xc.h>
#include <stdio.h>
extern unsigned char is_square(unsigned int a);

void main(void) {
    volatile unsigned char ans = is_square(255);
    while(1){}
    return;
}
