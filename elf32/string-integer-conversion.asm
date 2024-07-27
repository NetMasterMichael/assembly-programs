;
;  File:    string-integer-conversion.asm
;  Author:  Michael Goodwin (NetMasterMichael)
;  Date:    2024-07-27
;

global _start

section .bss
  string_input resb 255
  string_conv resb 255

section .data
  msg1 db "Please enter a number: "
  msg1_len equ $ - msg1
  msg2 db "Converting to integer...", 0xA
  msg2_len equ $ - msg2
  msg3 db "Converting to string...", 0xA
  msg3_len equ $ - msg3
  msg4 db "Your number is "
  msg4_len equ $ - msg4
  err_msg db "Invalid number entered, exiting", 0xA
  err_len equ $ - err_msg
  int_conv dd 0

section .text
_start:
  ; Get input from user
  mov eax, 4
  mov ebx, 1
  mov ecx, msg1
  mov edx, msg1_len
  int 0x80
  mov eax, 3
  mov ebx, 0
  mov ecx, string_input
  mov edx, 255
  int 0x80
  cmp eax, 1
  jle error
  dec eax
  push eax

convert_to_integer_setup:
  mov esi, string_input ; move address of input to esi
  add esi, eax ; add number of digits of input to esi
  dec esi ; move index backwards to ignore new line 
  mov eax, 4
  mov ebx, 1
  mov ecx, msg2
  mov edx, msg2_len
  int 0x80

  ; al of eax will be used for each digit
  ; ebx will be used as the column multiplier
  ; int_conv is the final destination, we'll initialise it with 0 to start
  xor eax, eax
  mov ebx, 1
convert_to_integer_loop:
  cmp esi, string_input
  jl convert_to_string_setup
  mov al, [esi]
  sub al, '0'
  mul ebx

  add [int_conv], al
  imul ebx, 10
  dec esi
  jmp convert_to_integer_loop

convert_to_string_setup:
  mov eax, 4
  mov ebx, 1
  mov ecx, msg3
  mov edx, msg3_len
  int 0x80
  mov esi, string_conv
convert_to_string_loop:
  

output_converted_string:
  mov eax, 4
  mov ebx, 1
  mov ecx, msg4
  mov edx, msg4_len
;  int 0x80
  mov eax, 4
  mov ebx, 1
  mov ecx, string_conv
  pop edx
  int 0x80
  mov ebx, 0
  jmp terminate_process

error:
  mov eax, 4
  mov ebx, 1
  mov ecx, err_msg
  mov edx, err_len
  int 0x80
  mov ebx, 1
  jmp terminate_process

terminate_process:
  mov eax, 1
  int 0x80
