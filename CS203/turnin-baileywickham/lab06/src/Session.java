
import java.util.ArrayList;
import java.util.List;
import java.util.LinkedList;

/**
 * A small data holder class for a session.
 */
public class Session {

    public final String id;
    public final Customer customer;
    public final List<View> views;
    public final List<Purchace> purchases;
    //
    // And any other needed fields
    //

    public Session(String id, Customer customer) {
        this.id = id;
        this.customer = customer;
        this.views = new LinkedList<View>();
        this.purchases = new ArrayList<Purchace>();
    }

    public String getID() {
        return this.id;
    }

    public void addPurchases(Purchace p) {
        this.purchases.add(p);
    }

    public void addViews(View v) {
        this.views.add(v);
    }

    /**
     * toString; useful for debugging
     */
    public String toString() {
        return "Session(id=" + id + ", customer=" + customer + ")";
    }

    public double sessionAverage() {
        double total = 0;
        for (View v : views) {
            total += v.product.price;
        }
        return total / views.size();
    }
    public boolean madePurchase() {
        return purchases.size() > 0;
    }
}


