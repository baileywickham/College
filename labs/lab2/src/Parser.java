import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Parser {
    public HashMap<String, Integer> labels;

    public Parser() {
        this.labels = new HashMap<>();
    }
    public void parse(String path) {
        // |>
        secondPass(firstPass(fileToString(path)));
    }
    public void secondPass(String[] lines) {

    }
    public String fileToString(String path) {
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
        Pattern  label = Pattern.compile("^\\w+:");
        String[] lines = data.split("\n");
        for (int i = 0; i < lines.length; i++) {
            Matcher m = label.matcher(lines[i]);
            if (m.find()) {
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
