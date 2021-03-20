import org.apache.hadoop.io.WritableComparable;
import org.apache.hadoop.io.WritableComparator;

/** 
 * The DateTemperatureGroupingComparator class
 * enable us to compare two DateTemperaturePair 
 * objects. This class is needed for sorting 
 * purposes.
 *
 * @author Mahmoud Parsian
 *
 */
public class SecondarySortGroupingComparator 
   extends WritableComparator {

    protected SecondarySortGroupingComparator() {
        super(CGrade.class, true);
    }

    @Override
    public int compare(WritableComparable wc1, WritableComparable wc2) {
        CGrade pair = (CGrade) wc1;
        CGrade pair2 = (CGrade) wc2;
        return pair.grade.compareTo(pair2.grade);
    }
}
