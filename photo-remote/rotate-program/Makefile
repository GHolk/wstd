
all: wfk.js node_modules/matrix.js node_modules/vector.js

opk2m: opk2m.c
	gcc -lm -o opk2m opk2m.c

%.js: %.coffee
	coffee -c $<

