public class lab3 {
    public static void main(String[] args) {
        Interpreter i = new Interpreter("test1.asm");
        if (args.length == 2) {
            String[] lines = Parser.fileToString(args[1]).split("\n");
            for (String line : lines) {
                i.parseCmd(line.split(" "));
            }
        } else {
            // mips> mode
        }
    }
}