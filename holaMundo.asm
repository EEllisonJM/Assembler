;PROGRAMA QUE
;Imprime 'HOLA MUNDO' en pantalla

.286
sPila SEGMENT STACK
    DB 32 DUP('STACK---')
sPila ENDs

sDatos SEGMENT	
    msj   DB 0DH, 0AH, 'HOLA MUNDO $'
sDatos ENDs

sCodigo SEGMENT 'CODE'
    ASSUME SS:sPila, DS:sDatos, CS:sCodigo		
    main PROC FAR	
        PUSH DS
        PUSH 0
        MOV AX, sDatos
        MOV DS, AX
		
		LEA DX, msj
		MOV AH, 09h
		INT 21h	
	
		RET
    main ENDp
sCodigo ENDs
END main
