global _start

section .data
  numA db 12     ; number A, edit as you wish
  numB db 12     ; number B, edit as you wish

  ; not recommended to edit below this point
  greater_than db "Number A is greater than number B", 0xA
  gt_len equ $ - greater_than ; compute length of greater_than
  less_than db "Number A is less than number B", 0xA
  lt_len equ $ - less_than    ; compute length of less_than
  equals db "Number A and number B are equal", 0xA
  equ_len equ $ - equals      ; compute length of equals

section .text
_start:
  mov al, [numA]              ; move numA into al
  cmp al, [numB]              ; compare numA to numB
  jg greater                  ; if numB is greater than value in al, jump to greater
  jl less                     ; if numB is less than value in al, jump to less
  je equal                    ; if numB is equal to value in al, jump to equal (default)

greater:
  mov eax, 4                  ; sys_write syscall
  mov ebx, 1                  ; stdout file descriptor
  mov ecx, greater_than       ; pointer to greater_than
  mov edx, gt_len             ; number of bytes to output
  int 0x80                    ; make syscall
  jmp end                     ; jump to terminate program

less:
  mov eax, 4                  ; sys_write syscall
  mov ebx, 1                  ; stdout file descriptor
  mov ecx, less_than          ; pointer to less_than
  mov edx, lt_len             ; number of bytes to output
  int 0x80                    ; make syscall
  jmp end                     ; jump to terminate program

equal:
  mov eax, 4                  ; sys_write syscall
  mov ebx, 1                  ; stdout file descriptor
  mov ecx, equals             ; pointer to equals
  mov edx, equ_len            ; number of bytes to output
  int 0x80                    ; make syscall
  jmp end                     ; jump to terminate program

end:
  mov eax, 1                  ; sys_exit syscall
  mov ebx, 0                  ; exit code 0 for success
  int 0x80                    ; make syscall and terminate program
