
all:	6309

6309: main.asm
	lwasm -DM6309 --list -3 -b -o EXAMPLE.BIN main.asm > example.lst
	decb copy -r -2 -b EXAMPLE.BIN /media/share1/COCO/drive0.dsk,EXAMPLE.BIN

6809: main.asm
	lwasm -DM6809 --list -9 -b -o EXAMPLE.BIN main.asm > example.lst
	decb copy -r -2 -b EXAMPLE.BIN /media/share1/COCO/drive0.dsk,EXAMPLE.BIN

clean:
	rm -f *.bin *.lst

backup:
	tar -cvf backups/`date +%Y-%m-%d_%H-%M-%S`.tar Makefile *.asm notes

install:
	rcp EXAMPLE.BIN ricka@rickadams.org:/home/ricka/rickadams.org/downloads/EXAMPLE.BIN
