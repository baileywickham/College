
public class Product {
    public final String id;
    public final double price;
    public Product(String id, double price) {
        this.id = id;
        this.price = price;
    }

    @Override
    public String toString() {
        return  "Product (id=" + id + ")";
    }

    @Override
    public boolean equals(Object obj) {
        if (obj instanceof Product) {
            Product p = (Product) obj;
            if (id.equals(p.id) && price == p.price) {
                return true;
            }
        }
        return false;
    }
}
