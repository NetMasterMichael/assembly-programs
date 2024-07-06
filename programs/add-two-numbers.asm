global _start

section .bss
  sum resb 1

section .data
  num_one equ 60
  num_two equ 7

section .text
_start:
  mov eax, num_one
  add eax, num_two
  add eax, '0' ; convert to ascii
  mov [sum], al
  mov eax, 4
  mov ebx, 1
  mov ecx, sum
  mov edx, 1
  int 0x80

  mov eax, 1
  mov ebx, 0
  int 0x80
