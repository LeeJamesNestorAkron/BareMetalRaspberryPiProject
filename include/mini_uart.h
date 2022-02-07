#pragma once
void uart_int();
char uart_recv();
void uart_send(char c);
void uart_send_string(char *str);
