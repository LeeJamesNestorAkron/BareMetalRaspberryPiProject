#pragma once
//pragma is a special prupose derictive that is used to turn on or off features, IE startup or exit,
//once tells it to only run this code once


#include <stdint.h>

typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;

typedef volatile u32 reg32;
//volatile: Lets the compiler know not to optimize this object, it can be subject to change outside of
//of the scope of the nearby code