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
    public int rsOffset;
    public String rtCode;
    public int rtRegNum;
    public String rtName;
    public int rtOffset;
    public String rdCode;
    public String rdName;
    public int rdRegNum;
    public int rdOffset;

    public String shamt;
    public String funct;
    public RInstruction(String opname,
                        String rsName, int rsRegNum, int rsOffset,
                        String rtName, int rtRegNum, int rtOffset,
                        String rdName, int rdRegNum, int rdOffset)  {
        this.opName = opname;
        this.rsName = rsName;
        this.rsRegNum = rsRegNum;
        this.rsOffset = rsOffset;
        this.rtName = rtName;
        this.rtRegNum = rtRegNum;
        this.rtOffset = rtOffset;
        this.rdName = rdName;
        this.rdRegNum = rdRegNum;
        this.rdOffset = rdOffset;
    }

    @Override
    public String toBinary() {
        return null;
    }
}
class IInstruction implements Instruction {
    public String rs;
    public String rt;
    public String immediate;

    @Override
    public String toBinary() {
        return null;
    }
}
class JInstruction implements Instruction {
    public String address;

    @Override
    public String toBinary() {
        return null;
    }
}
