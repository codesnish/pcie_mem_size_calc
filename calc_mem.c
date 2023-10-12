#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
	if (argc != 2)
	{
		printf("Usage: %s <hex_value>\n", argv[0]);
		return 1;
	}
	
	// Step 1: Get the input hexadecimal value from the command line argument
	unsigned int hexNumber = strtoul(argv[1], NULL, 16), result, invertedNumber, count = 0;
	
	// Step 2: Replace bits 0 to 3 with 0s
	result = hexNumber & 0xFFFFFFF0;
	printf("Mask the information bits: %04x\n", result);
	
	// Step 3: Invert all bits
	invertedNumber = ~result;
	printf("Invert all bits: %04x\n", invertedNumber);
	
	// Step 4: Count 1's from LSB until a 0 is encountered
	while (invertedNumber & 1) 
	{
		invertedNumber >>= 1;
		count++;
	}
	printf("No. of trailing ones: %d\n", count);
	
	// Step 5: Calculate 2^n and output the result
	unsigned int finalResult = 1 << count;
	printf("2^No. of trailing zeros: %u\n", finalResult);
	
	// Step 6: Divide the finalResult by 1024 until it's less than 1024
	int divide = 0;
	while (finalResult >= 1024) 
	{
		finalResult /= 1024;
		divide++;
	}
	
	// Step 7: Determine the appropriate unit
	char unit;
	switch (divide) 
	{
		case 0: unit = ' '; break;
		case 1: unit = 'K'; break;
		case 2:	unit = 'M'; break;
		case 3:	unit = 'G'; break;
		case 4:	unit = 'T'; break;
		case 5:	unit = 'P'; break;
		case 6:	unit = 'E'; break;
		default: unit = ' ';
	}
	
	// Step 8: Output the result with appropriate unit and 'B' (bytes) appended
	printf("Device Memory Size: %u%cB\n", finalResult, unit);
	return 0;
}
