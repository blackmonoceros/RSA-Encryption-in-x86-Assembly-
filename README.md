# RSA Encryption in x86 Assembly  
*A simplified implementation of modular exponentiation for educational purposes*  

---

## 📝 Assembly Code  
;=====================================================

; Data Section - RSA Parameters

;=====================================================

section .data
modulus dd 3233 ; n = 61*53 (example primes product)
public_e dd 17 ; public exponent e
message dd 65 ; plaintext to encrypt (m < n)
result dd 1 ; encrypted result = m^e mod n

;=====================================================

; Code Section - Square-and-Multiply Algorithm

;=====================================================

section .text
global _start

_start:
mov ecx, [public_e] ; loop counter = e
mov ebx, [message] ; ebx = current base value
mov edi, [modulus] ; edi = modulus n

exponent_loop:

;-------------------------------------------------

; Multiplication Step (when LSB = 1)

;-------------------------------------------------

test ecx, 1 ; Check current exponent bit
jz square_step ; Skip if bit = 0

text
mov eax, [result]       ; Load current result
mul ebx                 ; Multiply: eax * ebx → edx:eax
div edi                 ; Modulo: edx = remainder(edx:eax / edi)
mov [result], edx       ; Store updated result
square_step:

;-------------------------------------------------

; Squaring Step (executed for every bit)

;-------------------------------------------------

mov eax, ebx ; Load current base
mul eax ; Square: eax^2 → edx:eax
div edi ; Modulo: edx = remainder(edx:eax / edi)
mov ebx, edx ; Update base value

text

;-------------------------------------------------

; Control Flow
;-------------------------------------------------


shr ecx, 1              ; Shift exponent right
jnz exponent_loop       ; Continue until ECX = 0

; Terminate program
mov eax, 1
int 0x80
text


---


## 📊 Key Components  


| Component       | Register | Purpose                             |
|-----------------|----------|-------------------------------------|
| Modulus (n)     | EDI      | Stores 3233 (61×53)                 |
| Public Exponent | ECX      | Loop counter initialized to e=17    |
| Message (m)     | EBX      | Base value starting at m=65         |
| Result          | [result] | Stores final encrypted value        |


---


## 🚀 Execution Flow  
1. **Initialization**  
   - Load parameters into registers  
   - Set result = 1 (multiplicative identity)
     

2. **Bitwise Processing**  
While ECX > 0:
IF (ECX & 1):
result = (result * base) % n
base = (base^2) % n
ECX >>= 1


text


3. **Exit**  
- Result stored in memory location `[result]`  


---


## 📈 Example Calculation  
**Input:**  
- Message (m): 65  
- Public Exponent (e): 17  
- Modulus (n): 3233  


**Computation:**  

65^17 % 3233 = 2790 # Verified via Python: pow(65, 17, 3233)


text


**Output:**  

Encrypted value `2790` stored in `[result]`


---


## ⚠️ Limitations & Improvements  


| Category        | Current Implementation           | Recommended Enhancement           |
|-----------------|-----------------------------------|------------------------------------|
| Number Size     | 32-bit integers                   | 2048-bit multi-precision arithmetic|
| Security        | Vulnerable to timing attacks      | Constant-time implementation       |
| Functionality   | Encryption only                   | Add decryption with private key d  |
| Input Handling  | Hardcoded values                  | File I/O for message processing    |


---


## 🔍 Assembly-Specific Notes  

;-----------------------------------------------------

; Critical Instructions Explained

;-----------------------------------------------------

mul ebx ; EDX:EAX = EAX*EBX (64-bit result)
div edi ; EAX = quotient, EDX = remainder
shr ecx, 1 ; Right-shift exponent (ECX >>= 1)

text

---
