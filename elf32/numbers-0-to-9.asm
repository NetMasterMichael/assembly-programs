;
;  File:    numbers-0-to-9.asm
;  Author:  Michael Goodwin (NetMasterMichael)
;  Date:    2024-07-16
;

global _start

section .data
  counter db '0', 0xA ; ascii character to print, with a new line
  lim dw 9            ; number of times the program should loop

section .text
_start:
loop:
  mov eax, 4          ; sys_write syscall
  mov ebx, 1          ; stdout
  mov ecx, counter    ; pointer to counter
  mov edx, 2          ; write two characters of counter
  int 0x80            ; make syscall

  mov al, [lim]       ; move value at address lim  into al
  cmp al, 0           ; is lim 0?
  je end              ; if yes, jump to end and terminate, otherwise continue

  mov al, [counter]   ; move value at address counter into al
  inc al              ; add 1 to al
  mov [counter], al   ; move al to value at address counter

  mov al, [lim]       ; move value at address lim into al
  dec al              ; subtract 1 from al
  mov [lim], al       ; move al to value at address lim
  jmp loop            ; repeat the loop

end:
  mov eax, 1          ; sys_exit syscall
  mov ebx, 0          ; exit code 0 (success)
  int 0x80            ; make syscall
