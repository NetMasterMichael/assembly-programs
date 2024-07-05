# x86-assembly-programs
Welcome to my repository of assembly programs I've written as I learn x86 assembly. The programs you'll find in here range from very short programs that "do nothing perfectly", to hopefully some more interesting programs down the line! I have made this repository public so that anyone who is interested in assembly may see some workng examples.

I have decided to take on the challenge to learn assembly for the following reasons:
- As a primer for progressing onto OS development
- To improve my malware analysis skills
- To challenge myself to learn something harder than a high-level language, no more nice abstractions
- Because I am interested in controlling the hardware at the very lowest level!

I hope that you may find something in here that intrigues you. I will be adding more files here over time as I learn more assembly.
## Assembling programs on Linux
The software that I use to assemble these programs is called `nasm`. You can install this using your package manager of choice, `apt` is shown below.
```bash
sudo apt update
sudo apt install nasm
```
Unlike most high-level languages, there is more than one command needed to go from x86 assembly source code to an executable. The first step is to assemble the object file from the source code. This converts the assembly instructions into machine code for the specified architecture, but leaves unresolved references to functions and data items that aren't defined within the program itself. We can do this with `nasm` as follows:
```bash
nasm -f elf32 -o program.o program.asm
```
Next, we need to use a linker to resolve the remaining unresolved references to external libraries and build an executable file. This can be done using:
```bash
ld -m elf_i386 -o program program.o
```
The use of `elf32` and `elf_i386` means that we will create a 32-bit ELF binary that can be executed on a Linux system.
