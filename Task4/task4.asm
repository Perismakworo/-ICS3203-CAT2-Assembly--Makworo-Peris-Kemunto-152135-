section .data
    sensor_value db 0x05    ; Simulated sensor value
    motor_status db 0x00    ; Motor status (0 = off, 1 = on)
    alarm_status db 0x00    ; Alarm status (0 = off, 1 = triggered)

section .text
    global _start

_start:
    ; Step 1: Read the sensor value
    mov al, [sensor_value]  ; Load the simulated sensor value into AL

    ; Step 2: Determine action based on sensor value
    cmp al, 8               ; Check if the sensor value > 8
    jg trigger_alarm        ; If true, trigger the alarm
    cmp al, 5               ; Check if the sensor value <= 5
    jle stop_motor          ; If true, stop the motor

    ; Turn on motor if sensor value is moderate
    mov byte [motor_status], 1
    jmp done

stop_motor:
    ; Stop the motor
    mov byte [motor_status], 0
    jmp done

trigger_alarm:
    ; Trigger the alarm
    mov byte [alarm_status], 1

done:
    ; Exit program
    mov eax, 1              ; syscall: sys_exit
    xor ebx, ebx            ; Exit code 0
    int 0x80
