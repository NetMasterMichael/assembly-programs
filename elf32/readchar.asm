global _start

section .bss
  char resb 2
  newline resb 1

section .data
  msg db "Enter a character and press enter: "
  msg_len equ $ - msg
  endmsg db "Your character was "
  endmsg_len equ $ - endmsg

section .text
_start:
  ; output initial message
  mov eax, 4              ; sys_write
  mov ebx, 1              ; file descriptor for stdout
  mov ecx, msg            ; pointer to msg
  mov edx, msg_len        ; number of bytes of msg
  int 0x80                ; make syscall

  ; read a char from stdin
  mov eax, 3              ; sys_read
  mov ebx, 0              ; file descriptor for stdin
  mov ecx, char           ; move input to char address
  mov edx, 1              ; read 1 byte
  int 0x80                ; make syscall
  mov byte [char+1], 0x0a ; add new line after char

  ; read newline from stdin to fix double new line bug. nothing is done with this input
  mov eax, 3              ; sys_read
  mov ebx, 0              ; file descriptor for stdin
  mov ecx, newline        ; move input to newline address
  mov edx, 1              ; read 1 byte
  int 0x80	          ; make syscall

  ; output second message, starting with endmsg
  mov eax, 4              ; sys_write
  mov ebx, 1              ; file descriptor for stdout
  mov ecx, endmsg         ; pointer to endmsg
  mov edx, endmsg_len     ; number of bytes of endmsg
  int 0x80                ; make syscall
  ; output char with new line
  mov eax, 4              ; sys_write
  mov ebx, 1              ; file descriptor for stdout
  mov ecx, char           ; pointer to char
  mov edx, 2              ; write 2 bytes
  int 0x80                ; make syscall

  ; terminate process gracefully
  mov eax, 1              ; sys_exit
  mov ebx, 0              ; exit code 0
  int 0x80                ; make syscall
