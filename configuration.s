
; PIC18F87J50 Configuration Bit Settings

; Assembly source line config statements

#include <xc.inc>

; CONFIG1L
  CONFIG  WDTEN = OFF           ; Watchdog Timer Enable bit (WDT disabled (control is placed on SWDTEN bit))
  CONFIG  PLLDIV = 1            ; PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
  CONFIG  STVREN = ON           ; Stack Overflow/Underflow Reset Enable bit (Reset on stack overflow/underflow enabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG1H
  CONFIG  CPUDIV = OSC1         ; CPU System Clock Postscaler (No CPU system clock divide)
  CONFIG  CP0 = OFF             ; Code Protection bit (Program memory is not code-protected)

; CONFIG2L
  CONFIG  FOSC = HS             ; Oscillator Selection bits (HS oscillator, HS used by USB)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Two-Speed Start-up (Internal/External Oscillator Switchover) Control bit (Two-Speed Start-up disabled)

; CONFIG2H
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscaler Select bits (1:32768)

; CONFIG3L
  CONFIG  EASHFT = ON           ; External Address Bus Shift Enable bit (Address shifting enabled, address on external bus is offset to start at 000000h)
  CONFIG  MODE = MM             ; External Memory Bus Configuration bits (Microcontroller mode - External bus disabled)
  CONFIG  BW = 16               ; Data Bus Width Select bit (16-bit external bus mode)
  CONFIG  WAIT = OFF            ; External Bus Wait Enable bit (Wait states on the external bus are disabled)

; CONFIG3H
  CONFIG  CCP2MX = DEFAULT      ; ECCP2 MUX bit (ECCP2/P2A is multiplexed with RC1)
  CONFIG  ECCPMX = DEFAULT      ; ECCPx MUX bit (ECCP1 outputs (P1B/P1C) are multiplexed with RE6 and RE5; ECCP3 outputs (P3B/P3C) are multiplexed with RE4 and RE3)
  CONFIG  PMPMX = DEFAULT       ; PMP Pin Multiplex bit (PMP pins placed on EMB)
  CONFIG  MSSPMSK = MSK7        ; MSSP Address Masking Mode Select bit (7-Bit Address Masking mode enable)


