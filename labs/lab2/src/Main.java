import java.util.Arrays;

public class Main {
    public static void main(String[] args) throws Exception {
        Parser p = new Parser();
        for (String line : p.firstPass(p.fileToString(args[0]))) {
            System.out.println(line);
            Instruction i = p.parseLine(line);
            System.out.println(i);
        }
        // System.out.println(Arrays.asList(p.labels));
        // System.out.println(p.parseR("add$v0,$v0,$0"));
        // System.out.println(p.parseR("sll $a0, $a1,10"));
    }
}
