import java.util.ArrayList;

public class Interpreter {
    ArrayList<Instruction> insts;
    public Interpreter(String path) {
        Parser p = new Parser();
        this.insts = p.parse(path);
    }
}
