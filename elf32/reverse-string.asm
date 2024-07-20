global _start

section .bss
  string resb 255
  revstring resb 255

section .data
  msg1 db "Enter a string to reverse: "
  msg1_len equ $ - msg1
  msg2 db "Your string in reverse is "
  msg2_len equ $ - msg2
  err db "Invalid string entered, exiting", 0xA
  err_len equ $ - err

section .text
_start:
  ; get a string from the user
  mov eax, 4           ; sys_write syscall
  mov ebx, 1           ; stdout file descriptor (terminal)
  mov ecx, msg1        ; pointer to string to write
  mov edx, msg1_len    ; number of bytes to write
  int 0x80             ; make syscall
  mov eax, 3           ; sys_read syscall
  mov ebx, 0           ; stdin file descriptor
  mov ecx, string      ; pointer to location to save user input
  mov edx, 255         ; max number of bytes to accept
  int 0x80             ; make syscall

  ; string validation
  cmp eax, 1           ; is string read 1 byte long (only a new line) or negative (error occurred)?
  jle error            ; if yes, jump to error label
  dec eax              ; otherwise, decrement eax to ignore the new line character at end of user input
  mov ebx, eax         ; copy number of bytes read into ebx
  push eax             ; push number of bytes onto stack for later
  mov esi, string      ; set source index to address of string
  mov edi, revstring   ; set destination index to address of revstring

  ; reversing the string
reverse_string:
  cmp ebx, 0           ; is string reversed?
  je reversed          ; if yes, jump to reversed label
  dec ebx              ; decrement characters left to reverse
  mov eax, [esi + ebx] ; copy ebx'th character from string into eax
  mov [edi], eax       ; move char in eax into edi
  inc edi              ; increment edi by 1
  jmp reverse_string   ; jump to beginning of loop

reversed:
  mov eax, 4           ; sys_write syscall
  mov ebx, 1           ; stdout file descriptor
  mov ecx, msg2        ; pointer to string to write
  mov edx, msg2_len    ; number of bytes to write
  int 0x80             ; make syscall
  mov eax, 4           ; sys_write syscall (again)
  mov ebx, 1           ; stdout file descriptor (again)
  mov ecx, revstring   ; pointer to reversed string
  pop edx              ; pop length of string from stack
  int 0x80             ; make syscall
  mov eax, 4           ; sys_write syscall
  mov ebx, 1           ; stdout file descriptor
  push 0x0A            ; push value of new line char onto stack
  mov ecx, esp         ; pointer to top of stack (where the new line char was just pushed)
  mov edx, 1           ; write 1 byte
  int 0x80             ; make syscall
  mov ebx, 0           ; move exit code for success into ebx for sys_exit call later
  jmp end              ; jump to end label

error:
  mov eax, 4           ; sys_write syscall
  mov ebx, 1           ; stdout file descriptor
  mov ecx, err         ; pointer to error message
  mov edx, err_len     ; number of bytes in error message (the length)
  int 0x80             ; make syscall
  mov ebx, 1           ; move exit code for error into ebx for sys_exit call later
  jmp end              ; jump to end label

end:
  mov eax, 1           ; sys_exit syscall
  int 0x80             ; make syscall
