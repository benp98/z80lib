; 16C550 UART interfacing code for Z80
; (c) 2022 Ben-Ove Pasinski - see LICENSE for more information

; The following values must be defined:
; UART_DIVISOR_MSB and UART_DIVISOR_LSB
;   MSB and LSB of the Clock Divisor, see the 16C550 Documentation for more information
; UART_BASE
;   Base Address of the UART

UART_IOR: equ UART_BASE     ; IO Register (RBR/THR)
UART_IER: equ UART_BASE + 1 ; Interrupt Enable Register
UART_FCR: equ UART_BASE + 2 ; FIFO Control Register (Write Only)
UART_LCR: equ UART_BASE + 3 ; Line Control Register
UART_LSR: equ UART_BASE + 5 ; Line Status Register

UART_DLL: equ UART_BASE     ; Divisor Latch LSB
UART_DLM: equ UART_BASE + 1 ; Divisor Latch MSB

UART_LSR_DR:   equ 0        ; Data Ready
UART_LSR_THRE: equ 5        ; Transmitter Holding Register Empty

; Initialise the UART
uart_init:
    LD A, 10000000b         ; DLAB = 1
    OUT (UART_LCR), A

    LD A, UART_DIVISOR_LSB  ; Baud Rate LSB
    OUT (UART_DLL), A
    LD A, UART_DIVISOR_MSB  ; Baud Rate MSB
    OUT (UART_DLM), A

    LD A, 00000011b         ; Set 8-Bit words, 1 stop bit, DLAB = 0
    OUT (UART_LCR), A

    LD A, 00000111b         ; Enable FIFO + Reset both FIFOs
    OUT (UART_FCR), A

    LD A, 00000000b         ; Disable all Interrupts
    OUT (UART_IER), A

    RET

; Wait until the UART FIFO is empty, then write a single Byte
uart_write:
    PUSH AF                 ; Save Output
uart_write1:
    IN A, (UART_LSR)        ; Read Line Status Register
    BIT UART_LSR_THRE, A    ; Check if Transmitter Holding Register is empty
    JP Z, uart_write1       ; Check again until data can be written

    POP AF                  ; Restore Output

    OUT (UART_IOR), A       ; Write Data
    RET

; Wait until there is data in the UART FIFO, then return a single Byte
uart_read:
    IN A, (UART_LSR)        ; Read Status Register
    BIT UART_LSR_DR, A      ; Check Data Ready Flag
    JP Z, uart_read         ; If not set, check again until it is set

    IN A, (UART_IOR)        ; Read Data
    RET
