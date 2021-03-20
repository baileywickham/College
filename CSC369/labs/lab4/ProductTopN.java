import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;

public class ProductTopN {
    public static void main(String[] args) throws IOException {
        HashMap<String, ArrayList<String>> hm = new HashMap<>();

        try (BufferedReader br = new BufferedReader(new FileReader("./data"))) {
            String line0;
            while ((line0 = br.readLine()) != null) {
                String[] tokens = line0.split(",");
                if (!hm.containsKey(tokens[2])) {
                    hm.put(tokens[2], new ArrayList<String>());
                }
                hm.get(tokens[2]).add(tokens[0] + ", " + tokens[1]);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        ArrayList<String> s = new ArrayList<>(hm.keySet());
        Collections.sort(s, new Sortbyroll());
        FileWriter f = new FileWriter("out");
        int count = 0;
        for (String d : s) {
            if (count >= 10) {
                return;
            }
            count++;
            Collections.sort(hm.get(d));
            System.out.println(String.join(", ", hm.get(d) + d.toString() + "\n"));
        }
        f.close();
    }

    static class Sortbyroll implements Comparator<String>
    {
        // Used for sorting in ascending order of
        // roll number
        public int compare(String a, String b)
        {
            return Float.compare(Float.parseFloat(b), Float.parseFloat(a));
        }
    }
}
