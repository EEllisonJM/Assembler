;INGRESAR 5 NUMEROS A UN ARREGLO (DENTRO DE UN CICLO)
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
	opciones  DB 0DH, 0AH,  '1 -> Continuar', 0DH, 0AH, '2 -> Ordenar de forma ascendente',0DH, 0AH, '3 -> Ordenar de forma descendente',0DH, 0AH,'4 -> Salir ',0DH, 0AH,'$'
    msjCadena DB 0DH, 0AH,  'Ingrese dato : $'
    msjMayor  DB 0DH, 0AH,  'El mayor es :  $'
	msjMenor  DB 0DH, 0AH,  'El menor es :  $'
    arreSalto DB 0DH, 0AH
    arre      DB 5 DUP(?),'$'	; Arreglo de 5 posiciones [0,1,2,3,4]	
	coordenada_x  db ('?'),'$'
    coordenada_y  db ('?'),'$'
sDatos ENDs ; Fin segmento de Datos
;------------------------------------------------------------------------------
sCodigo SEGMENT 'CODE' ; Inicio segmento de Codigo
    ASSUME SS:sPila, DS:sDatos, CS:sCodigo
    main PROC FAR ; Definicion del procedimiento FAR
        PUSH DS
        PUSH 0
        MOV AX, sDatos 
        MOV DS, AX ; 

		
		JMP MenuDefault
Ciclo_Continuar_Salir:
		;Clear Screen
		MOV AL,0
		MOV AH,0
		INT 10H
		
		;Print(msj)
		MOV AH, 09H 
			LEA DX, msjCadena
		INT 21H
		
		;WHILE(SI<5)->READ( _ )
		MOV SI,0
leer_ciclo:
		;ReadCharacter(...)
		MOV AH, 01H 		
		INT 21H
		MOV arre[SI],AL
			INC SI
		CMP SI,5
			JB leer_ciclo ; [SI < 5] -> [True:= salta a etiqueta leer_ciclo][false:= Continuar]
		;Continuar ...

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
		MOV BH,00H
		INT 10H
		;Caracer guardado en AL
		
		CMP AL, '1' 
			JE Ciclo_Continuar_Salir ; AL==1? [True:= Salta a etiqueta Ciclo_Continuar_Salir]
		CMP AL, '2'
			JE OrdenAscendente ; AL==2? [True:= Salta a etiqueta OrdenAscendente]
		CMP AL, '3'
			JE OrdenDescendente ; AL==3? [True:= Salta a etiqueta OrdenDescendente]
		CMP AL , '4'
			JE Salirse	; AL==4? [ True:= Salta a etiqueta Salirse]
		; Cualquier otra opcion
		JMP Menu ; [Salta a etiqueta Menu]
;------------------------------------------------		
OrdenAscendente:
		CMP arre[0],'?'
			JE Menu
		MOV BX,0 ; Funcion Pivote
		MOV SI,0 ; Funcion -> Recorredor de arreglo
			JMP Aux

	Siguiente:
		INC BX ; Incremento del Pivote
		CMP BX,4 ; Compara BX (Pivote) con 4
			JA Ordenado	; Cuando Pivote llegue a 5 (Se habra recorrido todo el arreglo)
		MOV SI,BX ; Posicion inicial del Arreglo [Inicio con 0 -> SI:=0]
;----------------------------
	Aux:
		MOV AL,arre[BX] ; MOVer Pivote a AL
	ComparaElementos:
		INC SI ; Incrementar recorredor de Arreglo	[0,1,2,3,4] -> SI:=0,1,2,3,4
		CMP SI,4
			JA Siguiente ; IF SI==5 [True:= Saltar a etiqueta siguiente (Incrementar Pivote)]
		CMP AL,arre[SI]
			JB ComparaElementos
		MOV CH,arre[SI]	; [MOVer elemento de arre[SI] a CH(Auxiliar)]
		MOV arre[BX],CH ; [MOVer CH (Auxiliar) a arre[BX](Pivote)] -> {CH=Nuevo_Pivote} -> {arre[BX]=Nuevo_Pivote}}
		MOV arre[SI],AL ; [MOVer AL(Pivote_antiguo) a arre[SI]]
		MOV AL,CH ; [MOVer CH(Pivote) a AL(Nuevo_Pivote)]
			JMP ComparaElementos ; Salta a etiqueta ComparaElementos para seguir recorriendo el arreglo
Ordenado:
		;PosicionaCursor()
		MOV AH,02H  ;Peticion para designar el cursor
		MOV BH,00 	;Pagina numero 0
		MOV DH,15	;Renglon
		MOV dl,20	;Columna
		INT 10h		;Llama al BIOS		
		;Print(arreSalto)+arre[arreglo]
		MOV AH,09
			LEA DX,arreSalto
		INT 21H
			JMP Menu
;------------------------------------------------
OrdenDescendente:
		CMP arre[0],'?'
			JE Menu
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
		MOV arre[SI],al
		MOV al,ch
			JMP ComparaElementos2
Ordenado2:
		MOV AH,02H  ;Peticion para designar el cursor
		MOV BH,00 	;Pagina numero 0
		MOV dh,15	;Renglon
		MOV dl,20	;Columna
		INT 10h		;Llama al BIOS		
		;Print(arreSalto)+arre[arreglo]
		MOV AH,09H
		LEA DX,arreSalto
		INT 21H
			jmp Menu		
Salirse:
		RET ; Retorno al procedimiento mas cercano [Al OS:=Sistema Operativo]
		
	main ENDp ; Fin procedimiento FAR	
sCodigo ENDs ; Fin segmento de Codigo
END main
