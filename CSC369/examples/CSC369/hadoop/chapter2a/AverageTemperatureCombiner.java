import java.io.IOException;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.Reducer.Context;

public class AverageTemperatureCombiner
    extends Reducer<Text, SumCountPair, Text, SumCountPair> {
   
    @Override
    public void reduce(Text key, Iterable<SumCountPair> values, Context context)
       throws IOException, InterruptedException {
       int sum = 0;
       int count = 0;
       for (SumCountPair el : values) {
       	 sum += el.getSum();
       	 count+=el.getCount();
       }
       context.write(key, new SumCountPair(sum,count));
    }   
}

