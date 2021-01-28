public class Product implements Comparable <Product>{
    private int id;
    private String name;
    private double price;
    
    public Product(int id, String categoryName, double weight){
        this.id = id;
        this.name = categoryName;
        this.price = weight;
    }
    public String toString(){
        return id+","+ name +","+ price;
    }
    public int compareTo(Product other){ //descending order
        if(this.price > other.price) {
            return -1;
        } 
        if(this.price < other.price){
            return 1;
        }
        return 0;
    }
}
