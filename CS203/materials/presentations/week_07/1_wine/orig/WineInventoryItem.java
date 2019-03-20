
import java.util.Map;
import java.util.Objects;

public class WineInventoryItem {

    private final WineKey id;
    private int quantity;
    private int price;  // in cents, only meaningful if quantity isn't 0

    private WineInventoryItem(WineKey id, int quantity, int price) {
        Objects.requireNonNull(id);
        this.id = id;
        this.quantity = quantity;
        this.price = price;
    }

    //
    // This factory method is only to be called by WineInventory
    //
    static WineInventoryItem getOrCreateItem(WineKey id, 
                                             Map<WineKey, WineInventoryItem> map) 
    {
        WineInventoryItem result = map.get(id);
        if (result == null) {
            result = new WineInventoryItem(id, 0, 0);
            map.put(id, result);
        }
        return result;
    }

    /**
     * Get the wine's name (appellation)
     */
    public String getName() {
        return id.name;
    }

    /**
     * Get the wine's year
     */
    public int getYear() {
        return id.year;
    }

    /**
     * Get the quantity on hand
     */
    public int getQuantity() {
        return quantity;
    }

    /**
     * Set the quantity on hand
     */
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    /**
     * Get the price
     */
    public int getPrice() {
        return price;
    }

    /**
     * Set the price
     */
    public void setPrice(int price) {
        this.price = price;
    }
}
