section .data
    modulus   dd 3233       ; n = 61*53 (example primes product)
    public_e  dd 17         ; public exponent e
    message   dd 65         ; plaintext to encrypt (m < n)
    result    dd 1          ; encrypted result = m^e mod n

section .text
global _start

_start:
    mov ecx, [public_e]     ; loop counter = e
    mov ebx, [message]      ; ebx = current base value
    mov edi, [modulus]      ; edi = modulus n

exponent_loop:
    ; Check current exponent bit
    test ecx, 1
    jz square_step

    ; Multiply: result = (result * base) % n
    mov eax, [result]
    mul ebx                 ; eax * ebx → edx:eax
    div edi                 ; edx = remainder after division by n
    mov [result], edx

square_step:
    ; Square: base = (base^2) % n
    mov eax, ebx
    mul eax                 ; eax^2 → edx:eax
    div edi                 ; edx = remainder after division by n
    mov ebx, edx

    ; Shift exponent bits right
    shr ecx, 1
    jnz exponent_loop

    ; Exit syscall (result in [result])
    mov eax, 1
    int 0x80
