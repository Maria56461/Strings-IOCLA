%include "io.mac"
section .data
    count_haystack dd 0					; parcurge sirul in care se cauta  
		count_needle dd 0 					; parcurge sirul care se cauta  
		lung_haystack dd 0							
		lung_needle dd 0 									

section .text
    global my_strstr
    extern printf

my_strstr:
    push    ebp
    mov     ebp, esp
    pusha

    mov     edi, [ebp + 8]      ; substr_index
    mov     esi, [ebp + 12]     ; haystack- sirul in care se cauta 
    mov     ebx, [ebp + 16]     ; needle- sirul care se cauta 
    mov     ecx, [ebp + 20]     ; haystack_len- lungimea sirului 
																; in care se cauta
    mov     edx, [ebp + 24]     ; needle_len- lungimea sirului care se cauta
		mov [lung_haystack], ecx 		; copie a lungimii sirului in care se cauta
		mov [lung_needle], edx 			; copie a lungimii sirului care se cauta 
		xor ecx, ecx								; registre care pot fi folosite 
		xor eax, eax 
		xor edx, edx  
		 
here_we_start:
		mov al, byte[esi]						; parcurg caracter cu caracter sirul initial
		inc esi 
		mov ecx, [lung_haystack]		;salvez lungimea sirului in "ecx"
		cmp ecx, [count_haystack]		;daca nu am ajuns la finalul sirului
		jg check_substring
																;altfel, daca am ajuns la finalul sirului 
		mov eax, 0						
		mov [count_haystack], eax		;il fac din nou pe count_haystack egal cu zero 					
		mov [count_needle], eax			;il fac din nou pe count_needle egal cu zero 
		xor ecx, ecx
		mov ecx, [lung_haystack]
		add ecx, 1
		mov [edi], ecx 

    popa
    leave
    ret

check_substring:
		xor ecx, ecx 
		mov cl, byte[ebx]						; parcurg caracter cu caracter sirul 
																; care se cauta 	
		mov edx, [count_needle]
		add edx, 1 
		cmp edx, [lung_needle]
		je ultimul_caracter 				; daca am ajuns la ultimul caracter din  
																; sirului cautat, jump
		
		inc ebx  
		cmp al, cl 									; compar cele doua caractere 
		je check_match  
		mov eax, [count_haystack]		; daca nu se potrivesc 
		inc eax
		mov [count_haystack], eax		; increment contor
		mov eax, [count_needle]
		cmp eax, 0
		jg decrement 
		dec ebx
		jmp here_we_start

decrement: 
		mov ecx, [count_needle]
		add ecx, 1
		label:
		dec ebx
		loop label 
		mov eax, 0
		mov [count_needle], eax 		; refac indexul din substring sa fie 0 
		jmp here_we_start 

ultimul_caracter: 
		cmp al, cl 
		jne final
		mov ecx, [count_haystack]
		add ecx, 1 
		sub ecx, [lung_needle]
		mov [edi], ecx  
		mov eax, 0						
		mov [count_haystack], eax		;il fac din nou pe count_haystack egal cu zero 					
		mov [count_needle], eax			;il fac din nou pe count_needle egal cu zero 
		popa
    leave
    ret  

final: 
		mov eax, [count_haystack]		; daca nu se potrivesc 
		inc eax
		mov [count_haystack], eax		; increment contor
		mov eax, [count_needle]
		cmp eax, 0
		jg decrement 
		jmp here_we_start

check_match: 
		mov eax, [count_needle]			; daca se potrivesc 
		inc eax
		mov [count_needle], eax			; increment contor din substring 
		mov eax, [count_haystack]			
		inc eax
		mov [count_haystack], eax		; increment contor din sirul initial
		jmp here_we_start 

