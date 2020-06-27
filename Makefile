name = mypatch

run: bin
	mono ~/Mesen.exe
genie: bin
	./genie
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
diff:
	git diff > patches/$(name).patch
patch:
	patch smb.asm -i patches/$(name).patch

.PHONY: run clean bin purge diff genie patch
