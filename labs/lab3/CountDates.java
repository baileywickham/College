import java.io.*;
import java.util.*;

public class CountDates {
    public static void main(String[] args) throws Exception {
        HashMap<String, ArrayList<String>> hm = new HashMap<>();

        try (BufferedReader br = new BufferedReader(new FileReader("./sales"))) {
            String line0;
            while ((line0 = br.readLine()) != null) {
                String[] tokens = line0.split(",");
                if (!hm.containsKey(tokens[1])) {
                    hm.put(tokens[1], new ArrayList<String>());
                }
                hm.get(tokens[1]).add(tokens[2] + ", " + tokens[3]);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        ArrayList<String> s = new ArrayList<String>(hm.keySet());
        Collections.sort(s);
        FileWriter f = new FileWriter("out");
        for (String d : s) {
            Collections.sort(hm.get(d));
            System.out.println(d.toString() + "\t" + String.join(", ", hm.get(d) + "\n"));
        }
        f.close();
    }
}
