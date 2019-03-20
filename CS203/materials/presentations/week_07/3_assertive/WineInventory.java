
import java.util.Map;
import java.util.HashMap;

public class WineInventory {

    private final Map<WineKey, WineInventoryItem> stock;

    public WineInventory() {
        stock = new HashMap<WineKey, WineInventoryItem>();
    }

    // Precondition:  name shall be a non-null string containing the name
    //                of a wine, to be considered in a case-sensitive manner.
    //                Year shall be an integer giving the wine's vintage.
    //
    // Postcondition:  After this method completes, calls to this method
    //                 with the same name and year shall always give the
    //                 same WineInventoryItem instance.
    //
    public WineInventoryItem getWine(String name, int year) {
        // Check the precondition:
        assert name != null : "Wine name must be non-null";

        // Call the actual method:
        WineInventoryItem result = getWineImpl(name, year);

        // Check the postcondition:
        assert result == getWineImpl(name, year) :
            "Same WineInventoryInstance not found";

        return result;
    }

    private WineInventoryItem getWineImpl(String name, int year) {
        WineKey key = new WineKey(name, year);
        WineInventoryItem result = WineInventoryItem.getOrCreateItem(key, stock);
        return result;
    }
}
