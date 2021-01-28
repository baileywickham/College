interface Instruction {
    String opcode = null;
    String toBinary();
    String toString();
    int lineNum = 0;
    int labelLocation = 0;
    // Need to add static instuction -> opcode number
    // Need to add static register name -> number
    // label jumps will be added in the parser
}
class RInstruction implements Instruction {
    public int opcode;
    public String opName;

    public String rsCode;
    public String rsName;
    public int rsRegNum;
    public String rtCode;
    public int rtRegNum;
    public String rtName;
    public String rdCode;
    public String rdName;
    public int rdRegNum;

    public int shamt;
    public String funct;
    public RInstruction(String opname,
                        String rsName, int rsRegNum,
                        String rtName, int rtRegNum,
                        String rdName, int rdRegNum,
                        int shamt)  {
        this.opName = opname;
        this.rsName = rsName;
        this.rsRegNum = rsRegNum;
        this.rtName = rtName;
        this.rtRegNum = rtRegNum;
        this.rdName = rdName;
        this.rdRegNum = rdRegNum;
        this.shamt = shamt;
    }

    @Override
    public String toBinary() {
        return null;
    }
    public String toString() {
        return String.format("%s %s, %s, %s shamt: %d",
                this.opName, this.rsName, this.rtName,
                this.rdName, this.shamt);
    }
}
class IInstruction implements Instruction {
    public String opName;
    public String rs;
    public int rsCode;
    public String rt;
    public int rtCode;
    public int immediate;
    public IInstruction(String opName, String rs, int rsCode, String rt, int rtCode, int immediate) {
        this.opName = opName;
        this.rs = rs;
        this.rsCode = rsCode;
        this.rt = rt;
        this.rtCode = rtCode;
        this.immediate = immediate;
    }

    @Override
    public String toBinary() {
        return null;
    }
}
class JInstruction implements Instruction {
    public String opName;
    public int address;
    public String name;
    public JInstruction(String opName, int address, String name) {
        this.opName = opName;
        this.address = address;
        this.name = name;

    }
    @Override
    public String toBinary() {
        return null;
    }
    public String toString() {
        
        return String.format("%s, %d",
                this.opName, this.address);
    }
}
