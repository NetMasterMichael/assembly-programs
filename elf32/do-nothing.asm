global _start ; tell linker where to begin execution
_start:
  mov eax, 1  ; syscall code to exit program
  mov ebx, 0  ; successful exit code
  int 0x80    ; make syscall
