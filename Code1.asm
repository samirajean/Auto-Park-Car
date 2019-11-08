ORG 00H

MOV DPTR, #LUT
MOV P1,#00000000B

CLR P3.0
CLR P3.2
CLR P3.4
;----------------------------------------------------------------------------
SETB P3.1 ; LEFT SENSOR
MOV TMOD,#00100000B
MAINL:
      MOV TL1,#207D
      MOV TH1,#207D
      MOV A,#00000000B
      SETB P3.0
      ACALL DELAY
      CLR P3.0
HERE: JNB P3.1, HERE
BACK: SETB TR1
HERE1: JNB TF1, HERE1
CLR TR1
CLR TF1
INC A
CJNE A, #19H, RIGHT
SETB P1.2; enable left wheel
CLR P1.0 ; stop right wheel
SJMP CHECK


;------------------------------------------------------------------------

RIGHT: SETB P3.1 ; RIGHT SENSOR
MOV TMOD,#00100000B
MAINR:MOV TL1,#207D
      MOV TH1,#207D
      MOV A,#00000000B
      SETB P3.0
      ACALL DELAY
      CLR P3.0
HERER: JNB P3.1, HERER
BACKR: SETB TR1
HERE1R: JNB TF1, HERE1R
CLR TR1
CLR TF1
INC A
CJNE A, #19H, CONT
SETB P1.0 ;enable right wheel
CLR P1.2  ; stop left wheel
SJMP CHECK

;-----------------------------------------------------------------------

;TO STOP THE CAR BEFORE IT HITS THE OBJECT
CHECK: SETB P3.5 ; Front
MOV TMOD,#00100000B
MOV TL1,#207D
      MOV TH1,#207D
      MOV A,#00000000B
      SETB P3.4
      ACALL DELAY
      CLR P3.4
HEREF: JNB P3.5, HEREF
BACKF: SETB TR1
HERE1F: JNB TF1, HERE1F
CLR TR1
CLR TF1
INC A
CJNE A, #5H, CONT
CLR P1.0
CLR P1.2

;-------------------------------------------------------------------

SJMP COMP
CONT:	SETB P1.0
	SETB P1.2
	
	JC LOC1
	SETB P1.0
	SETB P1.2
	SJMP COMP
LOC1:	CLR P1.0
     	CLR P1.2
	SJMP COMP

COMP:	JB P3.1, BACK
	MOV R4,A 
	JMP MAINL
	
	JB P3.5, BACKF
	MOV R4, A
	SJMP CHECK
	
	JB P3.3, BACKR
	MOV R4, A
	SJMP MAINR
;----------------------------------------------------------------------

DELAY: MOV R6,#2D
LABEL1:	DJNZ R6, LABEL1
	RET


;----------------------------------------------------------------------
LUT: DB 3FH
     DB 06H
     DB 5BH
     DB 4FH
     DB 66H
     DB 6DH
     DB 7DH
     DB 07H
     DB 7FH
     DB 6FH


      END