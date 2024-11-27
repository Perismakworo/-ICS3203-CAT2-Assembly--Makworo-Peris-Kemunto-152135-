section .data
    prompt db "Enter 5 integers separated by spaces: ", 0  ; Message to prompt the user
    newline db 10, 0                                      ; Newline character
    reversed_msg db "Reversed array: ", 0                ; Message before printing reversed array

section .bss
    buffer resb 100         ; Input buffer for storing user input (up to 100 bytes)
    array resd 5            ; Space to store 5 integers (each 4 bytes)

section .text
    global _start

_start:
    ; Step 1: Print the prompt
    mov eax, 4              ; syscall: sys_write
    mov ebx, 1              ; file descriptor: stdout
    mov ecx, prompt         ; Address of prompt message
    mov edx, 35             ; Length of prompt message
    int 0x80

    ; Step 2: Read user input
    mov eax, 3              ; syscall: sys_read
    mov ebx, 0              ; file descriptor: stdin
    mov ecx, buffer         ; Address of input buffer
    mov edx, 100            ; Maximum bytes to read
    int 0x80

    ; Step 3: Parse input into the array
    mov esi, buffer         ; Point to the input buffer
    mov edi, array          ; Point to the start of the array
    mov ecx, 5              ; We want to parse exactly 5 integers
parse_loop:
    call read_int           ; Call the subroutine to parse one integer
    stosd                   ; Store the parsed integer in the array
    loop parse_loop         ; Repeat for all 5 integers

    ; Step 4: Reverse the array in place
    mov ecx, 5              ; Number of elements in the array
    shr ecx, 1              ; Divide by 2 to get the midpoint
    mov esi, array          ; Start pointer (beginning of array)
    lea edi, [array + 16]   ; End pointer (last element of array)
reverse_loop:
    cmp ecx, 0              ; Check if all swaps are done
    je reverse_done
    ; Swap elements at `esi` and `edi`
    mov eax, [esi]          ; Load value from the start of the array
    mov ebx, [edi]          ; Load value from the end of the array
    mov [esi], ebx          ; Write the end value to the start
    mov [edi], eax          ; Write the start value to the end
    add esi, 4              ; Move the start pointer forward
    sub edi, 4              ; Move the end pointer backward
    dec ecx                 ; Decrement loop counter
    jmp reverse_loop        ; Repeat until midpoint is reached
reverse_done:

    ; Step 5: Print the reversed array message
    mov eax, 4              ; syscall: sys_write
    mov ebx, 1              ; file descriptor: stdout
    mov ecx, reversed_msg   ; Address of reversed array message
    mov edx, 16             ; Length of the message
    int 0x80

    ; Step 6: Print the reversed array
    mov ecx, 5              ; Number of elements to print
    mov esi, array          ; Start of the array
print_loop:
    lodsd                   ; Load the next integer into EAX
    call print_int          ; Print the integer
    mov eax, 4              ; syscall: sys_write
    mov ebx, 1              ; file descriptor: stdout
    lea ecx, [newline]      ; Address of newline character
    mov edx, 1              ; Length of newline character
    int 0x80
    loop print_loop         ; Repeat for all 5 integers

    ; Step 7: Exit program
    mov eax, 1              ; syscall: sys_exit
    xor ebx, ebx            ; Exit code 0
    int 0x80

; Subroutine: Parse an integer from input
read_int:
    xor eax, eax            ; Clear EAX (to store the result)
    xor ebx, ebx            ; Clear EBX (temporary storage)
parse_digit:
    lodsb                   ; Load the next byte into AL
    cmp al, ' '             ; Check for a space (end of number)
    je parse_done
    cmp al, 10              ; Check for newline
    je parse_done
    sub al, '0'             ; Convert ASCII to integer
    imul ebx, ebx, 10       ; Multiply the current result by 10
    add ebx, eax            ; Add the current digit
    jmp parse_digit         ; Repeat for the next character
parse_done:
    mov eax, ebx            ; Store the parsed integer in EAX
    ret                     ; Return to the caller

; Subroutine: Print an integer
print_int:
    push eax                ; Save the value to print
    xor ecx, ecx            ; Clear ECX (digit count)
    mov ebx, 10             ; Divisor for base 10
convert_digit:
    xor edx, edx            ; Clear remainder
    div ebx                 ; Divide EAX by 10
    add dl, '0'             ; Convert remainder to ASCII
    push dx                 ; Store the digit on the stack
    inc ecx                 ; Increment digit count
    test eax, eax           ; Check if the quotient is zero
    jnz convert_digit       ; Repeat if there are more digits
print_digits:
    pop eax                 ; Get a digit from the stack
    mov [buffer], al        ; Store the digit in the buffer
    mov eax, 4              ; syscall: sys_write
    mov ebx, 1              ; file descriptor: stdout
    lea ecx, [buffer]       ; Address of the digit
    mov edx, 1              ; Length of the digit
    int 0x80
    loop print_digits       ; Repeat until all digits are printed
    pop eax                 ; Restore original value
    ret                     ; Return to the caller
