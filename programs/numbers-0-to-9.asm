global _start

section .data
  counter db '0', 0xA 
  lim dw 9

section .text
_start:
loop:
  mov eax, 4
  mov ebx, 1
  mov ecx, counter
  mov edx, 2
  int 0x80

  mov al, [lim]
  cmp al, 0
  je end
  mov al, [counter]
  inc al
  mov [counter], al
  mov al, [lim]
  dec al
  mov [lim], al
  jmp loop

end:
  mov eax, 1
  mov ebx, 0
  int 0x80
