;Leer una cadena [hola]
;Pedir un caracter [l]
;Mostrar en pantalla si el caracter se encuentra en la cadena o no
;Si encuentra caracter, mostrar la posicion en la que la encuentra

.286
pila SEGMENT STACK
    DB 32 DUP('STACK---')
pila ENDs

datos SEGMENT    
	cad1 DB 5 DUP(?),'$'	
	msjCadena DB 'Ingrese cadena: $'
	salto   DB 0DH, 0AH
	msjCaracter DB 'Ingrese caracter a buscar: $'
	msjEncontrado DB 0DH, 0AH,'Encontrado : $'
	msjNoEncontrado DB 0DH, 0AH,'No encontrado$'
	posicion DW '0','$'
datos ENDs

codigo SEGMENT 'CODE'
    ASSUME SS:pila, DS:datos, CS:codigo
    main PROC FAR        
        PUSH DS
        PUSH 0
        MOV AX, datos
        MOV DS, AX		
		MOV ES,AX;SEGMENTO EXTRA
	    
		
		;Print (msjCadena)
		MOV AH,09H
			LEA DX,msjCadena
		INT  21H
		
		MOV SI,0
ciclo:
		;ReadCharacter(...)
		MOV AH,01H
		INT 21H
		
		CMP AL,0DH ;(0AH) -> TECLA INTRO
			JE salir
		
		MOV cad1[SI],AL
			INC SI
		CMP SI,5
			JAE salir
		JMP ciclo
		
salir:		
		;Print(salto)+ msjCaracter
		MOV AH , 09H
			LEA DX,salto
		INT 21H
		
		;ReadCharacter(...)
		MOV AH, 01H
		INT 21H
		
	CLD
		MOV DI, OFFSET cad1
		MOV CX,LENGTHOF cad1
		REPNE SCASB
			JE Imprimir_cadena_encontrado
		JMP Imprimir_No_encontrado
	
Imprimir_cadena_encontrado:	
		;Print(msjEncontrado)
		MOV AH , 09h
			LEA DX,msjEncontrado
		INT 21H
		
		MOV BX,LENGTHOF cad1
		SUB BX,CX
		SUB BX,1 ; Arreglo []
		
		ADD BX,30H
		MOV posicion,BX
			LEA DX,posicion
		INT 21H
		
		JMP regresar_control_a_OS
		
Imprimir_No_encontrado:
		;Print(msjNoEncontrado)
		MOV AH , 09h
			LEA DX,msjNoEncontrado
		INT 21H

regresar_control_a_OS:	
		RET
    main ENDp
codigo ENDs
END main	
