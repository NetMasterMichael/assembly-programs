global _start

section .data
  numA db 12
  numB db 12
  greater_than db "Number A is greater than number B", 0xA
  gt_len equ $ - greater_than
  less_than db "Number A is less than number B", 0xA
  lt_len equ $ - less_than
  equals db "Number A and number B are equal", 0xA
  equ_len equ $ - equals

section .text
_start:
  mov al, [numA] ; move numA into al
  cmp al, [numB] ; compare numA to numB
  jg greater
  jl less
  je equal

greater:
  mov eax, 4
  mov ebx, 1
  mov ecx, greater_than
  mov edx, gt_len
  int 0x80
  jmp end

less:
  mov eax, 4
  mov ebx, 1
  mov ecx, less_than
  mov edx, lt_len
  int 0x80
  jmp end

equal:
  mov eax, 4
  mov ebx, 1
  mov ecx, equals
  mov edx, equ_len
  int 0x80
  jmp end

end:
  mov eax, 1
  mov ebx, 0
  int 0x80
