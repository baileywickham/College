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
        regs.put("$0", 0);
        regs.put("$v0", 2);
        regs.put("$v1", 3);
        regs.put("$a0", 4);
        regs.put("$a1", 5);
        regs.put("$a2", 6);
        regs.put("$a3", 7);
        regs.put("$t0", 8);
        regs.put("$t1", 9);
        regs.put("$t2", 10);
        regs.put("$t3", 11);
        regs.put("$t4", 12);
        regs.put("$t5", 13);
        regs.put("$t6", 14);
        regs.put("$t7", 15);
        regs.put("$s0", 16);
        regs.put("$s1", 17);
        regs.put("$s2", 18);
        regs.put("$s3", 19);
        regs.put("$s4", 20);
        regs.put("$s5", 21);
        regs.put("$s6", 22);
        regs.put("$s7", 23);
        regs.put("$t8", 24);
        regs.put("$t9", 25);
        regs.put("$sp", 29);
        regs.put("$ra", 31);
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
                insts.add(inst);
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
        //  and, or, add, addi, sll, sub, slt, beq, bne, lw, sw, j, jr, and jal.
        Pattern inst = Pattern.compile("^\\s*\\w+");
        Matcher m = inst.matcher(line);
        if (m.find()) {
            switch (m.group()) {
                case "and":
                case "or":
                case "add":
                case "sll":
                case "sub":
                case "slt":
                    return parseR(line);
                    // special case JR cause it's a pain
                case "jr":
                    return parseJR(line);
                case "addi":
                case "beq":
                case "bne":
                    return parseI(line);
                case "sw":
                case "lw":
                    return parseStoreLoad(line);
                case "j":
                case "jal":
                    return parseJ(line);
                default:
                    throw new InvalidInstruction(m.group());
            }
        }
        return null;
    }

    public Instruction parseStoreLoad(String line) throws Exception {
        int offset = 0;
        String rs = "";
        if (Pattern.matches(
                "\\s*(sw|lw)\\s*$\\w+\\s*,\\s*,-?\\d*\\(?$?\\w?\\)?",
                line)) {

            String[] splits = line.split("$", 2);
            String opName = splits[0].trim();
            splits = splits[1].split(",");
            String rd = splits[0].trim();
            if (!regs.containsKey(rd)) {
                throw new InvalidRegister(rd);
            }
            if (splits[1].contains("(") && splits[1].contains(")")) {
                offset = Integer.parseInt(splits[1].substring(0, splits[1].indexOf("(")));
                rs = splits[1].substring(splits[1].indexOf("("), splits[1].indexOf(")"));
            } else {
                rs = splits[1].trim();
            }

            if (!regs.containsKey(rs)) {
                throw new InvalidRegister(rs);
            }
            return new IInstruction(opName, rd, regs.get(rd), rs, regs.get(rs), offset);
        } else {
            throw new Exception("Invalid w instructions");
        }
    }

    public Instruction parseJR(String line) throws Exception {
        if (Pattern.matches(
                "\\s*jr\\s*$\\w+",
                line)) {
            String[] splits = line.split("$", 2);
            if (!regs.containsKey(splits[1].trim())) {
                throw new InvalidRegister(splits[1]);
            }
            return new RInstruction("jr", splits[1].trim(), regs.get(splits[1]), "", 0, "", 0,  0);
        } else {
            throw new Exception("Invalid instruction");
        }
    }


    public Instruction parseJ(String line) {
        return null;
    }

    public Instruction parseI(String line) throws Exception {
        if (Pattern.matches(
                "\\s*\\w+\\s*$\\w+\\s*,\\s*$\\w+\\s*,\\s*-?\\d?",
                line)) {
        } else {
            throw new Exception("Invalid instruction");
        }
        return null;
    }

    public Instruction parseR(String line) throws Exception {
        // This is an awful mess...
        // Should match most instructions of type R
        if (Pattern.matches(
                 "^\\s*\\w+\\s*-?\\d*\\(?\\$\\w+\\)?,\\s*-?\\d*\\(?\\$\\w+\\)?,\\s*-?\\d*\\(?\\$?\\w+\\)?\\s*$",
                 line)) {
            // parse Instruction
            String[] regsNames = new String[3];
            int shamt = 0;

            String[] splits = line.split("\\$", 2);
            String inst = splits[0].trim();
            splits[1] = "$" + splits[1];
            splits = splits[1].split(",");
            for (int i = 0; i < 3; i++) {
                splits[i] = splits[i].trim();
                // We contain an offset
                // We are assuming balanced parens
                if (splits[i].charAt(0) == '$') {
                    if (!regs.containsKey(splits[i])) {
                        throw new InvalidRegister(splits[i]);
                    }
                    regsNames[i] = splits[i];
                } else {
                    shamt = Integer.parseInt(splits[i]);
                    regsNames[i] = "$0";
                }
            }
            return new RInstruction(inst,
                    regsNames[0], regs.get(regsNames[0]),
                    regsNames[1], regs.get(regsNames[1]),
                    regsNames[2], regs.get(regsNames[2]),
                    shamt);
        } else {
            throw new Exception("Instruction does not match R format");
        }
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
        // Linenum only matches real lines, not blank or empty ones
        int lineNum = 0;
        // This could break on windows... oh well
        Pattern  label = Pattern.compile("^\\s*\\w+:");
        Pattern inst = Pattern.compile("^\\s*\\w+");

        String[] lines = data.split("\n");
        for (int i = 0; i < lines.length; i++) {
            Matcher m = label.matcher(lines[i]);
            lines[i] = lines[i].trim();
            if (lines[i].contains("#")) {
                lines[i] = lines[i].substring(0, lines[i].indexOf('#'));
            }
            Matcher in = inst.matcher(lines[i]);
            if (m.find()) {
                // Strip labels from code
                // label: add i  -> add
                lines[i] = lines[i].substring(m.end());
                this.labels.put(m.group(), lineNum);
                lineNum++;
            } else if (in.find()) {
                lineNum++;
            }
        }
        return lines;
    }
}
