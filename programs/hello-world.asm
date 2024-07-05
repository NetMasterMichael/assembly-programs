global _start

section .data
  msg db "Hello, world!", 0x0a ; a string ending with a new line character
  len equ $ - msg              ; compute length by subtracting address of msg from current address

section .text
_start:
  mov eax, 4                   ; sys_write syscall
  mov ebx, 1                   ; file descriptor for stdout
  mov ecx, msg                 ; pointer to bytes to write
  mov edx, len                 ; number of bytes to write
  int 0x80                     ; make syscall

  ; terminate program
  mov eax, 1                   ; sys_exit syscall
  xor ebx, ebx                 ; zero the register
  int 0x80                     ; make syscall
