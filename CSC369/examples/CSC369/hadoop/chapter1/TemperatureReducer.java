import java.io.*;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.*;
import org.apache.hadoop.mapreduce.Reducer.*;


public class TemperatureReducer 
  extends Reducer<Text, IntWritable, Text, DoubleWritable> {
   
   @Override
   public void reduce(Text date, 
	Iterable<IntWritable> temperatures, Context context) 
        throws IOException, InterruptedException {
        double sum=0;        
        int count = 0;
        for(IntWritable el: temperatures){
          sum += el.get();
          count += 1;
        } 
        context.write(date, new DoubleWritable(sum/count));
    }
}

