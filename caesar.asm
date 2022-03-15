%include "io.mac"

section .data
    contor dd 0
		aux db 0

section .text
    global caesar
    extern printf

caesar:
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     edi, [ebp + 16]     ; key
    mov     ecx, [ebp + 20]     ; length
		xor eax, eax 								;il golesc pe "eax"

aici_incepem:
		mov al, byte[esi]						;parcurg caracter cu caracter textul 
																;pe care il doresc criptat 
		inc esi 										;trecere la caracterul urmator 
		mov ebx, ecx								;salvez lungimea sirului in "ebx"
		cmp ebx, [contor]						;daca nu am ajuns la finalul sirului
		jg check_letter
																;altfel, daca am ajuns la finalul sirului 
		mov eax, 0						
		mov [contor], eax						;il fac din nou pe contor egal cu zero 
		
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
		mov al, bl 
		jmp encrypt_upper_case 			;daca caracterul este litera mare 

check_letter2:
		mov al, bl 
		cmp al, 0x61								;daca caracterul are codul ASCII
																;intre "Z" si "a"
		jl no_letter
		mov al, bl 
		jmp encrypt_lower_case			;daca caracterul este litera mica 

no_letter:
	mov [edx], bl 								;stochez caracterul in stringul final 
	inc edx 
	mov ebx, [contor]
	inc ebx
	mov [contor], ebx							;increment contor 
	jmp aici_incepem 

encrypt_lower_case:
	xor eax, eax
	mov al, bl 
	mov [aux], al 
	mov eax, edi
	mov bl, 0x1a
	div bl 
	mov bl, ah		
	xor eax, eax 
	mov al, byte[aux]	
	sub al, 0x7a									;daca prin deplasarea caracterului
	neg al												;s-ar trece de finalul alfabetului 
	cmp al, bl 
	jge encrypt1
	jmp encrypt2

encrypt2:
	xor eax, eax 
	mov al, byte[aux]							;cheia devine restul impartirii la 26
																;care este numarul de litere din alfabet 
	sub bl, 0x1a
	mov al, byte[aux]
	add al, bl  
	mov bl, al 
	jmp no_letter

encrypt1:
	xor eax, eax
	mov al, [aux] 
	add al, bl
	mov bl, al 
	jmp no_letter

encrypt_upper_case: 
	xor eax, eax
	mov al, bl 
	mov [aux], al 
	mov eax, edi
	mov bl, 0x1a
	div bl 
	mov bl, ah		
	xor eax, eax 
	mov al, byte[aux]	
	sub al, 0x5a									;daca prin deplasarea caracterului
	neg al												;s-ar trece de finalul alfabetului 
	cmp al, bl 
	jge encrypt1
	jmp encrypt2

