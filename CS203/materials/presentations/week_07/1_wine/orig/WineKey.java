
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
            return owk.name.equals(name) && owk.year == year;
        } else {
            return false;
        }
    }

    @Override
    public int hashcode() {
        return name.hashCode()*31 + year;
    }
}
