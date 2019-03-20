
import java.util.Objects;

/**
 * An example of a resonable key for a system used to identify wines.
 * It contains a subtle bug - hashCode() is misspelled.  This lets us
 * explore how to debug code.
 */

public final class WineKey {

    public final String name;   // or more formally, "Appellation"
    public final int year;

    public WineKey(String name, int year) {
        this.name = name;
        this.year = year;
    }

    @Override
    public boolean equals(Object other) {
        if (other instanceof WineKey) {
            WineKey owk = (WineKey) other;
            boolean result = owk.name.equals(name) && owk.year == year;
            return result;
        } else {
            return false;
        }
    }

    // @Override
    public int hashcode() {
        int result = name.hashCode()*31 + year;
        return result;
    }

    @Override
    public String toString() {
        return "WineKey(" + name + ", " + year + ")";
    }
}
