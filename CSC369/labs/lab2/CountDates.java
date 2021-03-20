import java.io.*;
import java.util.*;

public class CountDates {
    public static void main(String[] args) throws Exception {
        HashMap<String, Integer> map = new HashMap<>();
        try (BufferedReader br = new BufferedReader(new FileReader("./sales"))) {
            String line0;
            while ((line0 = br.readLine()) != null) {
                String[] tokens = line0.split(" ");
                if (map.containsKey(tokens[1])) {
                    map.put(tokens[1], map.get(tokens[1]) + 1);
                } else {
                    map.put(tokens[1], 1);
                }
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        ArrayList<String> s =  new ArrayList<>(map.keySet());
        Collections.sort(s);
        FileWriter f = new FileWriter("out");
        for (String d : s) {
            f.write(d + " " + map.get(d) + "\n");
        }
        f.close();
    }
}
