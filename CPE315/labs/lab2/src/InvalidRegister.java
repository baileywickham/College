public class InvalidRegister extends Exception {
    public InvalidRegister(String reg) {
        super(String.format("invalid register: %s", reg));
    }
}
