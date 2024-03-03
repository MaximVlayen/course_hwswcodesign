#include "print.h"

extern unsigned int hwswcd_hd(unsigned int value1, unsigned int value2);
extern unsigned int hwswcd_avg(unsigned int value3, unsigned int value4);

void main(void) {
	volatile unsigned int value1, value2, hd, value3, value4, avg;

	value1 = 5;
	value2 = 9;

    hd = hwswcd_hd(value1, value2);

	print_str("HD(0x");
	print_hex(value1, 2);
	print_str(", ");
	print_hex(value2, 2);
	print_str(") = 0x");
	print_hex(hd, 2);
	print_str(".");

	value1 = 10;
	value2 = 21;

    hd = hwswcd_hd(value1, value2);

	print_str("en HD(0x");
	print_hex(value1, 2);
	print_str(", ");
	print_hex(value2, 2);
	print_str(") = 0x");
	print_hex(hd, 2);
	print_str(".");

	value3 = 5;
	value4 = 10;

    avg = hwswcd_avg(value3, value4);

	print_str("en avg(0x");
	print_hex(value3, 2);
	print_str(", ");
	print_hex(value4, 2);
	print_str(") = 0x");
	print_hex(avg, 2);
	print_str(".");
}
