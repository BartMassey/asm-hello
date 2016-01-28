# Copyright © 2016 Bart Massey
# Hello World in AMD64 assembly for Linux
	
# [This work is licensed under the "MIT License". Please see
# the file `COPYING` in this distribution for license details.]
	
# By C convention we stick strings in read-only
# data rather than in the data section.        

	.section .rodata
.hello_string:
        .string "hello world\n"
        .text
	
# The OS (actually ld-linux.so) executes a dynamically-linked
# program by setting up the registers just so and jumping
# to the address given by the global symbol _start.
	.globl  _start
_start: 
	# First, set up the base pointer for C calling.
	movq    %rsp, %rbp
	# First printf argument.
        movq    $.hello_string, %rdi
	# End of printf argument list is second argument.
        movq    $0, %rsi
        call    printf
	# If printf returns -1 there is an error.
        cmpq    $-1, %rax
        je      abort

	# We need to call the exit system call
        # to stop our process running.

	# System call number.
        movq    $1, %rax
	# Exit status argument.
        movq    $0, %rbx
	# Make a system call.
        int     $0x80
