' Apple I peripheral emulator, written in Spin2 as an attempt to learn the language
' and nail down basic logic for an attempt at an Apple II project.
' All of this is being written blind, without access to a Prop, so here goes
' nothing!

'*******************************************
'**                                       **
'**                                       **
'**               DEBUGGING               **
'**                                       **
'**                                       **
'*******************************************

CON debugEnable = 0     ' For logging address and data attr each clock cycle

'*******************************************
'**                                       **
'**                                       **
'**              MEMORY MAP               **
'**                                       **
'**                                       **
'*******************************************

' Based off values contained here: https://www.applefritter.com/replica/chapter7
CON ramS = $0000
    ramE = $0FFF   '4K of RAM
    wozMonS = $FF00
    wozMonE = $FFFF
    basicS = $E000
    basicE = $EFFF
    ioS = $D010 'Keyboard and display
    ioE = $D013

'VAR BYTE apple1Rom[256]

'*******************************************
'**                                       **
'**                                       **
'**         6521 PIA EMULATION            **
'**                                       **
'**                                       **
'*******************************************

' WIP

'*******************************************
'**                                       **
'**                                       **
'**         6502 PIN ASSIGNMENTS          **
'**                                       **
'**                                       **
'*******************************************
'	  5v      GND                                  Prop 
'	  |        |       +------\/------+           
'	  |        +----  1| Vss     /RES |40 -------- 25
'	  +-------------  2| RDY       ϕ2 |39  
'	  |               3| ϕ1       /SO |38  
'	  +-------------  4| IRQ       ϕ0 |37 -------- 26
'	  |               5| NC        BE |36 -------- ??
'	  +-------------  6| /NMI      NC |35  
'	  |               7| SYNC     R/W |34 -------- 24
'	  +-------------  8| Vcc       D0 |33 -------- 16
'	     0 ---------  9| A0        D1 |32 -------- 17 
'	     1 --------- 10| A1        D2 |31 -------- 18
'	     2 --------- 11| A2        D3 |30 -------- 19
'	     3 --------- 12| A3        D4 |29 -------- 20
'	     4 --------- 13| A4        D5 |28 -------- 21
'	     5 --------- 14| A5        D6 |27 -------- 22
'	     6 --------- 15| A6        D7 |26 -------- 23
'	     7 --------- 16| A7       A15 |25 -------- 15
'	     8 --------- 17| A8       A14 |24 -------- 14
'	     9 --------- 18| A9       A13 |23 -------- 13
'	    10 --------- 19| A10      A12 |22 -------- 12
'	    11 --------- 20| A11      Vss |21 ---+
'                      +--------------+      |
'	                                        GND


CON pinReset = 25
	pinRW = 24
	clock = 26

VAR WORD addr
	BYTE dataIn
	BYTE dataOut
	BYTE rwState

PUB cpuTick
	PINH(clock)
	rwState := PINR(pinRW)
	addr := PINR(0..15)
	
	IF (rwState = %1)
		IF (wozMonS <= addr && wozMonE >= addr)
			dataOut := apple1Rom[addr - wozMonS]
		ELSEIF (basicS <= addr && basicE >= addr)
			'Handle this later
		ELSEIF (ramS <= addr && ramE >= addr)
			'Handle this later
		ELSEIF (ioS <= addr && ioE >= addr)
			'Handle this later
	ELSE
		'RW STATE SHOULD BE LOW
		IF (ramS <= addr && ramE >= addr)
			ram[addr-ramS] := dataIn
		ELSEIF 
	
	PINL(clock)

DAT

apple1Rom		BYTE $d8, $58, $a0, $7f, $8c, $12, $d0, $a9, $a7, $8d, $11, $d0, $8d, $13, $d0, $c9
				BYTE $df, $f0, $13, $c9, $9b, $f0, $03, $c8, $10, $0f, $a9, $dc, $20, $ef, $ff, $a9
				BYTE $8d, $20, $ef, $ff, $a0, $01, $88, $30, $f6, $ad, $11, $d0, $10, $fb, $ad, $10
				BYTE $d0, $99, $00, $02, $20, $ef, $ff, $c9, $8d, $d0, $d4, $a0, $ff, $a9, $00, $aa
				BYTE $0a, $85, $2b, $c8, $b9, $00, $02, $c9, $8d, $f0, $d4, $c9, $ae, $90, $f4, $f0
				BYTE $f0, $c9, $ba, $f0, $eb, $c9, $d2, $f0, $3b, $86, $28, $86, $29, $84, $2a, $b9
				BYTE $00, $02, $49, $b0, $c9, $0a, $90, $06, $69, $88, $c9, $fa, $90, $11, $0a, $0a
				BYTE $0a, $0a, $a2, $04, $0a, $26, $28, $26, $29, $ca, $d0, $f8, $c8, $d0, $e0, $c4
				BYTE $2a, $f0, $97, $24, $2b, $50, $10, $a5, $28, $81, $26, $e6, $26, $d0, $b5, $e6
				BYTE $27, $4c, $44, $ff, $6c, $24, $00, $30, $2b, $a2, $02, $b5, $27, $95, $25, $95
				BYTE $23, $ca, $d0, $f7, $d0, $14, $a9, $8d, $20, $ef, $ff, $a5, $25, $20, $dc, $ff
				BYTE $a5, $24, $20, $dc, $ff, $a9, $ba, $20, $ef, $ff, $a9, $a0, $20, $ef, $ff, $a1
				BYTE $24, $20, $dc, $ff, $86, $2b, $a5, $24, $c5, $28, $a5, $25, $e5, $29, $b0, $c1
				BYTE $e6, $24, $d0, $02, $e6, $25, $a5, $24, $29, $07, $10, $c8, $48, $4a, $4a, $4a
				BYTE $4a, $20, $e5, $ff, $68, $29, $0f, $09, $b0, $c9, $ba, $90, $02, $69, $06, $2c
				BYTE $12, $d0, $30, $fb, $8d, $12, $d0, $60, $00, $00, $00, $0f, $00, $ff, $00, $00
