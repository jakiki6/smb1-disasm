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
	git diff smb.asm > patches/$(name).patch
	git checkout -- smb.asm
patch:
	patch smb.asm -i patches/$(name).patch
install: bin
	sudo mount /dev/sdb1 /mnt
	sudo cp smb.nes /mnt/roms/nes/smb.nes
	sudo sync
	sudo umount /mnt

.PHONY: run clean bin purge diff genie patch install
