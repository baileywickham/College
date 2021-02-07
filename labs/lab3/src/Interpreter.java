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
        //todo
    }
    public void dumpRegs() {
        //todo
    }
    public void incPC() {
        if (pc < insts.size()) {
            pc++;
            execute(insts.get(pc));
        }
    }
    public void step(int s) {
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
                for (int i = Integer.parseInt(args[1]); i < Integer.parseInt(args[2]); i++) {
                    System.out.printf("[%d] = %d", i, memory[i]);
                }
                break;
            case "c":
                this.memory = new int[8192];
                this.regs = new int[32];
                break;
            case "q":
                // todo
                return;
            default:
                // todo
                System.out.println("Bad cmd");
                break;
        }
    }

    public void execute(Instruction _inst) {
        switch (_inst.opName) {
            case "add": {
                RInstruction inst = (RInstruction) _inst;
                regs[inst.rdCode] = regs[inst.rsCode] + regs[inst.rtCode];
            }
            case "or": {
                RInstruction inst = (RInstruction) _inst;
                regs[inst.rdCode] = regs[inst.rsCode] | regs[inst.rtCode];
            }
            case "and": {
                RInstruction inst = (RInstruction) _inst;
                regs[inst.rdCode] = regs[inst.rsCode] & regs[inst.rtCode];
            }
            case "sub": {
                RInstruction inst = (RInstruction) _inst;
                regs[inst.rdCode] = regs[inst.rsCode] - regs[inst.rtCode];
            }
            case "slt": {
                RInstruction inst = (RInstruction) _inst;
                regs[inst.rdCode] = (regs[inst.rsCode] < regs[inst.rtCode]) ? 1 : 0;
            }
            case "sll": {
                RInstruction inst = (RInstruction) _inst;
                regs[inst.rdCode] = regs[inst.rsCode] << regs[inst.rtCode];
            }
            case "jr": {
                RInstruction inst = (RInstruction) _inst;
                this.pc = regs[inst.rsCode];
            }
            case "addi": {
                IInstruction inst = (IInstruction) _inst;
                regs[inst.rtCode] = regs[inst.rsCode] + inst.immediate;
            }
            case "beq": {
                IInstruction inst = (IInstruction) _inst;
                if (regs[inst.rsCode] == regs[inst.rtCode]) {
                    this.pc = pc + inst.immediate + 1;
                }
            }
            case "bne": {
                IInstruction inst = (IInstruction) _inst;
                if (regs[inst.rsCode] != regs[inst.rtCode]) {
                    this.pc = pc + inst.immediate + 1;
                }
            }
            case "sw": {
                IInstruction inst = (IInstruction) _inst;
                this.memory[regs[inst.rsCode] + inst.immediate] = regs[inst.rtCode];
            }
            case "lw": {
                IInstruction inst = (IInstruction) _inst;
                regs[inst.rtCode] = memory[regs[inst.rsCode] + inst.immediate];
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
