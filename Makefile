
all:	6309

6309: main.asm
	lwasm -DM6309 -3 -b -o EXAMPLE.BIN main.asm
	decb copy -r -2 -b EXAMPLE.BIN /media/share1/COCO/drive0.dsk,EXAMPLE.BIN

6809: main.asm
	lwasm -DM6809 -9 -b -o EXAMPLE.BIN main.asm
	decb copy -r -2 -b EXAMPLE.BIN /media/share1/COCO/drive0.dsk,EXAMPLE.BIN

clean:
	rm -f *.bin

backup:
	tar -cvf backups/`date +%Y-%m-%d_%H-%M-%S`.tar Makefile *.asm notes
