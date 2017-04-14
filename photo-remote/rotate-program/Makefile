
all: opk2m wfk.js

opk2m: opk2m.c
	gcc -lm -o opk2m opk2m.c

%.js: %.coffee
	coffee -c $<

