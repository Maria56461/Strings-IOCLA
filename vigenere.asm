%include "io.mac"

section .data
    contor dd 0									;parcurge intregul mesaj 
		contor2 dd 0 								;parcurge cheia 
		contor3 dd 0    						;numara literele din mesaj 
		lung_cheii dd 0							;copie a lungimii cheii
		character dd 0							;copie a caracterului din mesaj 
		lung_mesaj dd 0 						;copie a lungimii mesajului 

section .text
    global vigenere
    extern printf

vigenere:  
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     ecx, [ebp + 16]     ; plaintext_len
    mov     edi, [ebp + 20]     ; key
    mov     ebx, [ebp + 24]     ; key_len
		mov [lung_mesaj], ecx 			;copie a lungimii mesajului 
		mov [lung_cheii], ebx 			;copie a lungimii cheii

here_we_start: 
		xor eax, eax
		xor ecx, ecx 		
		xor ebx, ebx				  
		mov al, byte[esi] 					;parcurg caracter cu caracter 
																;mesajul pe care il doresc criptat
		inc esi 
		mov ebx, [lung_mesaj]				;salvez lungimea sirului in "ebx"
		cmp ebx, [contor]						;daca nu am ajuns la finalul sirului
		jg check_letter
																;altfel, daca am ajuns la finalul sirului 
		mov eax, 0						
		mov [contor], eax						;il fac din nou pe contor egal cu zero 					
		mov [contor3], eax					;il fac din nou pe contor3 egal cu zero 
		
    popa
    leave
    ret

check_letter: 
		xor ebx, ebx 								;il golesc pe ebx  
		mov bl, al									;copie a continutului lui "al" 
		cmp al, 0x41								;daca caracterul are codul ASCII 
																;mai mic decat al lui "A"
		jl no_letter
		mov al, bl 
		cmp al, 0x7a								;daca caracterul are codul ASCII 
																;mai mare decat al lui "z"
		jg no_letter
		mov al, bl 
		cmp al, 0x5a 								;daca caracterul are codul ASCII 
																;mai mare decat al lui "Z" si
																;mai mic decat al lui "z" 
		jg check_letter2
		xor eax, eax 
		mov al, bl 		
		jmp upper_case 							;daca caracterul este litera mare 

check_letter2:
		mov al, bl 
		cmp al, 0x61								;daca caracterul are codul ASCII
																;intre "Z" si "a"
		jl no_letter
		xor eax, eax 		
		mov al, bl 
		jmp lower_case							;daca caracterul este litera mica 

	
no_letter:
	mov [edx], bl 								;stochez caracterul in stringul final 
	inc edx 
	mov ebx, [contor]
	inc ebx
	mov [contor], ebx							;increment contor 
	jmp here_we_start 

upper_case:
		
																;in acest moment am caracterul din mesaj 
																;in "al" si in "bl"
																;"contor3" arata indicele la care 
																;ma situez in mesaj 
	mov [character], al 					;copie a caracterului din mesaj 
	mov al, byte[contor3] 				;deimpartitul - contorul
	mov bl, byte[lung_cheii]			;impartitorul - lungimea cheii     
	div bl 												;catul se stocheaza in al, restul in ah 
	jmp cheie_extinsa 

cheie_extinsa: 
	mov bl, byte[edi] 						;parcurg cheia pana ajung la indicele 
																;determinat de rest 
	cmp ah, [contor2]
	je encrypt_upper_case					;am in "character" caracterul din mesaj si in "bl" 
																;caracterul corespunzator din cheie 
	xor ecx, ecx 
	mov ecx, [contor2]
	inc ecx
	mov [contor2], ecx						;incrementez contorul/ am mai gasit o litera
	xor ecx, ecx  	
	inc edi
	jmp cheie_extinsa

encrypt_upper_case:  
	mov edi, [ebp + 20] 
	xor eax, eax
	mov eax, 0						
	mov [contor2], eax						;il fac din nou pe contor2 egal cu zero 
	sub bl, 0x41 									;aflu pozitia in alfabet a caracterului
																;corespunzator din cheie 
	mov al, [character]	
	sub al, 0x5a
	neg al
	cmp al, bl 							
	jge encrypt_1
	jmp encrypt_2

encrypt_1: 
	mov al, [character]
	add al, bl 										;caracter = caracter + cheie 
	mov ebx, [contor3]
	inc ebx
	mov [contor3], ebx						;incrementez contorul
	xor ebx, ebx 
	mov bl, al										;in "bl" caracterul criptat 
	jmp no_letter 

encrypt_2: 
	mov al, [character]
	sub bl, 0x1a
	add al, bl	
	mov ebx, [contor3]
	inc ebx
	mov [contor3], ebx						;incrementez contorul 
	mov bl, al 
	jmp no_letter 
	
lower_case: 
	mov [character], al 					;copie a caracterului din mesaj 
	mov al, byte[contor3] 				;deimpartitul - contorul
	mov bl, byte[lung_cheii]			;impartitorul - lungimea cheii    
	div bl 												;catul se stocheaza in al, restul in ah 
	jmp cheie_extinsa1 
   
cheie_extinsa1: 
	mov bl, byte[edi] 						;parcurg cheia pana ajung la indicele 
																;determinat de rest 
	cmp ah, [contor2]
	je encrypt_lower_case					;am in "character" caracterul din mesaj si in "bl" 
	 	
	xor ecx, ecx 
	mov ecx, [contor2]
	inc ecx
	mov [contor2], ecx						;incrementez contorul/ am mai gasit o litera
	xor ecx, ecx  	
	inc edi														
	jmp cheie_extinsa1

encrypt_lower_case:
	;bl contine un caracter din cheie 
	mov edi, [ebp + 20] 
	xor eax, eax
	mov eax, 0						
	mov [contor2], eax						;il fac din nou pe contor2 egal cu zero 
	sub bl, 0x41 									;aflu pozitia in alfabet a caracterului
																;corespunzator din cheie 
	mov al, [character]	
	sub al, 0x7a
	neg al
	cmp al, bl 							
	jge encrypt_1
	jmp encrypt_2

