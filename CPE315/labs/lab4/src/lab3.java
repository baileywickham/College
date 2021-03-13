import java.util.Scanner;

public class lab3 {
    public static void main(String[] args) {
        Interpreter i = new Interpreter(args[0]);
        i.labNum = 3;
        if (args.length == 2) {
            String[] lines = Parser.fileToString(args[1]).split("\n");
            for (String line : lines) {
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