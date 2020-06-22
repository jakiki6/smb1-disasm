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
purge:
	rm -fr *
	git reset --hard --recurse-submodules

.PHONY: run clean bin purge
