# Hello World in x86-64 assembly for Linux
Bart Massey

I've scratch-written an assembly version of "hello world"
in x86-64 assembly to see what's going on there. You can
simply say "make" in this directory to build it, and
then "./hello" to run it. It should do the obvious thing,
and then exit with status 0.

## The assembly code

The assembly code here has several jobs:

* Define the "hello world" string needed by the program.

* Define the entry point "_start" at which the dynamic
  loader will start the program.

* Set up `%rbp` so that the C calling conventions are
  satisfied. We needn't save the old %rbp here, because
  we will never use it.

* Set up the arguments to "printf" and call it.

* Check the return value to see if there was an error
  and call the "abort" system call if so. (It should
  never return, so we just jump to it.)

* Call the exit system call to end program execution.

We put the assembly code in file with extension ".S" rather
than ".s". The assembler is fine with this, and it means we
will never accidentally overwrite or remove our hand-written
assembly when working with the C compiler.

## C calling conventions for x86-64 Linux

The C compiler expects that functions will be called
with `%rsp` pointing at top of stack, `%rbp` pointing
at the location where the return value will be held,
and the arguments passed as follows:

        arg  register
        0    %rdi
        1    %rsi
        2    %rdx
        3    %rcx
        4    %r8
        5    %r9

Floating point arguments are special, and are passed in `%xmm0`..`%xmm7`.
Additional arguments are passed on the stack, pushed in
order. `structs` are passed on the stack, in general,
although there are register-passing conventions for
structs. See elsewhere for details.

Registers `%rbp`, `%rbx`, and `%r12`..`%r15` are
callee-saves: all others are caller-saves.

# System Call conventions for x86-64 Linux

To make a system call, one first puts the system call number
in `%rax`. Then the syscall arguments are passed as follows:

        arg  register
        0    %rdi
        1    %rsi
        2    %rdx
        3    %r10
        4    %r8
        5    %r9

There are at most 6 arguments to any system call: all must
be either pointers or integers. The result
is returned in `%rax`: if the result is in the range
-4095..-1 it is an error number.

Confusingly, the correct syscall numbers can be found in
`/usr/include/x86_64-linux-gnu/asm/unistd_32.h`.

## Assembling

There is nothing terribly special about the assembly
command. The only thing of note is "--gstabs+", which adds a
debugging section to the object file such that `gdb` knows
that it is assembly code and makes it easier to work with.

## Linking

Most of the linker stuff is straightforward. For dynamic
loading, the executable needs to know where the shared
libraries will live and what dynamic loader to use to get
them.

Note that we have deliberately ignored the C setup routines
that arrange to have `main` called. This is a bit iffy,
since this code potentially also initializes some C library
stuff. If one chose, one could modify our code to build
a normal `main` function, and then link with

        /usr/lib/x86_64-linux-gnu/crti.o
        /usr/lib/x86_64-linux-gnu/crtn.o
        /usr/lib/x86_64-linux-gnu/crt1.o

to get things set up. In this case, we could just
return normally instead of exiting.

## References

* [Wikipedia on calling conventions](http://en.wikipedia.org/wiki/X86_calling_conventions#System_V_AMD64_ABI)

* [Stack Overflow on system calls](http://stackoverflow.com/a/2538212/364875)

* [Gnu Assembler](http://tigcc.ticalc.org/doc/gnuasm.html)

* [CMU Assembly Programming handout](https://www.cs.cmu.edu/~fp/courses/15213-s07/misc/asm64-handout.pdf)

* [Assembly Debugging with GDB](http://dbp-consulting.com/tutorials/debugging/basicAsmDebuggingGDB.html)

* [Stack Overflow on x86-64 CRT files](http://stackoverflow.com/a/18091683/364875)

* [Setting Up A Replacement C Library](http://wiki.osdev.org/Creating_a_C_Library)

## License

This work is licensed under the "MIT License". Please see
the file `COPYING` in this distribution for license details.
