section .data
    prompt db "Enter a number: ", 0              ; Prompt message to ask the user for input
    positive_msg db "The number is POSITIVE.", 0 ; Message displayed if the number is positive
    negative_msg db "The number is NEGATIVE.", 0 ; Message displayed if the number is negative
    zero_msg db "The number is ZERO.", 0         ; Message displayed if the number is zero

section .bss
    input resb 10   ; Reserve 10 bytes for user input

section .text
    global _start

_start:
    ; Step 1: Prompt the user for input
    mov eax, 4                ; syscall: sys_write
    mov ebx, 1                ; file descriptor: stdout
    mov ecx, prompt           ; address of the prompt message
    mov edx, 16               ; length of the prompt message
    int 0x80                  ; make the syscall to write the prompt

    ; Step 2: Read user input
    mov eax, 3                ; syscall: sys_read
    mov ebx, 0                ; file descriptor: stdin
    mov ecx, input            ; address of the input buffer
    mov edx, 10               ; maximum number of bytes to read
    int 0x80                  ; make the syscall to read user input

    ; Step 3: Convert input to an integer
    mov esi, input            ; point to the start of the input buffer
    xor eax, eax              ; clear eax to store the result
    xor ebx, ebx              ; clear ebx (temporary storage)

parse_input:
    movzx ecx, byte [esi]     ; load the current character into ECX and zero-extend it
    cmp ecx, 0x0A             ; check if the character is a newline
    je classify_number         ; if newline, end input parsing
    sub ecx, '0'              ; convert ASCII character to integer
    imul eax, eax, 10         ; multiply the current result by 10
    add eax, ecx              ; add the current digit to the result
    inc esi                   ; move to the next character in the input
    jmp parse_input           ; repeat the loop for the next character

classify_number:
    ; Step 4: Classify the number
    cmp eax, 0                ; compare the number with 0
    je is_zero                ; if the number is 0, jump to `is_zero`
    jg is_positive            ; if the number is greater than 0, jump to `is_positive`
    jl is_negative            ; if the number is less than 0, jump to `is_negative`

is_positive:
    ; Display the positive message
    mov eax, 4                ; syscall: sys_write
    mov ebx, 1                ; file descriptor: stdout
    mov ecx, positive_msg     ; address of the positive message
    mov edx, 23               ; length of the positive message
    int 0x80                  ; make the syscall to display the message
    jmp end_program           ; exit the program

is_negative:
    ; Display the negative message
    mov eax, 4                ; syscall: sys_write
    mov ebx, 1                ; file descriptor: stdout
    mov ecx, negative_msg     ; address of the negative message
    mov edx, 23               ; length of the negative message
    int 0x80                  ; make the syscall to display the message
    jmp end_program           ; exit the program

is_zero:
    ; Display the zero message
    mov eax, 4                ; syscall: sys_write
    mov ebx, 1                ; file descriptor: stdout
    mov ecx, zero_msg         ; address of the zero message
    mov edx, 21               ; length of the zero message
    int 0x80                  ; make the syscall to display the message

end_program:
    ; Exit the program
    mov eax, 1                ; syscall: sys_exit
    xor ebx, ebx              ; exit code 0
    int 0x80                  ; make the syscall to terminate the program
