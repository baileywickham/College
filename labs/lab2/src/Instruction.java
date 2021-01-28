import java.util.HashMap;

abstract class Instruction {
    abstract String toBinary();
    public String intToNBits(int i, int n) {
        String s = Integer.toBinaryString(i);
        if (s.length() > n) {
            return s.substring(0,n);
        }
        while (s.length() < n) {
            s = "0" + s;
        }
        return s;
    }
}


class instCode {
    public String opCode;
    public String funct;
    public instCode(String opCode, String funct) {
        this.opCode = opCode;
        this.funct = funct;
    }
}
class RInstruction extends Instruction {
    public static HashMap<String, instCode> ops;
    static {
        ops = new HashMap<>();
        ops.put("add", new instCode("000000", "100000"));
        ops.put("sub", new instCode("000000", "101000"));
        ops.put("or", new instCode("000000", "100101"));
        ops.put("and", new instCode("000000", "100100"));
        ops.put("sll", new instCode("000000", "000000"));
        ops.put("slt", new instCode("000000", "101010"));
        ops.put("jr", new instCode("000000", "001000"));
    }
    public String opName;
    public String rdName;
    public int rdCode;
    public String rsName;
    public int rsCode;
    public String rtName;
    public int rtCode;
    public int shamt;
    public RInstruction(String opName,
                        String rsName, int rsCode,
                        String rtName, int rtCode,
                        String rdName, int rdCode,
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
        instCode i = RInstruction.ops.get(this.opName);
        return String.format("%s %s %s %s %s %s", i.opCode,
                intToNBits(rsCode, 5), intToNBits(rtCode, 5),
                intToNBits(rdCode, 5), intToNBits(shamt, 5),
                i.funct);
    }
    public String toString() {
        return String.format("%s %s, %s, %s shamt: %d",
                this.opName, this.rsName, this.rtName,
                this.rdName, this.shamt);
    }

}
class IInstruction extends Instruction {
    public String opName;
    public String rs;
    public int rsCode;
    public String rt;
    public int rtCode;
    public int immediate;

    public static HashMap<String, String> ops;
    static {
        ops = new HashMap<>();
        ops.put("addi", "001000");
        ops.put("beq", "000100");
        ops.put("bne", "000101");
        ops.put("lw", "100011");
        ops.put("sw", "101011");
    }

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
        return String.format("%s %s %s %s",
                ops.get(opName), intToNBits(rsCode, 5),
                intToNBits(rtCode, 5), intToNBits(immediate, 16));
    }
}
class JInstruction extends Instruction {
    public String opName;
    public int address;
    public String name;
    public static HashMap<String, String> ops;
    static {
        ops = new HashMap<>();
        ops.put("j", "000010");
        ops.put("jal", "000011");
    }
    public JInstruction(String opName, int address, String name) {
        this.opName = opName;
        this.address = address;
        this.name = name;

    }

    @Override
    public String toBinary() {
        return String.format("%s %s",
                ops.get(this.opName), intToNBits(address, 26));
    }
    public String toString() {
        return String.format("%s, %d",
                this.opName, this.address);
    }
}
