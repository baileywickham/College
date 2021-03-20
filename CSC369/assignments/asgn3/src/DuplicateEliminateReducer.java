import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.io.NullWritable;

public class DuplicateEliminateReducer
        extends Reducer<PairOfStrings, NullWritable, PairOfStrings, NullWritable> {

    Text productID = new Text();
    Text locationID = new Text("undefined");

    @Override
    public void reduce(PairOfStrings key, Iterable<NullWritable> values, Context context)
            throws java.io.IOException, InterruptedException {
        context.write(key, NullWritable.get());
    }
}
