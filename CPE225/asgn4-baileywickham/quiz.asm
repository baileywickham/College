.ORIG x3000

        ; Example of printing Question 1: Q1STR is the address of an address in
        ;  the data file, so we have to make two passes using an LDI.
		LD R0, TRAPCMD
		STI R0, TRAPLOC
		
        LDI R0, Q1STR
        PUTS

        ; Example of using GETI -- uncomment when ready to use:
        LEA R0, ANSWER
        PUTS
        TRAP x26
        ADD R1, R0, #-1 ;Move offset to safe register
        ; Example of loading the address of the Question 1 points array.
        LD R0, Q1PTS
        ADD R0, R0, R1 ; You probably won't want an immediate here...
        LDR R0, R0, #0
        ADD R6, R0, #0

        LDI R0, Q2STR
        PUTS
        LEA R0, ANSWER
        PUTS
        TRAP x26
        ADD R1, R0, #-1
        LD R0, Q2PTS
        ADD R0, R0, R1
        LDR R0, R0, #0
        ADD R6, R6, R0

        LDI R0, Q3STR
        PUTS
        LEA R0, ANSWER
        PUTS
        TRAP x26
        ADD R1, R0, #-1
        LD R0, Q3PTS
        ADD R0, R0, R1
        LDR R0, R0, #0
        ADD R6, R6, R0

        LEA R0, RESULT
        PUTS

        ADD R6, R6, #-16
        ADD R6, R6, #-4
        BRnz FAIL
        ADD R6, R6, #-6
        BRnz EH
        BRnzp PASS

        FAIL LD R0, RESULTS
        LDR R0, R0, #2
        PUTS
        HALT
        EH LD R0, RESULTS
        LDR R0, R0, #1
        PUTS
        HALT
        PASS LD R0, RESULTS
        LDR R0, R0, #0
        PUTS
        HALT

ANSWER .STRINGZ "Answer: "
RESULT .STRINGZ "\nResult: "
Q1STR   .FILL x3500
Q1PTS   .FILL x3501
Q2STR   .FILL x3505
Q2PTS   .FILL x3506
Q3STR   .FILL x350A
Q3PTS   .FILL x350B
RESULTS .FILL x350F
TRAPCMD .FILL x3300
TRAPLOC .FILL x0026
        .END
