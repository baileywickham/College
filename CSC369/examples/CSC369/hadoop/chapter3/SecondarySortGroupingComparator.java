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
        super(YMTemperaturePair.class, true);
    }

    @Override
    public int compare(WritableComparable wc1, WritableComparable wc2) {
        YMTemperaturePair pair = (YMTemperaturePair) wc1;
        YMTemperaturePair pair2 = (YMTemperaturePair) wc2;
        return pair.getYearMonth().compareTo(pair2.getYearMonth());
    }
}
