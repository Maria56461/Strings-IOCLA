%include "io.mac"

section .data
    num dd 0

section .text		
    global otp
    extern printf
	
otp:
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext, adresa primului byte al string-ului 
    mov     edi, [ebp + 16]     ; key
    mov     ecx, [ebp + 20]     ; length
	    
begin: 
		mov bl, byte[edi]						;parcurg byte cu byte cheia, stochez in ebx
		inc edi  										;trec la urmatorul caracter
		mov eax, ecx   							;salvez in eax lungimea                    
		cmp eax, [num]	        		;daca nu s-a ajuns la finalul sirului, parcurg stringul "plaintext"
		jg go_through_plaintext	
		
		xor eax, eax								;golesc eax
		xor ebx, ebx 								;golesc ebx
		mov eax, 0						
		mov [num], eax							;il fac din nou pe num egal cu zero 
	
		popa
		leave
		ret
		
go_through_plaintext:
	xor eax, eax									;il golesc pe eax 
	mov al, byte[esi]							;parcurg byte cu byte stringul "plaintext"
	inc esi 											;trec la urmatorul caracter 
	xor al, bl										;criptarea
	mov [edx], al									;mut rezultatul criptarii ca valoare in edx 
	inc edx 											;la edx + 1 voi stoca urmatorul caracter criptat 
	
	mov ebx, [num]
	inc ebx
	mov [num], ebx								;increment num 

	jmp begin 


