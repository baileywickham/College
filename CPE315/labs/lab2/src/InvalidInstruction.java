public class InvalidInstruction extends Exception {
    String inst = "";
    public InvalidInstruction(String inst) {
        super("invalid instruction: " + inst);
        this.inst = inst;
    }

    @Override
    public String toString() {
        return "invalid instruction: " + inst;
    }
}
