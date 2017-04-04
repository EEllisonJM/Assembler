;LEER CADENA DE 5
;MOSTRAR LAS VOCALES: a i o u 
;SELECCIONAR CON EL MOUSE UN CARACTER
;Y MOSTRAR SI SE ENCUENTRA DENTRO DE LA CADENA INGRESADA
;MOSTRAR LA POSICION EN LA QUE SE ENCUENTRA

.286
sPila SEGMENT STACK ; Inicio segmento de Pila
    DB 32 DUP('STACK---')
sPila ENDs ; Fin segmento de Pila
;------------------------------------------------------------------------------
sDatos SEGMENT ; Inicio segmento de Datos
	opciones  DB 'a e i o u    s$'	
	coordenada_x  db ('?'),'$'
    coordenada_y  db ('?'),'$'
	
	cad1 DB 5 DUP(?),'$'	
	msjCadena DB 'Ingrese cadena: $'
	salto   DB 0DH, 0AH,'$'	
	msjEncontrado DB 0DH, 0AH,'Encontrado : $'
	msjNoEncontrado DB 0DH, 0AH,'No encontrado      $'
	posicion DW '0','$'
	
sDatos ENDs ; Fin segmento de Datos
;------------------------------------------------------------------------------
sCodigo SEGMENT 'CODE' ; Inicio segmento de Codigo
    ASSUME SS:sPila, DS:sDatos, CS:sCodigo
    main PROC FAR ; Definicion del procedimiento FAR
        PUSH DS
        PUSH 0
        MOV AX, sDatos 
        MOV DS, AX ; 
		
		MOV ES,AX;SEGMENTO EXTRA
	    
		;Print (msjCadena)
		MOV AH,09H
			LEA DX,msjCadena
		INT  21H
		
		MOV SI,0
ciclo_c:
		;ReadCharacter(...)
		MOV AH,01H
		INT 21H
		
		CMP AL,0DH ;(0AH) -> TECLA INTRO
			JE salir_cadena_ingresada
		
		MOV cad1[SI],AL
			INC SI
		CMP SI,5
			JAE salir_cadena_ingresada
		JMP ciclo_c
		
salir_cadena_ingresada:
		;Print(/n)
		mov ah,09h
			lea dx,salto
		int 21h
		
		JMP MenuDefault


MenuDefault:;[1]
		;Print(opciones) ->Menu
		MOV AH,09h
			LEA DX,opciones		
		INT 21H
Menu:;[2]
		;iniciar_mouse
		MOV AX,00
		INT 33H
ciclo: ;[3]
		;visualizar_mouse
		MOV AX,01H
		INT 33H

		;estado_mouse(Estado de los botones presionados ->Izquierdo,derecho,centro(ScrollBar)))
		MOV AX,03H ; Handler o funcion
		INT 33H
		;--> bx Devuelve el estado del boton (Izq o Derecho)
		;--> cx Devueve la coordenada horizontal (x)
		;--> dx Devuelve la coordenada vertical (y)
		CMP BX,1
			JE accion_izq		
		JMP ciclo
accion_izq:
		MOV AX,CX ; Coordenada horizontal
		MOV BL,8
			DIV BL
		MOV coordenada_x,AL
		MOV AX,DX ; Coordenada vertical
		MOV CL,8
			DIV CL
		MOV coordenada_y,AL

		;posiciona_cursor
		MOV DH,coordenada_y    	;Renglon
		MOV DL,coordenada_x      ;Columna   
		
		MOV AH,02H  ;Handler->Peticion para designar el cursor
		MOV BH,00 	;Pagina numero 0		
		INT 10H		;Llama al BIOS
		
		;devuelve caracer
		MOV AH,08H
		MOV BH,00H ;PAGINA 0
		INT 10H
		;Caracer guardado en AL
		
		CMP AL, 'a' 
			JE SuperSalto 
		CMP AL, 'e'
			JE SuperSalto 
		CMP AL, 'i'
			JE SuperSalto 
		CMP AL , 'o'
			JE SuperSalto
		CMP AL , 'u'
			JE SuperSalto
		CMP AL , 's'
			JE regresar_control_a_OS
		; Cualquier otra opcion
		JMP Menu ; [Salta a etiqueta Menu]

SuperSalto:		
		;Print(salto)+ msjCaracter
		MOV AH , 09H
			LEA DX,salto
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
		
		JMP ciclo
		
		
Imprimir_No_encontrado:
		;Print(msjNoEncontrado)
		MOV AH , 09h
			LEA DX,msjNoEncontrado
		INT 21H
jmp ciclo
				

regresar_control_a_OS:
		RET ; Retorno al procedimiento mas cercano [Al OS:=Sistema Operativo]
		
	main ENDp ; Fin procedimiento FAR	
sCodigo ENDs ; Fin segmento de Codigo
END main
