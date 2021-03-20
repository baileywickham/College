import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Random;

public class Lab1 {
    public static void main(String[] args) {
        // Number of records to generate
        final int storesNum = 100;
        final int customersNum = 1000;
        final int salesNum = 2000;
        final int productNum = 100;
        final int lineItemNum = 4000;

        // Data from files
        ArrayList<String> addrs = loadAddress();
        ArrayList<String> companyNames = loadFromFile("./src/companynames.txt");
        ArrayList<String> names = loadFromFile("./src/names.txt");
        ArrayList<String> products = loadFromFile("./src/products.txt");

        // Generate data, pass in data from files
        writeStore(storesNum, addrs, companyNames);
        writeCustomer(customersNum, addrs, names);
        writeSales(salesNum, storesNum, customersNum);
        writeProduct(productNum, products);
        writeLineItem(lineItemNum, salesNum, productNum);

    }
    public static void writeProduct(int n, ArrayList<String> products) {
        FileWriter fw;
        try {
            fw = new FileWriter("products");
            for (int i = 0; i < n; i++) {
                fw.write(String.format("%d, %s, %s\n",
                        i, genFromArr(products), genPrice()));
            }
            fw.close();
        } catch (Exception e) {
            System.out.println(e);
        }

    }

    public static void writeCustomer(int n, ArrayList<String> addrs, ArrayList<String> names) {
        FileWriter fw;
        try {
            fw = new FileWriter("customers");
            for (int i = 0; i < n; i++) {
                fw.write(String.format("%d, %s, %s, %s, %s\n",
                        i, genFromArr(names), genDate(),
                        genFromArr(addrs), genPhoneNumber()));

            }
            fw.close();
        } catch (Exception e) {
            System.out.println(e);
        }
    }
    public static void writeStore(int n, ArrayList<String> addrs, ArrayList<String> companyNames) {
        FileWriter fw = null;
        try {
            fw = new FileWriter("stores");
            for (int i = 0; i < n; i++) {
                fw.write(String.format("%d, %s, %s, %s\n",
                        i, genFromArr(companyNames), genFromArr(addrs), genPhoneNumber()));
            }
            fw.close();
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    public static void writeLineItem(int n, int salesNum, int productNum) {
        FileWriter fw = null;
        Random rand = new Random();
        try {
            fw = new FileWriter("lineItem");
            for (int i = 0; i < n; i++) {
                fw.write(String.format("%d, %d, %d, %d\n",
                        i, rand.nextInt(salesNum) , rand.nextInt(productNum), rand.nextInt(1000)));
            }
            fw.close();
        } catch (Exception e) {
            System.out.println(e);
        }
    }
    public static void writeSales(int n, int stores, int customers) {
        FileWriter fw = null;
        Random rand = new Random();
        try {
            fw = new FileWriter("sales");
            for (int i = 0; i < n; i++) {
                //13, 2017/1/1, 13:23:11, 23, 56
                fw.write(String.format("%d, %s, %s, %s, %s\n",
                        i, genDate(), genTime(), i % stores, i % customers));
            }
            fw.close();
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    public static String genDate() {
        Random rand = new Random();
        int year = 1960 + rand.nextInt(60);
        int month = 1 + rand.nextInt(12);
        int day = 1 + rand.nextInt(30);
        return String.format("%d/%02d/%02d", year, month, day);
    }

    public static String genPrice() {
        Random rand = new Random();
        return String.format("%3.2f", 1000*rand.nextDouble());
    }
    public static String genTime() {
        Random rand = new Random();
        int one = rand.nextInt(24);
        int two =  rand.nextInt(60);
        int three =  rand.nextInt(60);
        return String.format("%02d:%02d:%02d", one, two, three);
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
            System.out.println(e);
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
            System.out.println(e);
        }
        return names;

    }

    public static String genFromArr(ArrayList<String> arr) {
        int rnd = new Random().nextInt(arr.size());
        return arr.get(rnd);
    }
}
