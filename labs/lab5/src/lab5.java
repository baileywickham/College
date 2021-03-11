import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

public class lab5 {
    public static void main(String[] args) {
        String file = fileToString(args[0]);
        Cache c1 = new Cache(...);
        Cache c2 = new Cache(...);
        Cache c3 = new Cache(...);
        Cache c4 = new Cache(...);
        for (String line: file.split("\n")) {
            Cache.lookup(line.split(" ")[1].trim());
        }
        c1.printResults();

    }

    public static String fileToString(String path) {
        // stolen from stack overflow
        String content = "";
        try {
            content = new String(Files.readAllBytes(Paths.get(path)));
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        return content;
    }
}