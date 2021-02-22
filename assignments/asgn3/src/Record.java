public class Record implements Comparable <Record>{
    private int id;
    private double weight;
    
    public Record(int id, double weight){
        this.id = id;
        this.weight = weight;
    }
    public String toString(){
        return id+","+weight;
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
