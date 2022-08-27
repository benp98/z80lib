; Raw Data to Hexadecimal Utility Functions for Z80
; (c) 2022 Ben-Ove Pasinski - see LICENSE for more information

; Convert the four least significant Bits of register A to a hexadecimal representation
hex_from_nibble:
    AND 00001111b
    CP 0xA
    JP C, hex_from_nibble1  ; Jump if value is less than 10

    ADD 0x61-0xA            ; Add the value of ASCII 'a' minus 10 to the value
    RET
hex_from_nibble1:
    ADD 0x30                ; Add the value of ASCII '0' to the value
    RET

; Convert the value in A to its hexadecimal representation and store it 
hex_from_byte:
    PUSH AF                 ; Save A, we need the four MSB later
    CALL hex_from_nibble    ; Convert lower four bits to hex
    LD L, A                 ; Store in L

    POP AF                  ; Restore A and shift right four times
    SRL A
    SRL A
    SRL A
    SRL A

    CALL hex_from_nibble    ; Convert the upper four bits to hex
    LD H, A                 ; Store in H

    RET
