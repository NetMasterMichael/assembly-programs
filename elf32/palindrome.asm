;
;  File:    palindrome.asm
;  Author:  Michael Goodwin (NetMasterMichael)
;  Date:    2024-07-23
;

global _start

section .bss
  input resb 255

section .data
  input_msg db "Please enter a string (case sensitive): "
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
  mov eax, 4             ; write syscall
  mov ebx, 1             ; stdout file descriptor
  mov ecx, input_msg     ; pointer to bytes to write
  mov edx, inp_len       ; number of bytes to write
  int 0x80               ; make syscall
  mov eax, 3             ; read syscall
  mov ebx, 0             ; stdin file descriptor
  mov ecx, input         ; pointer to memory to read bytes into
  mov edx, 255           ; max number of bytes to read
  int 0x80               ; make syscall, returns input length to eax

  ; string validation
  cmp eax, 1             ; is the string just an empty line or a negative value?
  jle error              ; if yes, jump to error
  dec eax                ; otherwise decrement eax to ignore new line
  push eax               ; push eax onto stack for later

  ; palindrome checking
  mov esi, input         ; move address of input into source index
  mov edi, input         ; move address of input into destination index
  add edi, eax           ; add length of input to edi address
  dec edi                ; decrement edi, as eax includes first character, edi already points to this
palindrome_check:
  mov bl, [esi]          ; move character at esi into bl
  mov bh, [edi]          ; move character at edi into bh
  cmp bl, bh             ; compare bl to bh
  jne is_not_palindrome  ; if bl and bh aren't equal, it must not be a palindrome
  cmp eax, 1             ; did we check the last character?
  je is_palindrome       ; if yes, all characters have been checked, string must be a palindrome
  ; otherwise we must check the next characters
  inc esi                ; move esi to point at the next character
  dec edi                ; move edi to point at the previous character
  dec eax                ; decrement number of characters left to check
  jmp palindrome_check   ; run checks again

is_not_palindrome:
  ; write input to console
  mov eax, 4             ; write syscall
  mov ebx, 1             ; stdout file descriptor
  mov ecx, input         ; pointer to bytes to write
  pop edx                ; pop length of input from stack that we pushed earlier
  int 0x80               ; make syscall
  ; write not palindrome message to console
  mov eax, 4             ; write syscall
  mov ebx, 1             ; stdout file descriptor
  mov ecx, not_pal_msg   ; pointer to bytes to write
  mov edx, not_pal_len   ; number of bytes to write
  int 0x80               ; make syscall
  mov ebx, 0             ; exit code for successful exit (although input wasn't a palindrome, no errors occurred)
  jmp end                ; jump to the end section

is_palindrome:
  ; write input to console
  mov eax, 4             ; write syscall
  mov ebx, 1             ; stdout file descriptor
  mov ecx, input         ; pointer to bytes to write
  pop edx                ; pop length of input from stack that we pushed earlier
  int 0x80               ; make syscall
  ; write the is palindrome message to console
  mov eax, 4             ; write syscall
  mov ebx, 1             ; stdout file descriptor
  mov ecx, is_pal_msg    ; pointer to bytes to write
  mov edx, is_pal_len    ; number of bytes to write
  int 0x80               ; make syscall
  mov ebx, 0             ; exit code for successful exit
  jmp end                ; jump to the end section

error:
  mov eax, 4             ; write syscall
  mov ebx, 1             ; stdout file descriptor
  mov ecx, err_msg       ; pointer to bytes to write
  mov edx, err_len       ; number of bytes to write
  int 0x80               ; make syscall
  mov ebx, 1             ; exit code for error exit
  jmp end                ; jump to the end section

end:
  mov eax, 1             ; exit syscall
  int 0x80               ; make syscall, process terminates
