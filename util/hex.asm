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

; Convert the hexadecimal Value in A into its binary value
hex_to_nibble:
    CP 0x41                 ; Compare value against 'A'
    JP C, hex_to_nibble1    ; Jump if the value is less than 'A'

    CP 0x61                 ; Compare value against 'a'
    JP C, hex_to_nibble2    ; Jump if the value is less than 'a'

    SUB 0x61-0xA            ; Subtract the value of 'a' minus ten from the data
    AND 00001111b           ; Strip the upper four MSB
    RET
hex_to_nibble1:
    SUB 0x30                ; Subtract the value of '0' from the data
    AND 00001111b           ; Strip the upper four MSB
    RET
hex_to_nibble2:
    SUB 0x41-0xA            ; Subtract the value of 'A' minus ten from the data
    AND 00001111b           ; Strip the upper four MSB
    RET
