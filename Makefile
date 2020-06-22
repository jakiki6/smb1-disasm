run: bin
	mono ~/Mesen.exe
patch: clean bin
	./patch
bin: asm
	./asm smb.asm
	mv smb.bin smb.nes
clean:
	rm *.nes
asm:
	gcc asm6/asm6.c -o asm -static

.PHONY: run clean bin
