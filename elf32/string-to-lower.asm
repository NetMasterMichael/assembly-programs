;
;  File:    string-to-lower.asm
;  Author:  Michael Goodwin (NetMasterMichael)
;  Date:    2024-07-24
;

global _start

section .bss
  input resb 255

section .data
  msg1 db "Please enter a string to convert to lowercase", 0xA
  msg1_len equ $ - msg1
  msg2 db "Your string in lowercase is "
  msg2_len equ $ - msg2
  err_msg db "Invalid string entered, exiting", 0xA
  err_len equ $ - err_msg

section .text
_start:
  mov eax, 4             ; write syscall
  mov ebx, 1             ; stdout file descriptor
  mov ecx, msg1          ; pointer to bytes to write
  mov edx, msg1_len      ; number of bytes to write
  int 0x80               ; make syscall
  mov eax, 3             ; read syscall
  mov ebx, 0             ; stdin file descriptor
  mov ecx, input         ; pointer to location to read bytes into
  mov edx, 255           ; maximum number of bytes to read
  int 0x80               ; make syscall
  ; string validation
  cmp eax, 1             ; number of bytes read is returned to eax, check if it's only a new line or negative
  jle error              ; if true, jump to error
  push eax               ; otherwise, push eax to reuse later
  dec eax                ; decrement eax after pushing to ignore new line during conversion (but keep new line for later)

  ; convert uppercase characters to lowercase
  mov esi, input         ; move address of input to esi
to_upper:
  mov bl, [esi]          ; move value at address in esi to bl
  cmp bl, 65             ; is bl less than (and not equal to) 65? (ASCII value for 'A')
  jl move_to_next        ; if true, skip character
  cmp bl, 90             ; or is bl greater than (and not equal to) 90? (ASCII value for 'Z')
  jg move_to_next        ; if true, skip character
  add bl, 32             ; add 32 to bl, value now corresponds with same letter in ASCII but lowercase
  mov [esi], bl          ; move lowercase character at bl to address at esi
move_to_next:
  inc esi                ; move address to next character
  dec eax                ; decrement number of characters remaining to check
  cmp eax, 0             ; are there zero characters remaining to check?
  jne to_upper           ; if false, jump to to_upper
  ; otherwise instructions will sequentially continue to output, no jump needed

output:
  mov eax, 4             ; write syscall
  mov ebx, 1             ; stdout file descriptor
  mov ecx, msg2          ; pointer to bytes to write
  mov edx, msg2_len      ; number of bytes to write
  int 0x80               ; make syscall
  mov eax, 4             ; write syscall
  mov ebx, 1             ; stdout file descriptor
  mov ecx, input         ; pointer to bytes to write
  pop edx                ; pop into edx the length of input pushed onto the stack earlier
  int 0x80               ; make the syscall
  mov ebx, 0             ; success exit code
  jmp terminate_process  ; unconditional jump to the label terminate_process

error:
  mov eax, 4             ; write syscall
  mov ebx, 1             ; stdout file descriptor
  mov ecx, err_msg       ; pointer to bytes to write
  mov edx, err_len       ; number of bytes to write
  int 0x80               ; make syscall
  mov ebx, 1             ; error exit code
  jmp terminate_process  ; unconditional jump to the label terminate_process

terminate_process:
  mov eax, 1             ; exit syscall
  int 0x80               ; make syscall and terminate the process
