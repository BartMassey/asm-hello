# Copyright © 2016 Bart Massey
# Makefile for Hello World in x86-64 assembly.

# [This work is licensed under the "MIT License". Please see
# the file `COPYING` in this distribution for license details.]

LIB = /lib/x86_64-linux-gnu

.SUFFIXES: .S

hello: hello.o
	ld -L$(LIB)/ -I$(LIB)/ld-linux-x86-64.so.2 -o hello hello.o -lc

hello.o: hello.S
	as --gstabs+ -o hello.o hello.S

clean:
	-rm -f hello.o hello
