
all: opk2m try

try:
	./opk2m

opk2m: opk2m.c
	gcc -lm -o opk2m opk2m.c

