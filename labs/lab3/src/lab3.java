import java.util.Arrays;
import java.util.Scanner;

public class lab3 {
    public static void main(String[] args) {
        Interpreter i = new Interpreter("C:/Users/marce/Google Drive/calpoly/junior/cpe315/CPE315/labs/lab3/src/lab3_fib.asm");
        if (true) {
            String[] lines = Parser.fileToString("C:/Users/marce/Google Drive/calpoly/junior/cpe315/CPE315/labs/lab3/src/lab3_fib.script").split("\n");
            // System.out.println(lines[0]);
            for (String line : lines) {
                // System.out.println(Arrays.toString(line.split(" ")));
                System.out.printf("mips> %s\n", line);
                i.parseCmd(line.split(" "));
            }
        } else {
            Scanner scanner = new Scanner(System.in);
            while (true) {
                System.out.printf("mips> ");
                String tokens[] = scanner.nextLine().split(" ");
                if (tokens[0].equals("q")) {
                    return;
                }
                i.parseCmd(tokens);
            }

        }
    }
}