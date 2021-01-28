import java.util.Arrays;

public class Main {
    public static void main(String[] args) throws Exception {
        Parser p = new Parser();
        for (Instruction i : p.secondPass(p.firstPass(p.fileToString(args[0])))) {
            System.out.println(i.toString());
        }
    }
}
