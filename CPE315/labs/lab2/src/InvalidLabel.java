public class InvalidLabel extends Exception{
    public InvalidLabel(String reg) {
        super(String.format("invalid label: %s", reg));
    }
}
