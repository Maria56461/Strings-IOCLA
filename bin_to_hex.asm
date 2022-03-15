%include "io.mac"

section .data
    length dd 0									; copie a lungimii numarului in binar 
		var dd 0 										; numarul ce trebuie adaugat in stringul final
		count_bin dd 0							; parcurge numarul in binar 
		count_groups dd 0 					; numara bitii dintr-un grup de 4 biti
		restul dd 0									; restul e aici

section .text
    global bin_to_hex
    extern printf

bin_to_hex:
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; hexa_value
    mov     esi, [ebp + 12]     ; bin_sequence
    mov     ecx, [ebp + 16]     ; length
		mov [length], ecx 					; copie a lungimii 
  	xor ecx, ecx 								; pot folosi ecx, eax, ebx 
		xor ebx, ebx
		xor eax, eax 
		mov ecx, [var]
		mov [edx], ecx
		
		mov al, [length]
		mov bl, 4 
		div bl  										; restul in ah 
		; trebuie sa adaug primul caracter
	  ; generat de bitii care ramasesera rest

		mov bl, ah
		cmp bl, 1
		je rest1
		mov bl, ah
		cmp bl, 2
		je rest2
		mov bl, ah
		cmp bl, 3
		je rest3
		jmp next

rest1: 
		mov bl, byte[esi]
		inc esi
		cmp bl, 0x31
		je adaug1
		jmp next

rest2:
	jmp next

rest3:
	mov bl, byte[esi]
	cmp bl, 0x31
	je adaug2
	jmp next1

adaug2:
	mov ebx, 4
	mov [var], ebx 
	jmp next1

next1:
	inc esi
	mov bl, byte[esi]
	cmp bl, 0x31
	je adaug3
	jmp next2

adaug3:
	mov ebx, [var]
	add ebx, 2
	mov [var], ebx 
	jmp next2

next2:
	inc esi 
	mov bl, byte[esi]
	cmp bl, 0x31
	je adaug4
	jmp next3

adaug4:
	mov ebx, [var]
	add ebx, 1
	mov [var], ebx 
	jmp next3

next3:
	mov ebx, [var]
	add ebx, 0x30
	mov [var], ebx
	mov ebx, [var]
	mov [edx], ebx 
	inc edx
	inc esi
	jmp next

adaug1:
		mov ebx, 0x31
		mov [edx], ebx
		inc edx 
		jmp next
		
next:
		mov ebx, 0
		mov [var], ebx 
		jmp parcurgere_sir_de_biti

parcurgere_sir_de_biti:
	mov bl, byte[esi]							; parcurg caracter cu caracter sirul de biti 	 
	mov ecx, [length]
	mov [restul], ah 
	sub ecx, [restul]
	cmp ecx, [count_bin]	
	jg prelucrare 

	mov ecx, 0xa
	mov [edx], ecx
	mov edx, [ebp + 8]  					; aduc edx la pozitia initiala 
	mov ecx, 0
	mov [count_bin], ecx 					; fac numaratorul sa fie din nou nul 
	mov [count_groups], ecx 
	mov ecx, 0
	mov [var], ecx 
	
    popa
    leave
    ret

prelucrare:
	xor ecx, ecx
	mov cl, bl
	cmp cl, 0x31									; daca caracterul este 1 
	je adunare
	jmp continuare 

adunare: 
	mov ecx, [count_groups]
	cmp ecx, 0
	je adunare0
	mov ecx, [count_groups]
	cmp ecx, 1
	je adunare1
	mov ecx, [count_groups]
	cmp ecx, 2
	je adunare2
	mov ecx, [count_groups]
	cmp ecx, 3
	je adunare3

adunare0:
	mov ecx, [var]
	add ecx, 8
	mov [var], ecx 
	jmp continuare   
  
adunare1:
	mov ecx, [var]
	add ecx, 4
	mov [var], ecx 
	jmp continuare   

adunare2:
	mov ecx, [var]
	add ecx, 2
	mov [var], ecx 
	jmp continuare 

adunare3:
	mov ecx, [var]
	add ecx, 1
	mov [var], ecx 
	jmp continuare  	

continuare: 
	mov ecx, [count_groups]		
	inc ecx
	mov [count_groups], ecx					; incrementez count_groups 
	mov ecx, [count_groups]
	cmp ecx, 4
	je reglementare_contor
	jmp final

reglementare_contor:
	mov ecx, 0 
	mov [count_groups], ecx					; fac contorul sa fie din nou zero 
	mov ecx, [var]
	cmp ecx, 10
	jl inserare1
	jge inserare2 

inserare1:
	mov ecx, [var]
	add ecx, 0x30
	mov [var], ecx 
	mov ecx, [var] 
	mov [edx], ecx									; introduc caracterul in sirul final
	inc edx 
	mov ecx, 0											; fac variabila sa fie zero din nou 
	mov [var], ecx 
	jmp final

inserare2:
	mov ecx, [var]
	add ecx, 0x37
	mov [var], ecx 
	mov ecx, [var]
	mov [edx], ecx									; introduc caracterul in sirul final
	inc edx 
	mov ecx, 0											; fac variabila sa fie zero din nou 
	mov [var], ecx 
	jmp final

final:
	mov ecx, [count_bin]		
	inc ecx
	mov [count_bin], ecx					  ; incrementez count_bin
	inc esi 
	jmp parcurgere_sir_de_biti 
 
