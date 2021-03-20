import org.apache.hadoop.io.WritableComparable;
import org.apache.hadoop.io.WritableComparator;

public class NaturalKeyGroupingComparator extends 
                                              WritableComparator {
    protected NaturalKeyGroupingComparator() {
        super(CompositeKey.class, true);
    }   
    
    @Override
    public int compare(WritableComparable w1, WritableComparable w2) {
        CompositeKey k1 = (CompositeKey)w1;
        CompositeKey k2 = (CompositeKey)w2;
         
        return k1.getSymbol().compareTo(k2.getSymbol());
    }
}
