import java.util.HashMap;

interface Instruction {
    String toBinary();
    String toString();
    int lineNum = 0;
    int labelLocation = 0;
    // Need to add static instuction -> opcode number
    // Need to add static register name -> number
    // label jumps will be added in the parser
}
class RInstruction implements Instruction {
    public static HashMap<String, String> ops;
    static {
        ops = new HashMap<>();
        ops.put("add", "00000");
    }
    public String opName;

    public String rdName;
    public int rdCode;
    public String rsName;
    public int rsCode;
    public String rtName;
    public int rtCode;

    public int shamt;
    public String funct;
    public RInstruction(String opName,
                        String rdName, int rdCode,
                        String rsName, int rsCode,
                        String rtName, int rtCode,
                        int shamt)  {
        this.opName = opName;
        this.rdName = rdName;
        this.rdCode = rdCode;
        this.rsName = rsName;
        this.rsCode = rsCode;
        this.rtName = rtName;
        this.rtCode = rtCode;
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
    public String toString() {
        return String.format("%s %s %s immediate: %s", opName, rs, rt, immediate);
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
