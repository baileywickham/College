import java.io.*;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.*;
import org.apache.hadoop.mapreduce.Reducer.*;


public class IntReducer
  extends Reducer<Text, IntWritable, Text, DoubleWritable> {

   @Override
   public void reduce(Text isDivByThree,
	Iterable<IntWritable> count, Context context)
        throws IOException, InterruptedException {
        double sum=0;
        int c = 0;
        for(IntWritable el: count){
          c += 1;
        }
        context.write(isDivByThree, new IntWritable(c));
    }
}

