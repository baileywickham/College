public class Record implements Comparable <Record>{
    private int id;
    private String categoryName;
    private double weight;
    
    public Record(int id, String categoryName, double weight){
        this.id = id;
        this.categoryName = categoryName;
        this.weight = weight;
    }
    public String toString(){
        return id+","+categoryName+","+weight;
    }
    public int compareTo(Record other){ //descending order
        if(this.weight > other.weight) {
            return -1;
        } 
        if(this.weight < other.weight){
            return 1;
        }
        return 0;
    }
}
