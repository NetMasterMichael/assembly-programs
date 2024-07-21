;
;  File:    hang.asm
;  Author:  Michael Goodwin (NetMasterMichael)
;  Date:    2024-07-06
;

global _start

_start:
  nop        ; no operation, could remove this but I want to acknowledge that it exists
  jmp _start ; return to start, infinite loop
