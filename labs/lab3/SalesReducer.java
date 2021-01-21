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
            String[] tokens = sale.toString().trim().split(",");
            out = out + String.format("%s, %s, %s\n", tokens[3].trim(),
                    tokens[2].trim(), tokens[4].trim());
        }
        context.write(date, new Text(out));
    }
}

