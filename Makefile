all: main.hex

DEVICE = atmega328p
CLOCK = 16000000

COMPILE = avr-gcc -Wall -Os -DF_CPU=$(CLOCK) -mmcu=$(DEVICE)

.c.o:
	$(COMPILE) -c $< -o $@

.S.o:
	$(COMPILE) -x assembler-with-c -c $< -o $@

.c.s:
	$(COMPILE) -S $< -o $@

main.elf: main.o
	$(COMPILE) -o main.elf main.o

main.hex: main.elf
	avr-objcopy -j .text -j .data -O ihex main.elf main.hex

flash:	all
	sudo avrdude -c arduino -P /dev/ttyACM0 -p $(DEVICE) -U flash:w:main.hex:i

clear:
	rm -f main.hex main.elf main.o