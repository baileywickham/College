import java.io.*;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.*;
import org.apache.hadoop.mapreduce.Reducer.*;


public class IntReducer
  extends Reducer<Text, IntWritable, Text, IntWritable> {

   @Override
   public void reduce(Text date,
	Iterable<IntWritable> count, Context context)
        throws IOException, InterruptedException {
        int c = 0;
        for(IntWritable el: count){
          c += 1;
        }
        context.write(date, new IntWritable(c));
    }
}

