name = mypatch

run: bin
	fceux
genie: bin
	./genie
bin: asm
	./asm -q smb.asm smb.nes smb.lst
	awk "BEGIN{for(c=0;c<(32767 - $$(du -sb smb.nes | cut -f1) );c++) printf \"-\"; printf \"\"}" >> smb.nes
	cat smb.chr >> smb.nes
clean:
	-rm *.nes *.lst
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
install: builds
	sudo mount /dev/sdb1 /mnt
	sudo cp builds/* /mnt/roms/nes/
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
	for file in $$(find patches/ -type f | grep -v jump.patch | grep -v scroll.patch | grep -v sonic.patch | grep -v slide.patch) ; do \
		patch -i $$file smb.asm; \
	done
	make bin
	mv smb.nes builds/great.nes
	git checkout -- smb.asm
push: builds
	rm smb.asm.orig
	git add .
	git commit
	git push

.PHONY: run clean bin purge diff genie patch install push builds
