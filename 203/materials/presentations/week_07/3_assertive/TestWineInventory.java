
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;

/**
 * Test out WineInventory by creating a bunch of WineInventoryItem instances,
 * and then setting quantities and prices.
 */


public class TestWineInventory {
    private static String[] wineNames = new String[] {
        "Bonnes-Mares",             // See Bonnes-Mares.pdf
        "Bonnes-Mares",
        "Bonnes-Mares",
        "Bonnes-Mares",
        "Bonnes-Mares",
        "Bonnes-Mares",
        "Clos de La Roch",          // See Morey-Saint-Denis.pdf
        "Clos de La Roch",
        "Clos de La Roch",
        "Clos de La Roch",
        "Clos de Tart",             // Also Morey-Saint-Denis.pdf
        "Clos de Tart",
        "Clos de Tart",
        "Clos de Tart",
        null
    };
        
    private static int[] wineYears = new int[] {
        2002, 2004, 2009, 2010, 2011, 2012, // Bonnes-Mares
        2005, 2010, 2012, 2013,             // Clos de la Roch
        1999, 2005, 2007, 2008, 2012        // Clos de Tart
    };

    private static int[] winePriceDollars = new int[] {
        500, 450, 400, 350, 200, 250,
        300, 200, 180, 150,
        1000, 500, 250, 400, 200
    };


    private static ArrayList<WineKey> makeWineKeys() {
        ArrayList<WineKey> result = new ArrayList<WineKey>();
        for (int i = 0; i < wineNames.length; i++) {
            result.add(new WineKey(wineNames[i], wineYears[i]));
        }
        return result;
    }

    private static void assertEquals(int a, int b) {
        if (a != b) {
            throw new RuntimeException("Error:  " + a + " != " + b);
        }
    }

    public static void main(String[] args) {
        WineInventory inventory = new WineInventory();
        ArrayList<WineKey> keys = makeWineKeys();
        for (int i = 0; i < keys.size(); i++) {
            WineKey key = keys.get(i);
            WineInventoryItem item = inventory.getWine(key.name, key.year);
            int newPrice = winePriceDollars[i] * 100;
            item.setPrice(newPrice);
        }
        for (int i = 0; i < keys.size(); i++) {
            WineKey key = keys.get(i);
            WineInventoryItem item = inventory.getWine(key.name, key.year);
            int oldPrice = winePriceDollars[i] * 100;
            assertEquals(item.getPrice(), oldPrice);
        }

        System.out.println("Tests passed");
    }
}



