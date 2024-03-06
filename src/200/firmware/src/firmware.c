#include "print.h"

//extern unsigned int hwswcd_hd(unsigned int value1, unsigned int value2);
extern unsigned int hwswcd_avg(unsigned int value3, unsigned int value4);

void main(void) {
	volatile unsigned int value1, value2, hd, value3, value4, avg;

	value1 = 5;
	value2 = 9;

//    hd = hwswcd_hd(value1, value2);

	// hd(0x05,09) = 0x02
	print_str("hd(0x");
	print_hex(value1, 2);
	print_str(", ");
	print_hex(value2, 2);
	print_str(") = 0x");
//	print_hex(hd, 2);
	print_str(" en ");

	value1 = 10;
	value2 = 21;

//    hd = hwswcd_hd(value1, value2); 

	// hd(0x0A,15) = 0x05 
	print_str("hd(0x");
	print_hex(value1, 2);
	print_str(", ");
	print_hex(value2, 2);
	print_str(") = 0x");
//	print_hex(hd, 2);
	print_str(" en ");

	value3 = 5;
	value4 = 10;

    avg = hwswcd_avg(value3, value4);

	// avg(0x05,0A) = 0x07
	print_str("avg(0x");
	print_hex(value3, 2);
	print_str(", ");
	print_hex(value4, 2);
	print_str(") = 0x");
	print_hex(avg, 2);
	print_str(".");
}
