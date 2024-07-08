global _start

section .bss
  sum resb 1       ; reserve one byte for sum of numbers

section .data
  num_one equ 60
  num_two equ 7

section .text
_start:
  mov eax, num_one ; move num_one to eax
  add eax, num_two ; add num_two to num_one inside eax
  add eax, '0'     ; convert to ascii
  mov [sum], al    ; move result back into memory
  mov eax, 4       ; sys_write syscall
  mov ebx, 1       ; stdout
  mov ecx, sum     ; output ascii value of sum
  mov edx, 1       ; length of output
  int 0x80         ; make syscall

  mov eax, 1       ; sys_exit
  mov ebx, 0       ; exit code
  int 0x80         ; make syscall
