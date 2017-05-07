/******************************************************************************
* @author Divyanshu Sharma
*****************************************************************************/
 
.global main
.func main
   
main:
    MOV R0, #0              @ initialze index variable

writeloop:    

    CMP R0, #10            @ check to see if we are done iterating
    BEQ writedone           @ exit loop if done

    LDR R1, =a             @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    
    PUSH {R0}
    PUSH {R1}
    PUSH {R2}

    BL _scanf
    POP {R2}
    STR R0, [R2]            @ write the address of a[i] to a[i]
    
    POP {R1}
    POP {R0}
    ADD R0, R0, #1          @ increment index
    B   writeloop           @ branch to next loop iteration

_scanf:
 PUSH {LR}
 SUB SP, SP, #4
 LDR R0, =entry
 MOV R1, SP
 BL scanf
 LDR R0, [SP]
 ADD SP, SP, #4
 POP {PC}

writedone:
    MOV R0, #0              @ initialze index variable

readloop:
    CMP R0, #10             @ check to see if we are done iterating
    BEQ readdone            @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address 
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    BL  _printf             @ branch to print procedure with return
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    B   readloop            @ branch to next loop iteration
readdone:
    @PUSH {R6}
    @ PUSH {R5}
    BL  search_prompt

    @PUSH {R0}
    @PUSH {R1}
    @PUSH {R2}

    BL _scanf_search
    MOV R5, R0
    
    MOV R1, R5           @R5 has the stuff that needs to be searched
    @BL print_input
    
    MOV R0, #0
    ADD R6, R0, #0
    @BL linear_search

linear_search:
    CMP R0, #10             @ check to see if we are done iterating
    BEQ search_done              @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address 
    
    PUSH {R5}
    @PUSH {R0}               @ backup register before printf
    @PUSH {R1}               @ backup register before printf
    @PUSH {R2}               @ backup register before printf
    
    CMP R1, R5
    MOVEQ R6, #1
    PUSHEQ {R6}
    PUSHEQ {R0}
    PUSHEQ {R1}
    PUSHEQ {R2}

    MOVEQ R2, R1              @ move array value to R2 for printf
    MOVEQ R1, R0              @ move array index to R1 for printf

    BLEQ  _printf             @ branch to print procedure with return

    POPEQ {R2}                @ restore register
    POPEQ {R1}                @ restore register
    POPEQ {R0}                @ restore register
    POPEQ {R6}
    POP {R5}

    ADD R0, R0, #1          @ increment index
    B   linear_search            @ branch to next loop iteration

search_done:   
    CMP R6, #0
    BLEQ not_exist
    POP {R6}
    @POP {R2}
    @POP {R1}
    @POP {R0}

    @POP {R5}
    @POP {R6}
    B _exit

not_exist:
PUSH {LR}
LDR R0, =dne
BL printf
POP {PC}

_scanf_search:
 PUSH {LR}
 SUB SP, SP, #4
 LDR R0, =number
 MOV R1, SP
 BL scanf
 LDR R0, [SP]
 ADD SP, SP, #4
 POP {PC}

print_input:
    PUSH {LR}
    LDR R0, =input
    BL printf
    POP {PC}

search_prompt:			@backup R7
    MOV R7, #4
    MOV R0, #1
    MOV R2, #21
    LDR R1, =prompt_str
    SWI 0
    MOV PC, LR 
searchdone:
     B _exit                 @ exit if done
_exit:  
   @ MOV R7, #4              @ write syscall, 4
   @ MOV R0, #1              @ output stream to monitor, 1
   @ MOV R2, #21             @ print string length
   @ LDR R1, =exit_str       @ string at label exit_str:
   @ SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall

_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return
   
.data

.balign 4
a:              .skip       40
printf_str:     .asciz      "array_a[%d] = %d\n"
exit_str:       .ascii      "Terminating program.\n"
entry:		.asciz	    "%d"
prompt_str:      .ascii     "ENTER A SEARCH VALUE:"
input:		.asciz		"Input= %d\n"
number:          .asciz        "%d"
dne:             .asciz      "That value does not exist in the array!\n"
