
all:	example

example: main.asm
	lwasm -3 -b -o EXAMPLE.BIN main.asm
	decb copy -r -2 -b EXAMPLE.BIN /media/share1/COCO/drive0.dsk,EXAMPLE.BIN

clean:
	rm -f *.bin

install:
	rcp EXAMPLE.BIN ricka@rickadams.org:/home/ricka/rickadams.org/downloads/EXAMPLE.BIN

backup:
	tar -cvf backups/`date +%Y-%m-%d_%H-%M-%S`.tar Makefile *.asm

