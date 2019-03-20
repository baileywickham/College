## Stack Frame
R5 Points to start of locals

- Arguments
- local variables
- return value
  - space for value
- return address 
  - Addr of next instruction in calling func
  - Place to stare R7 (?)
- Dyn link
  - Calling funcs frame ptr
  - Old value of R5

Arguments are pushed in reverse order.

### Example
void foo(int a, int b)
int x, y, z;

[z]
[y]
[x]
...
[a]
[b]


[ Locals ]
[ DYN    ]
[ retaddr]
[ retval ]
[ args   ]

## Calling
### Caller
Push Arguments (reverse)
Call the sub (jsr)
### Callee
push space for return
push return addr (R7)
push dyn link (R5)
set the new frame ptr (R5)
Push local variables
Exec

## Teardown
### Callee
Store ret
Pop local
Pop dyn
Pop ret
ret JUMP R7
### Caller
Pop rt value
Pop args




