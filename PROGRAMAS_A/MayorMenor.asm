;INGRESAR 5 NUMEROS A UN ARREGLO
;MOSTRAR MAYOR
;MOSTRAR MENOR

.286
sPila SEGMENT STACK
    DB 32 DUP('STACK---')
sPila ENDs
;------------------------------------------------------------------------------
sDatos SEGMENT
	opciones DB 0DH, 0AH,  '1 -> Continuar', 0DH, 0AH, '2 -> Salir ',0DH, 0AH,'$'
    msj   	 DB 0DH, 0AH,  'Ingrese dato : $'
    msjMayor DB 0DH, 0AH,  'El mayor es :  $'
	msjMenor DB 0DH, 0AH,  'El menor es :  $'
    salto 	 DB 0DH, 0AH,  '$'
    arre 	 DB 5 DUP('?'),'$'	; Arreglo de 5 posiciones [0,1,2,3,4]
	
sDatos ENDs
;------------------------------------------------------------------------------
sCodigo SEGMENT 'CODE'
    ASSUME SS:sPila, DS:sDatos, CS:sCodigo
    main PROC FAR ; Definicion del procedimiento FAR
        PUSH DS
        PUSH 0
        MOV AX, sDatos 
        MOV DS, AX ; 

Ciclo_Continuar_Salir:
;----------------PRINT(Ingrese dato : )------------------------------------------------------
		LEA DX, msj ; Cadena a visualizar [msg = Ingrese dato: ]
		MOV AH, 09H ; Funcion 09H -> Visualización de una cadena de caracteres
		INT 21H	; Interrupcion del DOS
		
;----------------WRITE( _ )------------------------------------------------------
		MOV SI,0 ; Posicion inicial del arreglo		
leer_ciclo:
		MOV AH, 01H ; Función 01H -> Entrada de Carácter
		INT 21H ; Interrupcion del DOS		
		MOV arre[SI],AL ; Guardar caracter leido en arreglo [0,1,2,3,4]
		INC SI ; ; Incremento de SI [SI:= SI+1]
		CMP SI,5 ; Comparar SI con 5
			JB leer_ciclo ; [SI < 5] -> [True:= salta a etiqueta leer_ciclo][false:= Continuar]
			
;----------------PRINT(El mayor es : _ )------------------------------------------------------
		MOV AH, 09H ; Funcion 09H -> Visualización de una cadena de caracteres
		LEA DX,msjMayor ; Cadena a visualizar [msgMayor:= El mayor es :  ]		
		INT 21H ; Interrupcion del DOS				
		
		MOV SI,0 ; Posicion inicial del arreglo		
		MOV AL,arre[SI]	; Mover elemento del arreglo en posicion 0 a AL [ arre[0]:= X ]
ciclo_while_mayor:
	mayor:	
		CMP SI,3	
			JA mayor_encontrado ; SI > 4 
		INC SI		
		CMP AL,arre[SI] ; Compara arre[SI+1] con AL
			JA mayor	; al > arre[si+1] [True:= Salta a mayor]
		MOV AL,arre[SI] ; [False := El mayor es arre[SI+1]
			JMP mayor
mayor_encontrado :
		MOV DL, AL ; Código ASCII a enviar al dispositivo de salida [DL] - [AL Contiene el mayor]
		MOV AH,02H ; Función 02H -> Salida de Carácter 
		INT 21H ; Interrupcion del DOS					
	
;----------------PRINT(El menor es : _ )------------------------------------------------------
		MOV AH, 09H ; Funcion 09H -> Visualización de una cadena de caracteres
		LEA DX,msjMenor ; Cadena a visualizar [msjMenor:= El menor es :  ]		
		INT 21H ; Interrupcion del DOS				
		
		MOV SI,0 ; Posicion inicial del arreglo		
		MOV AL,arre[SI]	; Mover elemento del arreglo en posicion 0 a AL [ arre[0]:= X ]
ciclo_while_menor:
	menor:	
		CMP SI,3	
			JA menor_encontrado ; SI > 4 
		INC SI		
		CMP AL,arre[SI] ; Compara arre[SI+1] con AL
			JB menor	; al > arre[si+1] [True:= Salta a mayor]
		MOV AL,arre[SI] ; [False := El mayor es arre[SI+1]
			JMP menor
menor_encontrado :
		MOV DL, AL ; Código ASCII a enviar al dispositivo de salida [DL] - [AL Contiene el mayor]
		MOV AH,02H ; Función 02H -> Salida de Carácter 
		INT 21H ; Interrupcion del DOS
Menu:
		LEA DX,opciones
		MOV AH,09h
		INT 21H
	
		MOV AH, 01H
		INT 21H
		SUB AL, 30H ; Obtener numero en decimal [ASCII]
	
		CMP AL, 1 
			je Ciclo_Continuar_Salir ; AL==1?
		CMP AL , 2
			JE Salirse	; AL==2?
		; Cualquier otra opcion
			JMP Menu
		
Salirse:
		RET ; Retorno al procedimiento mas cercano [Al OS:=Sistema Operativo]
	main ENDp ; Final del procedimiento FAR
sCodigo ENDs
END main

