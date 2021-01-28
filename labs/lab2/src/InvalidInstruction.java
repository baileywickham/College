public class InvalidInstruction extends Exception {
    public InvalidInstruction(String inst) {
        super(String.format("invalid instruction: %s", inst));
    }
}
