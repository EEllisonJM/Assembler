;INGRESAR 5 NUMEROS A UN ARREGLO
;MOSTRAR MAYOR
;MOSTRAR MENOR

.286
pila SEGMENT STACK
    DB 32 DUP('STACK---')
pila ENDs
;------------------------------------------------------------------------------
datos SEGMENT
	opciones DB 0dh, 0ah, '1 -> CONTINUAR', 0dh, 0ah, '2 -> SALIR ', 0dh, 0ah,'$'
    msj   	DB 0DH, 0AH, '  Ingrese dato : $'
    msjMayor   DB 0DH, 0AH, '  El mayor es : $'
	msjMenor   DB 0DH, 0AH, '  El menor es : $'
    salto DB 0DH, 0AH, '$'
    arre db 5 dup('?'),'$'	
	
datos ENDs
;------------------------------------------------------------------------------
codigo SEGMENT 'CODE'
    ASSUME SS:pila, DS:datos, CS:codigo
    main PROC FAR
        ;---> Inicio en la pila el segmento de datos <---;
        PUSH DS
        PUSH 0
        MOV AX, datos
        MOV DS, AX
;-------------------------------------------------------------------------
CICLO_CADENA:
	lea dx, msj ; ingrese dato
	mov ah, 09h
	int 21h	
	mov si,0
leer_ciclo:
	mov ah, 01h
	int 21h
	
	mov arre[si],al
	inc si

	cmp si,5 
	jb leer_ciclo	; llenado del arreglo
	
;------------------------------------------------------------------------------	
	lea dx,msjMayor
	mov ah, 09h
	int 21h
;------------------------------------------------------------------------------
	mov si,0
	mov al,arre[si]	
ciclo_while_mayor:
aqui:	
	cmp si,3	
	ja saltito ;si>4
	inc si		
	cmp al,arre[si] ; cmp arre[si+1],al
	ja aqui	; al > arre[si]
	mov al,arre[si]
	jmp aqui
;------------------------------------------------------------------------------
	
saltito :
	mov dl, al
	mov ah,02h
	int 21h	
;- - - - - - -	-	-	-	-	;- - - - - - -	-	-	-	-	;- - - - - - -	-	-	-	-	
	mov ah, 09h
	lea dx,msjMenor
	int 21h
	
	mov si,00
	mov bl,arre[si]	
	
	
ciclo_while_menor:
aqui2:	
	cmp si,3
	ja salir ;si>4
	inc si	
	cmp bl,arre[si] ; cmp arre[si+1],al
	jb aqui2	; al < arre[si] ; 5211
	mov dl, arre[si]	
	;mov ah,02h
	
	mov bl,arre[si]
	jmp aqui2	
salir:

	mov ah,02h
	int 21h	
	
MENU:
	lea dx,opciones
	mov ah,09h
	int 21h
	
	mov ah, 01h
	int 21h
	sub al, 30h ; A decimal
	
	cmp al, 1
		je CICLO_CADENA
	cmp al , 2
		je SALIRse		
	jmp MENU
		
SALIRse:

RET
    main ENDp
codigo ENDs
END main

s
