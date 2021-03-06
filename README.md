## Barbu Maria-Alexandra, 325CD 
# Tema 2- STRINGURI 
-------------------------------------------------------------------------------

## Binary to Hexadecimal:

Am creat noi variabile in section.data pentru a stoca acolo o copie a 
lungimii secventei de biti, restul impartirii la 4 a lungimii sirului de biti,
doi indecsi pentru a parcurge stringul dat (pe unul dintre ei il voi readuce 
mereu la valoarea 0 dupa ce formez un grup de 4 biti). 
Am impartit, asadar, lungimea sirului primit la 4, am obtinut restul "r" si
pentru primele "r" caractere din sir am calculat numarul din baza 10 pe care 
acestea il formeaza, adunand succesiv o variabila "var" initializata la 0 cu 
puterile lui "2" corespunzatoare bitilor de "1" gasiti. Pe acest numar din baza
10 l-am "transformat" in caracter, cu ajutorul unui tabel ASCII, si l-am 
inserat in stringul final.
Am incrementat apoi adresa secventei de biti cu "r" pozitii si am pornit sa
parcurg sirul caracter cu caracter. Folosind unul dintre contori, am format
grupuri de cate 4 biti si mereu cand am gasit un caracter de "1" am adaugat
variabilei "var" (initializata la 0 de fiecare data la inceputul unui nou grup
de 4 biti) puterea lui 2 aleasa in functie de pozitia in grupare a 
caracterului. Astfel, am "transformat" fiecare grup de biti intr-un numar in 
baza 10 de la 0 la 15. Am considerat 2 cazuri: numar mai mic/egal sau mai mare
decat 10, iar in functie de acestea am convertit numarul obtinut intr-un 
caracter din scrierea hexazecimala (cifre 0-9 si litere a-f), urmarind tabelul
ASCII. Fiecare caracter de acest tip a fost inserat in stringul final.     

### Str-Str:

Una dintre variabilele definite in section.data functioneaza drept contor
pentru pozitia la care am ajuns in sirul in care se cauta, iar alta drept 
contor pentru pozitia la care am ajuns in sirul cautat. Se parcurge fiecare 
caracter din sirul "haystack". Atata timp cat nu se ajunge la finalul sirului,
se compara cu primul caracter din "needle". Daca se gaseste nepotrivire, se
incrementeaza doar contorul din sirul mare, celalalt devenind din nou 0. De 
asemenea, se decrementeaza adresa la care se ajunsese in "needle" pana cand 
ajunge din nou la inceputul substringului. Daca se gaseste potrivire, se 
incrementeaza ambii numaratori. Cand se ajunge la finalul sirului "needle", 
inseamna ca s-a gasit prima aparitie a substring-ului in string, deci se 
decrementeaza adresa la care se ajunsese in "haystack" pana la inceperea 
substringului. Cand se ajunge la finalul sirului "haystack", inseamna ca nu s-a
gasit vreo aparitie a subsirului, deci functia returneaza lungimea sirului 
initial + 1. 

### Vigenere-Cipher:
Parcurg caracter cu caracter mesajul pe care il doresc criptat. Atata timp
cat inca nu am ajuns la finalul sirului, verific daca respectivul caracter este
litera mica/mare sau nu este litera (dupa codul sau ASCII). Daca nu este
litera, il introduc in sirul final. Daca este litera, impart contorul la care
se afla la lungimea cheii. Restul acestei impartiri imi indica indexul 
caracterului din cheie care ii corespunde, de aceea parcurg mai apoi cheia pana
cand ajung la indicele determinat de rest. Pentru a putea parcurge de mai multe
ori aceeasi cheie, folosesc un contor pe care il fac 0 la inceputul unei 
iteratii. Pentru a putea ignora caracterele care nu sunt litere, folosesc un 
contor care numara doar literele din mesaj. Cand ajung in cheie la pozitia
cautata, calculez indicele in alfabet al caracterului respectiv. In functie de
tipul literei- uppercase/lowercase, realizez criptarea, considerand doua 
formule pentru doua mari cazuri: numarul de deplasari este mai mare decat 
diferenta pana la finalul alfabetului, si atunci pornesc de la "a" dupa ce trec
de "z", sau numarul de deplasari este mai mic si pur si simplu il adun la codul
ASCII al caracterului. Introduc in sirul final caracterul criptat, incrementez 
adresa sirului initial.     

### Caesar Cipher:
Parcurg caracter cu caracter textul pe care il doresc criptat. Atata timp cat
nu am ajuns la finalul sirului, verific daca caracterul curent este sau nu 
litera mica/ mare. Impart cheia la 26 (numarul de litere din alfabet) si 
consider ca noua cheie restul acestei impartiri. Consider doua cazuri, similare
cu cele de la taskul "Vigenere-Cipher": daca cheia este mai mare decat 
diferenta pana la finalul alfabetului (si atunci pornesc de la "a" dupa ce trec
de "z"), sau este mai mica si pur si simplu adun cheia la codul ASCII al
caracterului. Criptarea am realizat-o separat pentru litere mari si pentru
litere mici.  

### One Time Pad:

Parcurg byte cu byte cheia. Daca nu am ajuns la finalul sirului, parcurg in
paralel byte cu byte textul. Realizez criptarea (operatia "xor" intre cele doua
caractere) si incrementez mereu contorul si adresa curenta in fiecare sir.  


