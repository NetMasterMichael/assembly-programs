# Assembling programs into 32-bit ELF executables (Linux)
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
