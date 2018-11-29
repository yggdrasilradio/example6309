#
# make		Build 6309 version
# make clean	Remove all binary and listing files
# make 6809	Build 6809 version
# make backup	Save backup of current source files
#

all:	6309

6309: main.asm
	lwasm -DM6309 --list -3 -b -o EXAMPLE.BIN main.asm > example.lst
ifneq ("$(wildcard /media/share1/COCO/drive0.dsk)","")
	decb copy -r -2 -b EXAMPLE.BIN /media/share1/COCO/drive0.dsk,EXAMPLE.BIN
endif

6809: main.asm
	lwasm -DM6809 --list -9 -b -o EXAMPLE.BIN main.asm > example.lst
ifneq ("$(wildcard /media/share1/COCO/drive0.dsk)","")
	decb copy -r -2 -b EXAMPLE.BIN /media/share1/COCO/drive0.dsk,EXAMPLE.BIN
endif

clean:
	rm -f *.bin *.lst

backup:
	tar -cvf backups/`date +%Y-%m-%d_%H-%M-%S`.tar Makefile *.asm notes
