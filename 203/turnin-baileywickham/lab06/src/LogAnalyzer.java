import java.io.File;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

public class LogAnalyzer {

    private final Log log;    // The log we're analyzing

    /**
     * Create a new analyzer object to analyze the given log
     */
    public LogAnalyzer(Log log) {
        this.log = log;
    }

    //
    // Round a double value to two decimal places.  Use this to format
    // all of your calculated values.
    //
    private static String format(double value) {
        return String.format("%.2f", value);
    }


        //write this after you have figured out how to store your data
        //make sure that you understand the problem
    void printAverageViewsWithoutPurchase() {
        /* add printing */
        int counter = 0;
        double ave = 0;
        for (Session s : log.sessionByID.values()) {
            if (s.purchases.size() == 0) {
                ave += s.views.size();
                counter++;
            }
        }
        System.out.println("Average Views without Purchase: " + format(ave / counter));
    }

        //write this after you have figured out how to store your data
        //make sure that you understand the problem
    void printSessionPriceDifference() {
        System.out.println("Price Difference for Purchased Product by Session");
        List<Session> pur = log.sessionByID.values().stream()
                .filter(Session::madePurchase)
                .sorted(Comparator.comparing(s -> s.toString()))
                .collect(Collectors.toList());


        for (Session s : pur) {
            System.out.println("    " + s.id);
            for (Purchace p : s.purchases) {
                System.out.println("        " + p.product.id + " " + format(p.product.price - s.sessionAverage()));

            }
        }

        /* add printing */
        // Hint:  ArrayList.sort() is a good way to sort a list.  See also
        //        https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#ArrayList-java.util.Collection-
    }

        //write this after you have figured out how to store your data
        //make sure that you understand the problem
    void printCustomerItemViewsForPurchase() {
        System.out.println("Number of Views for Purchased Product by Customer");
        /* add printing */
        List<Customer> customers = log.customerByID.values().stream()
                .filter(Customer::madePurchace)
                .sorted(Comparator.comparing(c -> c.id.toString()))
                .collect(Collectors.toList());
        for (Customer b : customers) {
            System.out.println("    " + b.id.reigon + " " + b.id.name);
            List<Product> purchasedThings = b.getPurchases();
            purchasedThings.sort(Comparator.comparing(p -> p.id));
            for (Product p : purchasedThings) {
                System.out.println("        " + p.id + " " + b.getViewsOfProduct(p));
            }
        }
    }


    /*
     * This method traverses your Log once it is populated.
     */
    private void printOutExample() {
        //
        // Iterate through the customers, in any order
        //
        for (Customer customer : log.customerByID.values()) {
            System.out.println(customer);
            for (Session session : customer.getSessions()) {
                System.out.println("    in " + session);
                for (View view : session.views) {
                    System.out.println("        looked at " + view.product);
                }
            }
        }
    }

    /**
     * The main analyzing function
     */
    public void analyze() {
        if (Constants.DEBUG) {
            System.out.println();
            System.out.println("*******  printOutExample() results:  ************");
            System.out.println();
            printOutExample();
            System.out.println();
            System.out.println();
        }
        printAverageViewsWithoutPurchase();
        System.out.println();
        printSessionPriceDifference();
        System.out.println();
        printCustomerItemViewsForPurchase();
    }
}
