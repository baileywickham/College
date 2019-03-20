
import java.util.Map;
import java.util.HashMap;

public class WineInventory {

    private final Map<WineKey, WineInventoryItem> stock;

    public WineInventory() {
        stock = new HashMap<WineKey, WineInventoryItem>();
    }

    public WineInventoryItem getWine(String name, int year) {
        return WineInventoryItem.getOrCreateItem(new WineKey(name, year), stock);
    }
}
