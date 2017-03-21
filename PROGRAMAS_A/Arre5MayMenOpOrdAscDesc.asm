;INGRESAR 5 NUMEROS A UN ARREGLO (DENTRO DE UN CICLO)
;MOSTRAR MAYOR
;MOSTRAR MENOR
;ORDENAR DE FORMA ASCENDENTE
;ORDENAR DE FORMA DESCENDENTA
;MOSTRAR OPCIONES:
;1 -> Continuar
;2 -> Ordenar de forma ascendente
;3 -> Ordenar de forma descendente
;4 -> Salir

.286
sPila SEGMENT STACK ; Inicio segmento de Pila
    DB 32 DUP('STACK---')
sPila ENDs ; Fin segmento de Pila
;------------------------------------------------------------------------------
sDatos SEGMENT ; Inicio segmento de Datos
	opciones DB 0DH, 0AH,  '1 -> Continuar', 0DH, 0AH, '2 -> Ordenar de forma ascendente',0DH, 0AH, '3 -> Ordenar de forma descendente',0DH, 0AH,'4 -> Salir ',0DH, 0AH,'$'
    msj   	 DB 0DH, 0AH,  'Ingrese dato : $'
    msjMayor DB 0DH, 0AH,  'El mayor es :  $'
	msjMenor DB 0DH, 0AH,  'El menor es :  $'
    arreSalto DB 0DH, 0AH
    arre 	 DB 5 DUP('?'),'$'	; Arreglo de 5 posiciones [0,1,2,3,4]	
sDatos ENDs ; Fin segmento de Datos
;------------------------------------------------------------------------------
sCodigo SEGMENT 'CODE' ; Inicio segmento de Codigo
    ASSUME SS:sPila, DS:sDatos, CS:sCodigo
    main PROC FAR ; Definicion del procedimiento FAR
        PUSH DS
        PUSH 0
        MOV AX, sDatos 
        MOV DS, AX ; 

Ciclo_Continuar_Salir:
;----------------PRINT(Ingrese dato : )------------------------------------------------------
		MOV AH, 09H ; Funcion 09H -> Visualización de una cadena de caracteres
		LEA DX, msj ; Cadena a visualizar [msg = Ingrese dato: ]		
		INT 21H	; Interrupcion del DOS
		
;---------------WHILE(SI<5)->READ( _ )------------------------------------------------------
		MOV SI,0 ; Posicion inicial del arreglo	a llenar
leer_ciclo:
		MOV AH, 01H ; Función 01H -> Entrada de Carácter
		INT 21H ; Interrupcion del DOS		
		MOV arre[SI],AL ; Guardar caracter leido en arreglo [0,1,2,3,4]
		INC SI ; ; Incremento de SI [SI:= SI+1]
		CMP SI,5 ; Comparar SI con 5
			JB leer_ciclo ; [SI < 5] -> [True:= salta a etiqueta leer_ciclo][false:= Continuar]
		;Continuar ...
		
;----------------PRINT(El mayor es : _ )------------------------------------------------------
		MOV AH, 09H ; Funcion 09H -> Visualización de una cadena de caracteres
		LEA DX,msjMayor ; Cadena a visualizar [msgMayor:= El mayor es :  ]		
		INT 21H ; Interrupcion del DOS				
		
		MOV SI,0 ; Posicion inicial del arreglo	
		MOV AL,arre[SI]	; Mover elemento del arreglo en posicion 0 a AL [AL := arre[0] ]
