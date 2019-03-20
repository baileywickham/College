; A very useful program.
; CSC 225, Assignment 5

        .ORIG x3000

        ; TODO: Set the Trap Vector Table.
		LD R0, TRAPCMD
		STI R0, TRAPLOC

        ; TODO: Set the Interrupt Vector Table.
		LD R0, KBCMD
		STI R0, KBIN

        ; TODO: Initialize the stack pointer.
		LD R6, STACKPTR

MAIN    LEA R0, INITMSG ; Print the starting message.
        PUTS
        TRAP x26        ; Get a character.
        OUT             ; Print the character.
        TRAP x26        ; Repeat four more times.
        OUT
        TRAP x26
        OUT
        TRAP x26
        OUT
        TRAP x26
        OUT
        LEA R0, ENDMSG  ; Print the ending message.
        PUTS
        BRnzp MAIN

INITMSG .STRINGZ "Enter five characters: "
ENDMSG  .STRINGZ "\nSuccess! Running again...\n\n"
TRAPCMD .FILL x3300
TRAPLOC .FILL x26
KBIN 	.FILL x180
KBCMD 	.FILL x3500
STACKPTR .FILL x3000
        .END
