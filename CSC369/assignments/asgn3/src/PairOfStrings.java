import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.io.WritableComparable;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

/**
 * The DateTemperaturePair class enable us to represent a composite type of
 * (yearMonth, day, temperature). To persist a composite type (actually any data
 * type) in Hadoop, it has to implement the org.apache.hadoop.io.Writable
 * interface.
 *
 * To compare composite types in Hadoop, it has to implement the
 * org.apache.hadoop.io.WritableComparable interface.
 *
 * @author Mahmoud Parsian
 *
 */
public class PairOfStrings
        implements Writable, WritableComparable<PairOfStrings> {

    private Text left=new Text();
    private Text right=new Text();

    public PairOfStrings() {
    }
    public void set(Text left, Text right){
        this.left = left;
        this.right = right;
    }
    
    public Text getLeftElement(){
        return left;
    }
    public Text getRightElement(){
        return right;
    }

    public PairOfStrings(Text left, Text right) {
        this.left = left;
        this.right = right;
    }

    @Override
    public void write(DataOutput out) throws IOException {
        left.write(out);
        right.write(out);
    }

    @Override
    public void readFields(DataInput in) throws IOException {
        left.readFields(in);
        right.readFields(in);
    }

    @Override
    public int compareTo(PairOfStrings pair) {
        int compareValue = this.left.compareTo(pair.left);
        if (compareValue == 0) {
            compareValue = right.compareTo(pair.right);
        }
        return compareValue; 		// to sort ascending 
        //return -1*compareValue;     // to sort descending 
    }
    public String toString(){
        return left+", "+right;
    }
}
