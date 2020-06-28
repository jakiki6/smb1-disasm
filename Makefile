name = mypatch

run: bin
	mono ~/Mesen.exe
genie: bin
	./genie
bin: asm
	./asm -q smb.asm smb.nes smb.lst
clean:
	rm *.nes
	rm *.lst
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
builds:
	git checkout -- smb.asm
	rm builds/*
	for file in $$(find patches/ -type f) ; do \
		patch -i $$file smb.asm; \
		make bin ; \
		mv smb.nes builds/$$(echo $$file | cut -d"/" -f2 | cut -d"." -f1).nes ; \
                git checkout -- smb.asm ; \
        done
	for file in $$(find patches/ -type f) ; do \
                patch -i $$file smb.asm; \
	done
	make bin
	mv smb.nes builds/all.nes
	git checkout -- smb.asm
push: builds
	rm smb.asm.orig
	git add .
	git commit
	git push

.PHONY: run clean bin purge diff genie patch install push builds
