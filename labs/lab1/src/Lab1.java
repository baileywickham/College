import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Random;

public class Lab1 {
    public static void main(String[] args) {
        final int stores = 100;
        final int customers = 1000;
        ArrayList<String> addrs = loadAddress();
        ArrayList<String> companyNames = loadFromFile("./src/companynames.txt");
        ArrayList<String> names = loadFromFile("./src/names.txt");

        writeStore(stores, addrs, companyNames);
        writeCustomer(customers, addrs, names);

    }
    public static void writeCustomer(int n, ArrayList<String> addrs, ArrayList<String> names) {
        for (int i = 0; i < n; i++) {
            System.out.println(String.format("%d, %s, %s, %s, %s",
                    i, genFromArr(names), genDate(), genFromArr(addrs), genPhoneNumber()));

        }
    }
    public static void writeStore(int n, ArrayList<String> addrs, ArrayList<String> companyNames) {
        for (int i = 0; i < n; i++) {
           System.out.println(String.format("%d, %s, %s, %s",
                   i, genFromArr(companyNames), genFromArr(addrs), genPhoneNumber()));
        }
    }
    public static String genDate() {
        Random rand = new Random();
        int year = 1960 + rand.nextInt(60);
        int month = 1 + rand.nextInt(12);
        int day = 1 + rand.nextInt(30);
        return String.format("%d/%02d/%02d", year, month, day);
    }
    public static String genPhoneNumber() {
        Random rand = new Random();
        int one = rand.nextInt(999);
        int two = rand.nextInt(999);
        int three = rand.nextInt(9999);
        return String.format("%03d %03d %04d", one, two, three);
    }
    public static ArrayList<String> loadAddress() {
        ArrayList<String> addrs = new ArrayList<String>();
        int i = 0;
        try (BufferedReader br = new BufferedReader(new FileReader("./src/addresses.txt"))) {
            String line0;
            String line1;
            while ((line0 = br.readLine()) != null && (line1 = br.readLine()) != null) {
                addrs.add(String.format("%s, %s", line0, line1));
            }
        } catch (Exception e) {
            System.out.println("Unable to open");
        }
        return addrs;
    }
    public static ArrayList<String> loadFromFile(String filename) {
        ArrayList<String> names = new ArrayList<String>();
        try (BufferedReader br = new BufferedReader(new FileReader(filename))) {
            String line;
            while ((line = br.readLine()) != null) {
                names.add(line);
            }
        } catch (Exception e) {
            System.out.println("Unable to open");
        }
        return names;

    }

    public static String genFromArr(ArrayList<String> arr) {
        int rnd = new Random().nextInt(arr.size());
        return arr.get(rnd);
    }
}
