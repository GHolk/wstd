
all: wfk.js node_modules/*.js

opk2m: opk2m.c
	gcc -lm -o opk2m opk2m.c

%.js: %.coffee
	coffee -c $<

