#include "common.h"
#include "mini_uart.h"

void kernel_main(){
    uart_init();
    uart_send_string("Rasperry PI is fucking working \n");

#if RPI_VERSION == 3
    uart_send_string("\tBoard: Raspberry PI 3\n");
#endif

#if RPI_VERSION == 4
    uart_send_string("\tBoard: Raspberry PI 4\n");

#endif
    while(1) {
        uart_send(uart_recv());
    }

}