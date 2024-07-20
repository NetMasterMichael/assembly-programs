global _start

section .bss
  string resb 255   ; dynamically allocate 255 bytes of memory

section .data
  msg1 db "Enter your name: "
  msg1_len equ $ - msg1
  msg2 db "Hello, "
  msg2_len equ $ - msg2
  err db "Error, invalid string entered", 0xA
  err_len equ $ - err

section .text
_start:
  mov eax, 4        ; sys_write syscall
  mov ebx, 1        ; stdout file descriptor
  mov ecx, msg1     ; pointer to first message
  mov edx, msg1_len ; number of bytes of message
  int 0x80          ; make syscall

  mov eax, 3        ; sys_read syscall
  mov ebx, 0        ; stdin file descriptor
  mov ecx, string   ; pointer to empty dynamically allocated memory
  mov edx, 255      ; accept a maximum of 255 bytes
  int 0x80          ; make syscall

  cmp eax, 1        ; sys_read writes the number of bytes read to eax. check it's not empty (new line is counted)
  jle error         ; if 1 byte was read or eax is negative, jump to error
  push eax          ; otherwise push eax onto the stack

  mov eax, 4        ; sys_write syscall
  mov ebx, 1        ; stdout file descriptor
  mov ecx, msg2     ; pointer to second message
  mov edx, msg2_len ; number of bytes of message
  int 0x80          ; make syscall
  mov eax, 4        ; sys_write syscall
  mov ebx, 1        ; stdout file descriptor
  mov ecx, string   ; pointer to string
  pop edx           ; pop length of string from stack
  int 0x80          ; make syscall
  mov ebx, 0        ; program executed successfully, success exit code
  jmp end

error:
  mov eax, 4        ; sys_write syscall
  mov ebx, 1        ; stdout file descriptor
  mov ecx, err      ; pointer to error message
  mov edx, err_len  ; number of bytes of error message
  int 0x80          ; make syscall
  mov ebx, 1        ; program executed with an error, error exit code
  jmp end

end:
  mov eax, 1        ; sys_exit syscall
  int 0x80          ; ebx is already populated, make syscall
