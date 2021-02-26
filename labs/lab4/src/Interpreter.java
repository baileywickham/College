import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public class Interpreter {
    ArrayList<Instruction> insts;
    int[] memory = new int[8192];
    int[] regs = new int[32];
    String if_id = "empty", id_exe = "empty", exe_mem = "empty", mem_wb = "empty";
    int pc;
    int instructions;
    int cycles;
    boolean jump = false;
    boolean br_taken = false;
    boolean ld_used = false;
    int labNum = 0;
    final Set<String> control = new HashSet<String>(
       Arrays.asList("beq", "bne", "j", "jal", "jr"));


    public Interpreter(String path) {
        Parser p = new Parser();
        this.insts = p.parse(path);
        this.pc = 0;
        this.instructions = 0;
        this.cycles = 0;
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
    public void checkHazard(String insName){
        if (control.contains(insName))
        {
            System.out.println("CONTROL HAZARD");
        }

    }
    public void stepInst(int s) {
        String insName = insts.get(pc).opName;
        if (labNum == 3){
            System.out.printf("\t%d instruction(s) executed\n", s);
        }
        if (labNum == 4){
            checkHazard(insName);
            mem_wb = exe_mem;
            exe_mem = id_exe;
            id_exe = if_id;
            if_id = insName;
            printPipeline();
        }
        for (int i = 0; i < s; i++) {
            incPC();
        }
    }

    public void stepCycle(int s) {
        cycles++;

    }

    public void stepPipeline() {
        mem_wb = exe_mem;
        exe_mem = id_exe;
        id_exe = if_id;
    }
    public void printPipeline(){
        System.out.println();
        System.out.println("pc if/id id/exe exe/mem mem/wb");
        System.out.printf("%d   %s  %s  %s  %s\n", pc, if_id, id_exe, exe_mem, mem_wb);
        System.out.println();
    }

    public void parseCmd(String[] args) {
        char cmd = args[0].charAt(0);
        switch (cmd) {
            case 'p':
                printPipeline();
                break;
            case 'h':
                help();
                break;
            case 'd':
                dumpRegs();
                break;
            case 's':
                if (args.length == 2) {
                    String s = args[1].replaceAll("\\D+","");
                    Integer numSteps = Integer.parseInt(s);
                    stepInst(numSteps);
                } else {
                    stepInst(1);
                }
                break;
            case 'r':
                // hack
                while (pc < insts.size()) {
                    incPC();
                }
                break;
            case 'm':
                System.out.println();
                String args1 = args[1].replaceAll("\\D+","");
                String args2 = args[2].replaceAll("\\D+","");
                for (int i = Integer.parseInt(args1); i < Integer.parseInt(args2) + 1; i++) {
                    System.out.printf("[%d] = %d\n", i, memory[i]);
                }
                break;
            case 'c':
                System.out.println("\tSimulator reset\n");
                this.memory = new int[8192];
                this.regs = new int[32];
                if_id = "empty";
                id_exe = "empty";
                exe_mem = "empty";
                mem_wb = "empty";
                break;
            case 'q':
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
                this.pc -= 1;
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
                    this.pc = pc + inst.immediate;
                    // this.pc -= 1;
                }
                break;
            }
            case "bne": {
                IInstruction inst = (IInstruction) _inst;
                if (regs[inst.rsCode] != regs[inst.rtCode]) {
                    this.pc = pc + inst.immediate;
                    // this.pc -= 1;
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
            case "j": {
                JInstruction inst = (JInstruction) _inst;
                pc = inst.address;
                this.pc -= 1;
                break;
            }
            case "jal": {
                JInstruction inst = (JInstruction) _inst;
                // may not be +1
                regs[31] = pc + 1;
                pc = inst.address;
                this.pc -= 1;
                break;
            }
            default: {
                System.out.println("bad cmd");
            }
        }

    }
}
