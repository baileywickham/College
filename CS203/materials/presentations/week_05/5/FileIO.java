
import java.io.File;
import java.io.FileReader;
import java.io.BufferedReader;
import java.io.IOException;

public class FileIO {

    public static void readAndShout(File file) throws IOException {
        System.out.println("********* Reading " + file + " *********");
        BufferedReader reader = null;
        try {
            reader = new BufferedReader(new FileReader(file));
            while (true) {
                String line = reader.readLine();
                if (line == null) {
                    break;
                }
                System.out.println(line.toUpperCase());
            }
        } finally {
            if (reader != null) {
                reader.close();
            }
            System.out.println("The file is closed now.");
        }
    }

    public static void main(String[] args) {

        try {
            readAndShout(new File("FileIO.java"));
            readAndShout(new File("I am a file that doesn't exist"));
        } catch (IOException ex) {
            ex.printStackTrace();
            System.out.println("Goodbye.");
            System.exit(1);
        }
        System.exit(0);
    }
}

