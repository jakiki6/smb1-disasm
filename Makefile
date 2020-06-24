run: bin
	mono ~/Mesen.exe
patch: bin
	./patch
bin: asm
	./asm smb.asm -q
	mv smb.bin smb.nes
clean:
	rm *.nes
asm:
	gcc asm6/asm6.c -o asm
purge:
	rm -fr *
	git reset --hard --recurse-submodules

.PHONY: run clean bin purge
