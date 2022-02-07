#pragma once

#define PAGE_SHIFT 12
#define TABLE_SHIFT 9
#define SECTION_SHIFT (PAGE_SHIFT + TABLE_SHIFT)
#define PAGE_SIZE (1 << PAGE_SHIFT)
#define SECTION_SIZE (1 << SECTION_SHIFT)
//Based off of linux source code
//defining size of pages and page tables

#define LOW_MEMORY (2 * SECTION_SIZE)


#ifndef __ASSEMBLER__

void memzero(unsigned long src, unsigned int n);

#endif
//Does not like function def in a c style
//add so it can include both c and assembly styles function def
