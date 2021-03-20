import java.io.*;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.*;
import org.apache.hadoop.mapreduce.Reducer.*;


public class TemperatureReducer 
  extends Reducer<Text, SumCountPair, Text, DoubleWritable> {
   
   @Override
   public void reduce(Text date, 
	Iterable<SumCountPair> temperatures, Context context) 
        throws IOException, InterruptedException {
        double sum=0;        
        int count = 0;
        for(SumCountPair el: temperatures){
          sum += el.getSum();
          count += el.getCount();
        } 
        context.write(date, new DoubleWritable(sum/count));
    }
}
