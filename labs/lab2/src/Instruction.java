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
    public String opcode;
    public String rs;
    public String rt;
    public String rd;
    public String shamt;
    public String funct;

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
