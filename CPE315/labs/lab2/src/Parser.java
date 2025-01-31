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
        regs.put("$zero", 0); //maybe?
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

    public ArrayList<Instruction> secondPass(ArrayList<String> lines) {
        ArrayList<Instruction> insts = new ArrayList<>();
        for (int i = 0; i < lines.size(); i++ ) {
            try {
                Instruction inst = parseLine(lines.get(i), i);
                insts.add(inst);
            } catch (InvalidInstruction e) {
                System.out.println(e.toString());
                return null;
            } catch (Exception e) {
                System.out.println(e);
                return null;
            }
        }
        return insts;
    }

    public void parseOut(String path) {
        parsetoBin(firstPass(fileToString(path)));
    }

    public void parsetoBin(ArrayList<String> lines) {
        for (int i = 0; i < lines.size(); i++ ) {
            try {
                Instruction inst = parseLine(lines.get(i), i);
                System.out.println(inst.toBinary());
            } catch (InvalidInstruction e) {
                System.out.println(e.toString());
                return;
            } catch (Exception e) {
                System.out.println(e);
                return;
            }
        }
    }

    public Instruction parseLine(String rawLine, int i) throws Exception {
        Pattern inst = Pattern.compile("^\\s*\\w+");
        String line = rawLine.trim();
        Matcher m = inst.matcher(line);
        if (m.find()) {
            switch (m.group().trim()) {
                // RInstructions
                case "and":
                case "or":
                case "add":
                case "sll":
                case "sub":
                case "slt":
                    return parseR(line);
                case "jr":
                    return parseJR(line);

                    // IInstructions
                case "addi":
                case "beq":
                case "bne":
                    return parseI(line, i);
                case "sw":
                case "lw":
                    return parseStoreLoad(line);
                    // JInstructions
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
                "\\s*(sw|lw)\\s*\\$\\w+\\s*,\\s*-?\\d*\\(?\\$?\\w+\\)?",
                line)) {

            String[] splits = line.split("\\$", 2);
            String opName = splits[0].trim();
            splits = splits[1].split(",");
            String rd = "$" + splits[0].trim();
            if (!regs.containsKey(rd)) {
                throw new InvalidRegister(rd);
            }
            if (splits[1].contains("(") && splits[1].contains(")")) {
                offset = Integer.parseInt(splits[1].substring(0, splits[1].indexOf("(")).trim());
                rs = splits[1].substring(splits[1].indexOf("(")+1, splits[1].indexOf(")"));
            } else {
                rs = splits[1].trim();
            }

            if (!regs.containsKey(rs)) {
                throw new InvalidRegister(rs);
            }
            return new IInstruction(opName, rs, regs.get(rs), rd, regs.get(rd), offset);
        } else {
            throw new Exception("Invalid w instructions");
        }
    }

    public Instruction parseJR(String line) throws Exception {
        if (Pattern.matches(
                "\\s*jr\\s*\\$\\w+",
                line)) {
            String[] splits = line.split("\\$", 2);
            splits[1] = "$" + splits[1];
            if (!regs.containsKey(splits[1].trim())) {
                throw new InvalidRegister(splits[1]);
            }
            return new RInstruction("jr", splits[1].trim(), regs.get(splits[1]), "", 0, "", 0,  0);
        } else {
            throw new Exception("Invalid instruction");
        }
    }


    public Instruction parseJ(String line) throws Exception{
        String[] splits = line.split("\\s+");
        String opName = splits[0].trim().replaceAll("\\s+","");
        int address = 0;
        String name = splits[1].trim().replaceAll("\\s+","");
        if (!labels.containsKey(name))
        {
            throw new InvalidLabel(name);
        }
        address = labels.get(name);
        return new JInstruction(opName, address, name);

    }

    public Instruction parseI(String line, int i) throws Exception {
        if (Pattern.matches(
                "\\s*\\w+\\s*\\$\\w+\\s*,\\s*\\$\\w+\\s*,\\s*-?\\w+\\s*",
                line)) {
            String[] splits = line.split("\\$", 2);
            String inst = splits[0].trim();
            splits = splits[1].split(",");
            String rt = "$" + splits[0].trim();
            if (!regs.containsKey(rt)) {
                throw new InvalidRegister(rt);
            }
            String rs = splits[1].trim();
            if (!regs.containsKey(rs)) {
                throw new InvalidRegister(rs);
            }
            String immediate = splits[2].trim();
            if (inst.equals("addi")) {
                return new IInstruction(inst, rt, regs.get(rt), rs, regs.get(rs), Integer.parseInt(immediate));
            }
            if (!labels.containsKey(splits[2].trim())) {
                throw new InvalidLabel(splits[2].trim());
            }
            int imm = labels.get(immediate);

            int newImmediate = imm - (i + 1);
            return new IInstruction(inst, rt, regs.get(rt), rs, regs.get(rs), newImmediate);
        } else {
            throw new Exception("Invalid instruction");
        }
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
                    // Special case sll
                    regsNames[2] = regsNames[1];
                    regsNames[1] = "$0";

                }
            }
            return new RInstruction(inst,
                    regsNames[1], regs.get(regsNames[1]),
                    regsNames[2], regs.get(regsNames[2]),
                    regsNames[0], regs.get(regsNames[0]),
                    shamt);
        } else {
            throw new Exception("Instruction does not match R format");
        }
    }

    public ArrayList<String> firstPass(String data) {
        // Linenum only matches real lines, not blank or empty ones
        int lineNum = 0;
        // This could break on windows... oh well
        Pattern  labelP = Pattern.compile("^\\s*\\w+:");
        Pattern instP = Pattern.compile("^\\s*\\w+");
        ArrayList<String> parsedLines = new ArrayList<>();

        String[] lines = data.split("\n");
        for (String line : lines) {
            Matcher labelM = labelP.matcher(line);
            line = line.trim();
            // Strip comments
            if (line.contains("#")) {
                line = line.substring(0, line.indexOf('#')).trim();
            }

            Matcher instM = instP.matcher(line);

            if (labelM.find()) {
                // Strip labels from code
                // label: add i  -> add i
                line = line.substring(labelM.end());
                this.labels.put(labelM.group().substring(0, labelM.group().length() - 1), lineNum);
                if (!line.isEmpty()) {
                    parsedLines.add(line);
                }
                lineNum++;
            } else if (instM.find()) {
                parsedLines.add(line);
                lineNum++;
            }
        }
        return parsedLines;
    }

    public static String fileToString(String path) {
        // stolen from stack overflow
        String content = "";
        try
        {
            content = new String ( Files.readAllBytes(Paths.get(path) ) );
        }
        catch (Exception e)
        {
            System.out.println(e.toString());
        }

        return content;
    }
}
