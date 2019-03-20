  .ORIG x3500

        ; Question 1
Q1STR   .FILL Q1  ; Address of prompt
Q1PTS   .FILL #0 ; Point value for option 1
        .FILL #5  ; Point value for option 2
        .FILL #5  ; Point value for option 3
        .FILL #10  ; Point value for option 4

        ; Question 2
Q2STR   .FILL Q2
Q2PTS   .FILL #2
        .FILL #10
        .FILL #1
        .FILL #0

        ; Question 3
Q3STR   .FILL Q3
Q3PTS   .FILL #0
        .FILL #5
        .FILL #7
        .FILL #10

        ; Results
RESULTS .FILL GOODMSG
        .FILL PASSMSG
        .FILL FAILMSG

        ; Strings must be declared separately because their lengths are variable.
Q1      .STRINGZ "\nDo you know my name?\n    1) Jack\n    2) Mclean\n    3) Alex\n    4) Bailey\n"
Q2      .STRINGZ "\nThe best album of the last 20 years is...\n    1) In Rainbows - Radiohead\n    2) Is This It - The Strokes\n    3) Currents - Tame Impala\n    4) Either Or - Elliot Smith\n"
Q3      .STRINGZ "\nWhere would you like to travel?\n    1) Portugul\n    2) Nepal\n    3) Tanzania\n    4) Bolivia\n"

GOODMSG .STRINGZ "The points were arbitrary!"
PASSMSG .STRINGZ "?? (Thank you in Chinese)"
FAILMSG .STRINGZ "I should stop doing these the nights before..."

        .END