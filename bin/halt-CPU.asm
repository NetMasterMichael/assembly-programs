BITS 16
org 0x7c00

start:
  hlt
  jmp start

times 510 - ($-$$) db 0
dw 0xAA55
