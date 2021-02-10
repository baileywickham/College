import java.util.ArrayList;

public class Interpreter {
    ArrayList<Instruction> insts;
    int[] memory = new int[8192];
    int[] regs = new int[32];
    int pc;

    public Interpreter(String path) {
        Parser p = new Parser();
        this.insts = p.parse(path);
        this.pc = 0;
    }

    public void help() {
        System.out.println("\nh = show help\n" +
        "d = dump register state\n" +
        "s = single step through the program (i.e. execute 1 instruction and stop)\n" +
        "s num = step through num instructions of the program\n" +
        "r = run until the program ends\n" +
        "m num1 num2 = display data memory from location num1 to num2\n" +
                "c = clear all registers, memory, and the program counter to 0\n" +
        "q = exit the program\n");
    }
    public void dumpRegs() {
        System.out.printf("\npc = %d\n", pc);
        System.out.printf("$0 = %d\t$v0 = %d\t$v1 = %d\t $a0 = %d\n", regs[0], regs[2], regs[3], regs[4]);
        System.out.printf("$a1 = %d\t$a2 = %d\t$a3 = %d\t $t0 = %d\n", regs[5], regs[6], regs[7], regs[8]);
        System.out.printf("$t1 = %d\t$t2 = %d\t$t3 = %d\t $t4 = %d\n", regs[9], regs[10], regs[11], regs[12]);
        System.out.printf("$t5 = %d\t$t6 = %d\t$t7 = %d\t $s0 = %d\n", regs[13], regs[14], regs[15], regs[16]);
        System.out.printf("$s1 = %d\t$s2 = %d\t$s3 = %d\t $s4 = %d\n", regs[17], regs[18], regs[19], regs[20]);
        System.out.printf("$s5 = %d\t$s6 = %d\t$s7 = %d\t $t8 = %d\n", regs[21], regs[22], regs[23], regs[24]);
        System.out.printf("$t9 = %d\t$sp = %d\t$ra = %d\n\n", regs[25], regs[29], regs[31]);
    }
    public void incPC() {
        if (pc < insts.size()) {
            execute(insts.get(pc));
            pc++;
        }
    }
    public void step(int s) {
        System.out.printf("\t%d instruction(s) executed\n", s);
        for (int i = 0; i < s; i++) {
            incPC();
        }
    }

    public void parseCmd(String[] args) {
        switch (args[0]) {
            case "h":
                help();
                break;
            case "d":
                dumpRegs();
                break;
            case "s":
                if (args.length == 2) {
                    step(Integer.parseInt(args[1]));
                } else {
                    step(1);
                }
                break;
            case "r":
                // hack
                for (int i = 0; i < insts.size(); i++) {
                    incPC();
                }
                break;
            case "m":
                System.out.println();
                for (int i = Integer.parseInt(args[1]); i < Integer.parseInt(args[2]); i++) {
                    System.out.printf("[%d] = %d\n", i, memory[i]);
                }
                break;
            case "c":
                System.out.println("\tSimulator reset\n");
                this.memory = new int[8192];
                this.regs = new int[32];
                break;
            case "q":
                return;
            default:
                System.out.println("Bad cmd");
                break;
        }
    }

    public void execute(Instruction _inst) {
        switch (_inst.opName) {
            case "add": {
                RInstruction inst = (RInstruction) _inst;
                regs[inst.rdCode] = regs[inst.rsCode] + regs[inst.rtCode];
                break;
            }
            case "or": {
                RInstruction inst = (RInstruction) _inst;
                regs[inst.rdCode] = regs[inst.rsCode] | regs[inst.rtCode];
                break;
            }
            case "and": {
                RInstruction inst = (RInstruction) _inst;
                regs[inst.rdCode] = regs[inst.rsCode] & regs[inst.rtCode];
                break;
            }
            case "sub": {
                RInstruction inst = (RInstruction) _inst;
                regs[inst.rdCode] = regs[inst.rsCode] - regs[inst.rtCode];
                break;
            }
            case "slt": {
                RInstruction inst = (RInstruction) _inst;
                regs[inst.rdCode] = (regs[inst.rsCode] < regs[inst.rtCode]) ? 1 : 0;
                break;
            }
            case "sll": {
                RInstruction inst = (RInstruction) _inst;
                regs[inst.rdCode] = regs[inst.rsCode] << regs[inst.rtCode];
                break;
            }
            case "jr": {
                RInstruction inst = (RInstruction) _inst;
                this.pc = regs[inst.rsCode];
                break;
            }
            case "addi": {
                IInstruction inst = (IInstruction) _inst;
                regs[inst.rtCode] = regs[inst.rsCode] + inst.immediate;
                break;
            }
            case "beq": {
                IInstruction inst = (IInstruction) _inst;
                if (regs[inst.rsCode] == regs[inst.rtCode]) {
                    this.pc = pc + inst.immediate + 1;
                }
                break;
            }
            case "bne": {
                IInstruction inst = (IInstruction) _inst;
                if (regs[inst.rsCode] != regs[inst.rtCode]) {
                    this.pc = pc + inst.immediate + 1;
                }
                break;
            }
            case "sw": {
                IInstruction inst = (IInstruction) _inst;
                this.memory[regs[inst.rsCode] + inst.immediate] = regs[inst.rtCode];
                break;
            }
            case "lw": {
                IInstruction inst = (IInstruction) _inst;
                regs[inst.rtCode] = memory[regs[inst.rsCode] + inst.immediate];
                break;
            }
           // IInstruction
           // case "addi":
           // case "beq":
           // case "bne":
           //     return parseI(line, i);
           // case "sw":
           // case "lw":
           //     return parseStoreLoad(line);

        }

    }
}
