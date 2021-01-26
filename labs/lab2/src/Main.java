import java.util.Arrays;

public class Main {
    public static void main(String[] args) throws Exception {
        Parser p = new Parser();
        for (String line : p.firstPass(p.fileToString(args[0]))) {
            System.out.println(line);
        }
        System.out.println(Arrays.asList(p.labels));
        p.parseR("add $v0, 32($v0), $0");
    }
}
