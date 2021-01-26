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
        // addi $1 1
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
        // This is an awful mess...
        // Should match all instructions of type R
        // ^\s*\w+ -?\d*\(?\$\w+\)?,\s*-?\d*\(?\$\w+\)?,\s*-?\d*\(?\$\w+\)?\s*$
        if (Pattern.matches(
                 "^\\s*\\w+ -?\\d*\\(?\\$\\w+\\)?,\\s*-?\\d*\\(?\\$\\w+\\)?,\\s*-?\\d*\\(?\\$\\w+\\)?\\s*$",
                 line)) {
            // parse Instruction
            String[] regs = new String[3];
            int[] offsets = new int[3];
            int [] regNums = new int[3];
            int regNum = -1;
            String[] splits = line.split("\s+", 2);
            String inst = splits[0];
            splits = splits[1].split(",");
            for (int i = 0; i < 3; i++) {
                splits[i] = splits[i].strip();
                // We contain an offset
                // We are assuming balanced parens
                if (splits[i].contains("(") && splits[i].contains(")")) {
                    // Parse offset in front of number
                    int offset = Integer.parseInt(splits[i].substring(0, splits[i].indexOf("(")));
                    String reg = splits[i].substring(splits[i].indexOf("(")+1, splits[i].indexOf(")"));
                    if ((regNum = getRegNum(reg)) != -1) {
                        regs[i] = reg;
                        offsets[i] = offset;
                        regNums[i] = regNum;
                    } else {
                        throw new Exception("Invalid register");
                    }
                } else {
                    if ((regNum = getRegNum(splits[i])) != -1) {
                        regs[i] = splits[i];
                        regNums[i] = regNum;
                    } else {
                        throw new Exception("Invalid register");
                    }
                }
            }
            return new RInstruction(inst,
                    regs[0], regNums[0], offsets[0],
                    regs[1], regNums[1], offsets[1],
                    regs[2], regNums[2], offsets[2]);
        } else {
            throw new Exception("Instruction does not match R format");
        }
    }
    public int getRegNum(String reg) {
        if (this.labels.containsKey(reg)) {
            return this.labels.get(reg);
        }
        return -1;
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
        // need to test regex
        // Linenum only matches real lines, not blank or empty ones
        int lineNum = 0;
        // This could break on windows... oh well
        Pattern  label = Pattern.compile("^\s*\\w+:");
        Pattern inst = Pattern.compile("^\\s*\\w+");

        String[] lines = data.split("\n");
        for (int i = 0; i < lines.length; i++) {
            Matcher m = label.matcher(lines[i]);
            lines[i] = lines[i].strip();
            if (lines[i].contains("#")) {
                lines[i] = lines[i].substring(0, lines[i].indexOf('#'));
            }
            Matcher in = inst.matcher(lines[i]);
            if (m.find()) {
                System.out.print("here: ");
                System.out.println(lines[i]);
                // Strip labels from code
                // label: add i  -> add
                lines[i] = lines[i].substring(m.end());
                this.labels.put(m.group(), lineNum);
                lineNum++;
            } else if (in.find()) {
                System.out.print("here: ");
                System.out.println(lines[i]);
                lineNum++;
            }
        }
        return lines;
    }
}
