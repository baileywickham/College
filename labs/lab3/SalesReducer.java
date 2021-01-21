import java.io.*;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.*;
import org.apache.hadoop.mapreduce.Reducer.*;


public class SalesReducer
  extends Reducer<Text, Text, Text, Text> {

   @Override
   public void reduce(Text date,
	Iterable<Text> sales, Context context)
        throws IOException, InterruptedException {
        String out = new String();
        for(Text sale: sales){
            String[] tokens = sale.toString().split(" ");
            out = out + String.format("%s %s, %s, %s\n", tokens[1], tokens[2], tokens[3], tokens[4]);
        }
        context.write(date, new Text(out));
    }
}

