;PROGRAMA QUE
;Imprime 'HOLA MUNDO' en pantalla

.286
pila SEGMENT STACK
    DB 32 DUP('STACK---')
pila ENDs

datos SEGMENT	
    msj   DB 0DH, 0AH, 'HOLA MUNDO $'
datos ENDs

codigo SEGMENT 'CODE'
    ASSUME SS:pila, DS:datos, CS:codigo
    main PROC FAR
	
        PUSH DS
        PUSH 0
        MOV AX, datos
        MOV DS, AX
		
		lea dx, msj
		mov ah, 09h
		int 21h	
	
		RET
    main ENDp
codigo ENDs
END main
