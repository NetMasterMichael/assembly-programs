;
;  File:    halt-CPU.asm
;  Author:  Michael Goodwin (NetMasterMichael)
;  Date:    2024-07-27
;

[BITS 16]    ; Directive to assembler that we are operating in 16-bit real mode
org 0x7c00   ; Offset to start program at memory address 0x7C00

start:
  hlt        ; Halt CPU momentarily
  jmp start  ; Jump to the label start

times 510 - ($-$$) db 0  ; Pad the remainder of the binary with zeros
dw 0xAA55                ; Magic byte that indicates this boot sector is bootable