ciclo_while_mayor:
	mayor:		
		CMP SI,4
			JE mayor_encontrado ; IF SI==4 , [SI:=4 Se ha encontrado el mayor tras recorrer todo el arreglo]
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
			JA menor_encontrado ; IF SI>3 , [SI:=4 Se ha encontrado el mayor tras recorrer todo el arreglo]
		INC SI		
		CMP AL,arre[SI] ; Compara arre[SI+1] con AL
			JB menor	; al < arre[si+1] [True:= Salta a mayor]
		MOV AL,arre[SI] ; [False := El mayor es arre[SI+1]
			JMP menor
menor_encontrado :
		MOV DL, AL ; Código ASCII a enviar al dispositivo de salida [DL] - [AL Contiene el mayor]
		MOV AH,02H ; Función 02H -> Salida de Carácter 
		INT 21H ; Interrupcion del DOS
Menu:
;----------------PRINT(1 -> Continuar)---------------------------------------------------
;----------------PRINT(2 -> Ordenar de forma ascendente)---------------------------------
;----------------PRINT(3 -> Ordenar de forma descendente)--------------------------------
;----------------PRINT(4 -> Salir )------------------------------------------------------
		LEA DX,opciones
		MOV AH,09h
		INT 21H
;----------------READ( _ )---OPCIONES---------------------------------------------------	
		MOV AH, 01H
		INT 21H
		SUB AL, 30H ; Convertir caracter a numero en decimal [ASCII]
		
		CMP AL, 1 
			JE Ciclo_Continuar_Salir ; AL==1? [True:= Salta a etiqueta Ciclo_Continuar_Salir]
		CMP AL, 2
			JE OrdenAscendente ; AL==2? [True:= Salta a etiqueta OrdenAscendente]
		CMP AL, 3
			JE OrdenDescendente ; AL==3? [True:= Salta a etiqueta OrdenDescendente]
		CMP AL , 4
			JE Salirse	; AL==4? [ True:= Salta a etiqueta Salirse]
		; Cualquier otra opcion
			JMP Menu ; [Salta a etiqueta Menu]
;------------------------------------------------		
OrdenAscendente:
		MOV BX,0 ; Funcion Pivote
		MOV SI,0 ; Funcion -> Recorredor de arreglo
			JMP Aux
;----------------------------
	Siguiente:
		INC BX ; Incremento del Pivote
		CMP BX,4 ; Compara BX (Pivote) con 4
			JA Ordenado	; Cuando Pivote llegue a 5 (Se habra recorrido todo el arreglo)
		MOV SI,BX ; Posicion inicial del Arreglo [Inicio con 0 -> SI:=0]
;----------------------------
	Aux:
		MOV AL,arre[BX] ; Mover Pivote a AL
	ComparaElementos:
		INC SI ; Incrementar recorredor de Arreglo	[0,1,2,3,4] -> SI:=0,1,2,3,4
		CMP SI,4
			JA Siguiente ; IF SI==5 [True:= Saltar a etiqueta siguiente (Incrementar Pivote)]
		CMP AL,arre[SI]
			JB ComparaElementos
		MOV CH,arre[SI]	; [Mover elemento de arre[SI] a CH(Auxiliar)]
		MOV arre[BX],CH ; [Mover CH (Auxiliar) a arre[BX](Pivote)] -> {CH=Nuevo_Pivote} -> {arre[BX]=Nuevo_Pivote}}
		Mov arre[SI],AL ; [Mover AL(Pivote_antiguo) a arre[SI]]
		mov AL,CH ; [Mover CH(Pivote) a AL(Nuevo_Pivote)]
			JMP ComparaElementos ; Salta a etiqueta ComparaElementos para seguir recorriendo el arreglo
Ordenado:
		MOV AH,09
		LEA DX,arreSalto
		INT 21H		
			JMP Menu
;------------------------------------------------
OrdenDescendente:
		MOV BX,0		
		MOV SI,0 		
		JMP Aux2
;----------------------------
	Siguiente2:
		INC BX
		CMP BX,4
			Ja Ordenado2			
		MOV SI,BX		
;----------------------------
	Aux2:
		MOV AL,arre[BX]
	ComparaElementos2:
		INC SI		
		CMP SI,4
			JA Siguiente2		
		CMP AL,arre[SI]
			JA ComparaElementos2 ; IF AL>arre[SI] [True:= salta a etiqueta ComparaElementos2] ->Inverso de orden ASCENDENTE
		MOV CH,arre[SI]			
		MOV arre[BX],CH
		Mov arre[SI],al
		mov al,ch
			JMP ComparaElementos2
Ordenado2:
		MOV ah,09
		lea dx,arreSalto ; ARREGLO con salto incluido
		int 21h		
			jmp Menu		
Salirse:
		RET ; Retorno al procedimiento mas cercano [Al OS:=Sistema Operativo]
		
	main ENDp ; Fin procedimiento FAR	
sCodigo ENDs ; Fin segmento de Codigo
END main
