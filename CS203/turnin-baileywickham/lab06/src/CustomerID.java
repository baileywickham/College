import java.util.Objects;

// TODO:  Fill this in.  You must provide a constructor that accepts
// two string arguments, one for each part of the Customer ID.
public class CustomerID {
    public final String reigon;
    public final String name;


    public CustomerID(String reigon, String name) {
        this.reigon = reigon;
        this.name = name;
    }

    @Override
    public int hashCode() {
        return Objects.hash(name,reigon);
    }

    @Override
    public boolean equals(Object obj) {
        if (obj instanceof CustomerID) {
            CustomerID cid = (CustomerID) obj;
            return reigon.equals(cid.reigon) && name.equals(cid.name);
        }
    return false;
    }

    @Override
    public String toString() {
        return reigon + " " + name ;
    }
}
