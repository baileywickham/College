import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Parser {
    public HashMap<String, Integer> labels;
    public static HashMap<String, Integer> regs;
    static {
        regs = new HashMap<>();
        // need to change, add all regs
        regs.put("$a0", 0);
    }

    public Parser() {
        this.labels = new HashMap<>();
    }

    public void parse(String path) {
        // |>
        ArrayList<Instruction> insts = secondPass(firstPass(fileToString(path)));
    }
    public void printInsts(ArrayList<Instruction> insts) {

    }
    public void printInstsBin(ArrayList<Instruction> insts) {

    }
    public ArrayList<Instruction> secondPass(String[] lines) {
        ArrayList<Instruction> insts = new ArrayList<>();
        for (int i = 0; i < lines.length; i++) {
            try {
                Instruction inst = parseLine(lines[i], i);
                // inst will be null if the line is empty
                if (inst != null) {
                    insts.add(inst);
                }
            } catch (Exception e)  {
                System.out.println(String.format("Error parsing line %d", i));
                System.out.println(e);
                return null;
            }
        }
        return insts;
    }

    public Instruction parseLine(String line, int lineNum) throws Exception {
        Pattern inst = Pattern.compile("^\\s*\\w+");
        Matcher m = inst.matcher(line);
        if (m.find()) {
            switch (m.group()) {
                case "and":
                case "or":
                case "add":
                    return parseR(line);
            }
        }
        return null;
    }

    public Instruction parseR(String line) throws Exception {
        return null;
    }

    public String fileToString(String path) {
        // stolen from stack overflow
        String content = "";
        try
        {
            content = new String ( Files.readAllBytes(Paths.get(path) ) );
        }
        catch (Exception e)
        {
            System.out.println(e);
        }

        return content;
    }
    public String[] firstPass(String data) {
        // This could break on windows... oh well
        // need to test regex
        Pattern  label = Pattern.compile("^\s*\\w+:");
        String[] lines = data.split("\n");
        for (int i = 0; i < lines.length; i++) {
            Matcher m = label.matcher(lines[i]);
            if (m.find()) {
                // Strip labels from code
                lines[i] = lines[i].substring(m.end());
                this.labels.put(m.group(), i);
            }
            // Strip comments
            if (lines[i].contains("#")) {
                lines[i] = lines[i].substring(0, lines[i].indexOf('#'));
            }
        }
        return lines;
    }
}
