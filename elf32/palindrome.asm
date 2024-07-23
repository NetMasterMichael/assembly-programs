;
;  File:    palindrome.asm
;  Author:  Michael Goodwin (NetMasterMichael)
;  Date:    2024-07-23
;

global _start

section .bss
  input resb 255

section .data
  input_msg db "Please enter a string: "
  inp_len equ $ - input_msg
  is_pal_msg db " is a palindrome.", 0xA
  is_pal_len equ $ - is_pal_msg
  not_pal_msg db " is not a palindrome.", 0xA
  not_pal_len equ $ - not_pal_msg
  err_msg db "Error: Invalid string entered, exiting", 0xA
  err_len equ $ - err_msg

section .text
_start:
  ; receive input from user
  mov eax, 4
  mov ebx, 1
  mov ecx, input_msg
  mov edx, inp_len
  int 0x80
  mov eax, 3
  mov ebx, 0
  mov ecx, input
  mov edx, 255
  int 0x80 ; make syscall, returns input length to eax

  ; string validation
  cmp eax, 1 ; is the string just an empty line or a negative value?
  jle error ; if yes, jump to error
  dec eax ; otherwise decrement eax to ignore new line
  push eax ; push eax onto stack for later

  ; palindrome checking
  mov esi, input
  mov edi, input
  add edi, eax
  dec edi
palindrome_check:
  xor ebx, ebx
  xor ecx, ecx
  mov bl, [esi]
  mov cl, [edi]
  cmp bl, cl
  jne is_not_palindrome
  cmp eax, 1
  je is_palindrome
  inc esi
  dec edi
  dec eax
  jmp palindrome_check

is_not_palindrome:
  mov eax, 4
  mov ebx, 1
  mov ecx, input
  pop edx
  int 0x80
  mov eax, 4
  mov ebx, 1
  mov ecx, not_pal_msg
  mov edx, not_pal_len
  int 0x80
  mov ebx, 0
  jmp end

is_palindrome:
  mov eax, 4
  mov ebx, 1
  mov ecx, input
  pop edx
  int 0x80
  mov eax, 4
  mov ebx, 1
  mov ecx, is_pal_msg
  mov edx, is_pal_len
  int 0x80
  mov ebx, 0
  jmp end

error:
  mov eax, 4
  mov ebx, 1
  mov ecx, err_msg
  mov edx, err_len
  int 0x80
  mov ebx, 1
  jmp end

end:
  mov eax, 1
  int 0x80
