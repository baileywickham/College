import org.apache.hadoop.io.WritableComparable;
import org.apache.hadoop.io.WritableComparator;

/**
 * This is an plug-in class. The SecondarySortGroupComparator class indicates
 * how to compare the userIDs.
 *
 * @author Mahmoud Parsian
 *
 */
public class LeftJoinGroupComparator
        extends WritableComparator {

    protected LeftJoinGroupComparator() {
        super(PairOfStrings.class, true);
    }

    @Override
    public int compare(WritableComparable wc1, WritableComparable wc2) {
        PairOfStrings pair = (PairOfStrings) wc1;
        PairOfStrings pair2 = (PairOfStrings) wc2;
        return pair.getLeftElement().compareTo(pair2.getLeftElement());
    }

}
