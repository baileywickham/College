import java.io.*;
import java.util.*;

public class CountDates {
    public static void main(String[] args) {
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
        for (Map.Entry<String, Integer> entry : map.entrySet()) {
            System.out.print(entry.getKey() + " ");
            System.out.println(entry.getValue());
        }
    }
}
