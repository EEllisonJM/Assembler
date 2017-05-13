;Maximo 6 caracteres
;a e i o u s
;0 1 2 3 4 5 6 7 8 9
;F o S
;Contar cuantos numeros hay

include libreria.asm
.286
sPila SEGMENT STACK ; Inicio segmento de Pila
    DB 32 DUP('STACK---')
sPila ENDs ; Fin segmento de Pila
;------------------------------------------------------------------------------
sDatos SEGMENT ; Inicio segmento de Datos
	numeros DB '0 1 2 3 4 5 7 8 9$'
	vocales  DB 'a e i o u$'	
	opciones DB 'f o s$'
	num_en_arreglo DB '0','$'
	
	coordenada_x  db ('?'),'$'
    coordenada_y  db ('?'),'$'
	
	;cad1 DB 6 DUP('$'),'$'		
	cad1 DB 6 DUP('$')
	cad1_end DB '$'		
	salto   DB 0DH, 0AH,'$'	
	
	arrePos Dw '0','$'
	
sDatos ENDs ; Fin segmento de Datos
;------------------------------------------------------------------------------
sCodigo SEGMENT 'CODE' ; Inicio segmento de Codigo
    ASSUME SS:sPila, DS:sDatos, CS:sCodigo
    main PROC FAR ; Definicion del procedimiento FAR
        PUSH DS
        PUSH 0
        MOV AX, sDatos 
        MOV DS, AX ; 		
		;MOV ES,AX;SEGMENTO EXTRA
		
MenuDefault:;[1]
		limpiar_toda_pantalla;MACRO
		
		imprimir_mensaje vocales
		imprimir_mensaje salto
		imprimir_mensaje numeros
		imprimir_mensaje salto
		imprimir_mensaje opciones
		imprimir_mensaje salto
		imprimir_mensaje cad1
		imprimir_mensaje salto

Menu:;[2]
		iniciar_mouse; MACRO
		visualizar_mouse; MACRO	
ciclo: ;[3]
		estado_mouse
		;--> bx Devuelve el estado del boton (Izq o Derecho)
		;--> cx Devueve la coordenada horizontal (x)
		;--> dx Devuelve la coordenada vertical (y)
		CMP BX,1;Boton izquierdo pulsado
			JE accion_izq		
		JMP ciclo;Otro
accion_izq:	
	obtener_caracter_pulsado_con_mouse;MACRO
	;El caracter se guarda en [al]
		CMP AL, '0'
			JE Cero
		CMP AL, '1'
			JE Uno		
		CMP AL, '2'
			JE Dos		
		CMP AL, '3'
			JE Tres
		CMP AL, '4'
			JE Cuatro					
		CMP AL, '5'
			JE Cinco
		CMP AL, '6'
			JE Seis
		CMP AL, '7'
			JE Siete
		CMP AL, '8'
			JE Ocho
		CMP AL, '9'
			JE Nueve	
		CMP AL, 'a' 
			JE es_a
		CMP AL, 'e'
			JE es_e
		CMP AL, 'i'
			JE es_i
		CMP AL , 'o'
			JE es_o
		CMP AL , 'u'
			JE es_u
		CMP AL , 'f'
			JE es_f_finalizar
		CMP AL , 's'
			JE regresar_control_a_OS
		; Cualquier otra opcion
		JMP MenuDefault ; [Salta a etiqueta MenuDefault]

JMP MenuDefault
Cero:
		agregar_caracter_arreglo arrePos,'0', lengthof cad1 ;[agregar_caracter_arreglo posicion, caracter, limite]
		;arrePos = arrePos+1
			JMP MenuDefault
Uno:		
		agregar_caracter_arreglo arrePos,'1', lengthof cad1 ;[agregar_caracter_arreglo posicion, caracter, limite]		
		;arrePos = arrePos+1
			JMP MenuDefault

Dos:		
		agregar_caracter_arreglo arrePos,'2' ,lengthof cad1 ;[agregar_caracter_arreglo posicion, caracter, limite]
		;arrePos = arrePos+1		
			JMP MenuDefault
Tres:		
		agregar_caracter_arreglo arrePos,'3' ,lengthof cad1 ;[agregar_caracter_arreglo posicion, caracter, limite]
		;arrePos = arrePos+1		
			JMP MenuDefault
Cuatro:		
		agregar_caracter_arreglo arrePos,'4' ,lengthof cad1 ;[agregar_caracter_arreglo posicion, caracter, limite]
		;arrePos = arrePos+1		
			JMP MenuDefault
Cinco:		
		agregar_caracter_arreglo arrePos,'5' ,lengthof cad1 ;[agregar_caracter_arreglo posicion, caracter, limite]
		;arrePos = arrePos+1		
			JMP MenuDefault
Seis:		
		agregar_caracter_arreglo arrePos,'6' ,lengthof cad1 ;[agregar_caracter_arreglo posicion, caracter, limite]
		;arrePos = arrePos+1		
			JMP MenuDefault
Siete:		
		agregar_caracter_arreglo arrePos,'7' ,lengthof cad1 ;[agregar_caracter_arreglo posicion, caracter, limite]
		;arrePos = arrePos+1		
			JMP MenuDefault
Ocho:		
		agregar_caracter_arreglo arrePos,'8' ,lengthof cad1 ;[agregar_caracter_arreglo posicion, caracter, limite]
		;arrePos = arrePos+1		
			JMP MenuDefault
Nueve:		
		agregar_caracter_arreglo arrePos,'9' ,lengthof cad1 ;[agregar_caracter_arreglo posicion, caracter, limite]
		;arrePos = arrePos+1		
			JMP MenuDefault
es_a:		
		agregar_caracter_arreglo arrePos,'a' ,lengthof cad1 ;[agregar_caracter_arreglo posicion, caracter, limite]
		;arrePos = arrePos+1		
			JMP MenuDefault
es_e:		
		agregar_caracter_arreglo arrePos,'e' ,lengthof cad1 ;[agregar_caracter_arreglo posicion, caracter, limite]
		;arrePos = arrePos+1		
			JMP MenuDefault
es_i:		
		agregar_caracter_arreglo arrePos,'i' ,lengthof cad1 ;[agregar_caracter_arreglo posicion, caracter, limite]
		;arrePos = arrePos+1		
			JMP MenuDefault
es_o:		
		agregar_caracter_arreglo arrePos,'o' ,lengthof cad1 ;[agregar_caracter_arreglo posicion, caracter, limite]
		;arrePos = arrePos+1		
			JMP MenuDefault
es_u:		
		agregar_caracter_arreglo arrePos,'u' ,lengthof cad1 ;[agregar_caracter_arreglo posicion, caracter, limite]
		;arrePos = arrePos+1		
			JMP MenuDefault
es_f_finalizar:
		posicionar_cursor 7,6
		numeros_en_arreglo cad1,lengthof cad1
		;caracteres_en_arreglo cad1,lengthof cad1
		imprimir_caracter cl
		imprimir_mensaje salto
			;jmp MenuDefault
			;JMP MenuDefault
regresar_control_a_OS:
		RET ; Retorno al procedimiento mas cercano [Al OS:=Sistema Operativo]		
	main ENDp ; Fin procedimiento FAR	
sCodigo ENDs ; Fin segmento de Codigo
END main
