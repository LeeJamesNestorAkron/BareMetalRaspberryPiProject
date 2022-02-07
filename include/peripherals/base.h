#pragma once
//only include the file once

#if RPI_VERSION == 3
#define PBASE 0x3F000000s
//pi 3 bcm 2837 is the base chip 

#elif RPI_VERSION == 4
#define PBASE 0xFE000000
//pi 4 is bcm 2711

#else 
#define PBASE 0
#error RPI_VERSION NOT DEFINED
//Pbase is the physical starting address for peripherals

#endif