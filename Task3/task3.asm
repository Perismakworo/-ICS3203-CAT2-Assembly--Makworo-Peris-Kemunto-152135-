section .data
    prompt db "Enter a number to compute its factorial: ", 0  ; Prompt message
    result_msg db "Factorial is: ", 0                        ; Message before displaying factorial
    newline db 10, 0                                         ; Newline character

section .bss
    input resb 10          ; Buffer for storing user input

section .text
    global _start

_start:
    ; Step 1: Prompt the user for input
    mov eax, 4              ; syscall: sys_write
    mov ebx, 1              ; file descriptor: stdout
    mov ecx, prompt         ; Address of prompt message
    mov edx, 38             ; Length of the prompt message
    int 0x80

    ; Step 2: Read user input
    mov eax, 3              ; syscall: sys_read
    mov ebx, 0              ; file descriptor: stdin
    mov ecx, input          ; Address of input buffer
    mov edx, 10             ; Maximum bytes to read
    int 0x80

    ; Step 3: Convert input to integer
    mov esi, input          ; Point to the input buffer
    xor eax, eax            ; Clear eax (to store the result)
    xor ebx, ebx            ; Temporary storage
convert_to_int:
    lodsb                   ; Load the next byte into AL
    cmp al, 10              ; Check for newline
    je start_factorial      ; If newline, stop parsing
    sub al, '0'             ; Convert ASCII to integer
    imul eax, 10            ; Multiply result by 10
    add eax, al             ; Add the digit to the result
    jmp convert_to_int      ; Repeat for the next character

start_factorial:
    ; Step 4: Call the factorial subroutine
    push eax                ; Push the number onto the stack
    call factorial          ; Call the factorial subroutine
    add esp, 4              ; Clean up the stack

    ; Step 5: Print the result
    mov ebx, eax            ; Move the factorial result into ebx
    mov eax, 4              ; syscall: sys_write
    mov ecx, result_msg     ; Address of result message
    mov edx, 14             ; Length of result message
    int 0x80

    call print_int          ; Print the factorial result
    mov eax, 4              ; syscall: sys_write
    mov ebx, 1              ; File descriptor: stdout
    lea ecx, [newline]      ; Print a newline
    mov edx, 1              ; Length of newline
    int 0x80

    ; Step 6: Exit program
    mov eax, 1              ; syscall: sys_exit
    xor ebx, ebx            ; Exit code 0
    int 0x80

; Subroutine: Factorial calculation
factorial:
    push ebp                ; Save the base pointer
    mov ebp, esp            ; Set up a new base pointer
    push ebx                ; Preserve ebx on the stack
    push ecx                ; Preserve ecx on the stack

    mov ebx, [ebp+8]        ; Get the number (n) from the stack
    mov eax, 1              ; Initialize the result to 1

factorial_loop:
    cmp ebx, 1              ; Check if n <= 1
    jle factorial_done      ; If so, exit the loop
    imul eax, ebx           ; Multiply eax by ebx
    dec ebx                 ; Decrement n
    jmp factorial_loop      ; Repeat

factorial_done:
    pop ecx                 ; Restore ecx
    pop ebx                 ; Restore ebx
    pop ebp                 ; Restore ebp
    ret                     ; Return to the caller

; Subroutine: Print an integer
print_int:
    push eax                ; Save eax
    xor ecx, ecx            ; Clear ecx (digit counter)
    mov ebx, 10             ; Divisor for base 10
convert_digit:
    xor edx, edx            ; Clear edx (remainder)
    div ebx                 ; Divide eax by 10
    add dl, '0'             ; Convert remainder to ASCII
    push dx                 ; Store digit on the stack
    inc ecx                 ; Increment digit counter
    test eax, eax           ; Check if quotient is zero
    jnz convert_digit       ; Repeat if there are more digits

print_digits:
    pop eax                 ; Get a digit from the stack
    mov [input], al         ; Store the digit in the input buffer
    mov eax, 4              ; syscall: sys_write
    mov ebx, 1              ; File descriptor: stdout
    lea ecx, [input]        ; Address of the digit
    mov edx, 1              ; Length of the digit
    int 0x80
    loop print_digits       ; Repeat until all digits are printed

    pop eax                 ; Restore eax
    ret                     ; Return to the caller
