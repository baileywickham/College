import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.io.IntWritable;

public class CountReducer
        extends Reducer<Text, IntWritable, Text, IntWritable> {

    @Override
    public void reduce(Text key, Iterable<IntWritable> values, Context context)
            throws java.io.IOException, InterruptedException {
        int sum = 0;
        for(IntWritable el: values){
            sum += el.get();
        }
        context.write(key, new IntWritable(sum));
    }
}
