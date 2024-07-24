;
;  File:    palindrome-v2.asm
;  Author:  Michael Goodwin (NetMasterMichael)
;  Date:    2024-07-24
;

;  Differences between palindrome and palindrome-v2:
;  - Spaces are ignored
;  - Not case sensitive

global _start

section .bss
  input resb 255
  sanitised_input resb 255

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
  mov eax, 4                 ; write syscall
  mov ebx, 1                 ; stdout file descriptor
  mov ecx, input_msg         ; pointer to bytes to write
  mov edx, inp_len           ; number of bytes to write
  int 0x80                   ; make syscall
  mov eax, 3                 ; read syscall
  mov ebx, 0                 ; stdin file descriptor
  mov ecx, input             ; pointer to memory to read bytes into
  mov edx, 255               ; max number of bytes to read
  int 0x80                   ; make syscall, returns input length to eax

  ; string validation
  cmp eax, 1                 ; is the string just an empty line or a negative value?
  jle error                  ; if yes, jump to error
  dec eax                    ; otherwise decrement eax to ignore new line
  push eax                   ; push eax onto stack for later

  ; string sanitisation
  ; copy string into another buffer
  mov esi, input             ; move address of source in esi
  mov edi, sanitised_input   ; move address of destination in edi
  mov ecx, eax               ; move length of input into ecx for the string copy operation
  rep movsb                  ; copy ecx bytes at esi to edi

  ; remove spaces from input
  mov esi, sanitised_input   ; move address of sanitised_input into esi
  mov edi, sanitised_input   ; move address of sanitised_input into edi
  mov ecx, eax               ; move length of input into ecx
remove_spaces:
  cmp ecx, 0                 ; have all characters been checked?
  je convert_to_lowercase    ; if yes, jump to the start of converting sanitised_input to lowercase
  mov bl, [esi]              ; otherwise, mov char at address esi into bl
  cmp bl, 32                 ; is char a space?
  je remove_spaces_dec       ; if yes, skip copying bl (esi) to edi
  mov [edi], bl              ; copy bl to value at address edi
  inc edi                    ; increment edi address to move to the next character
remove_spaces_dec:
  inc esi                    ; increment esi address to move to the next character
  dec ecx                    ; decrement number of characters remaining to check
  jmp remove_spaces          ; jump to beginning of loop

  ; convert sanitised_input to all lowercase, so that it isn't case sensitive
  ; input is more likely to be lowercase than uppercase, so it's more efficient converting to lowercase than to uppercase
convert_to_lowercase:
  ; setup to convert to lowercase
  mov esi, sanitised_input   ; move address of sanitised_input into esi
  mov ecx, eax               ; copy eax (length of string) into ecx again
convert_character:
  mov bl, [esi]              ; copy value at address in esi to bl
  cmp bl, 65                 ; compare bl and 65 (ASCII for 'A')
  jl point_next_character    ; if less, skip character and check the next one
  cmp bl, 90                 ; compare bl and 90 (ASCII for 'Z')
  jg point_next_character    ; if greater, skip character and check the next one
  add bl, 32                 ; character must be uppercase, add 32 to convert it to its lowercase equivalent
  mov [esi], bl              ; copy lowercase character into value at address in esi register
point_next_character:
  inc esi                    ; increment esi to point to the next character
  dec ecx                    ; decrement ecx (number of characters remaining to check)
  cmp ecx, 0                 ; have all characters been checked?
  je palindrome_check_start  ; if true, jump to checking if sanitised_input is a palindrome
  jmp convert_character      ; otherwise, jump to convert_character and repeat process

  ; palindrome checking
palindrome_check_start:
  ; compute length of sanitised input
  sub edi, sanitised_input   ; subtract address of edi from address of sanitised_input to get the new length
  mov eax, edi               ; copy sanitised_input length into eax
  ; setup to check if sanitised_input is a palindrome
  mov esi, sanitised_input   ; move address of input into source index
  mov edi, sanitised_input   ; move address of input into destination index
  add edi, eax               ; add length of input to edi address
  dec edi                    ; decrement edi, as eax includes first character, edi already points to this
palindrome_check:
  mov bl, [esi]              ; move character at esi into bl
  mov bh, [edi]              ; move character at edi into bh
  cmp bl, bh                 ; compare bl to bh
  jne is_not_palindrome      ; if bl and bh aren't equal, it must not be a palindrome
  cmp eax, 1                 ; did we check the last character?
  je is_palindrome           ; if yes, all characters have been checked, string must be a palindrome
  ; otherwise we must check the next characters
  inc esi                    ; move esi to point at the next character
  dec edi                    ; move edi to point at the previous character
  dec eax                    ; decrement number of characters left to check
  jmp palindrome_check       ; run checks again

is_not_palindrome:
  ; write input to console
  mov eax, 4                 ; write syscall
  mov ebx, 1                 ; stdout file descriptor
  mov ecx, input             ; pointer to bytes to write
  pop edx                    ; pop length of input from stack that we pushed earlier
  int 0x80                   ; make syscall
  ; write not palindrome message to console
  mov eax, 4                 ; write syscall
  mov ebx, 1                 ; stdout file descriptor
  mov ecx, not_pal_msg       ; pointer to bytes to write
  mov edx, not_pal_len       ; number of bytes to write
  int 0x80                   ; make syscall
  mov ebx, 0                 ; exit code for successful exit (although input wasn't a palindrome, no errors occurred)
  jmp end                    ; jump to the end section

is_palindrome:
  ; write input to console
  mov eax, 4                 ; write syscall
  mov ebx, 1                 ; stdout file descriptor
  mov ecx, input             ; pointer to bytes to write
  pop edx                    ; pop length of input from stack that we pushed earlier
  int 0x80                   ; make syscall
  ; write the is palindrome message to console
  mov eax, 4                 ; write syscall
  mov ebx, 1                 ; stdout file descriptor
  mov ecx, is_pal_msg        ; pointer to bytes to write
  mov edx, is_pal_len        ; number of bytes to write
  int 0x80                   ; make syscall
  mov ebx, 0                 ; exit code for successful exit
  jmp end                    ; jump to the end section

error:
  mov eax, 4                 ; write syscall
  mov ebx, 1                 ; stdout file descriptor
  mov ecx, err_msg           ; pointer to bytes to write
  mov edx, err_len           ; number of bytes to write
  int 0x80                   ; make syscall
  mov ebx, 1                 ; exit code for error exit
  jmp end                    ; jump to the end section

end:
  mov eax, 1                 ; exit syscall
  int 0x80                   ; make syscall, process terminates
