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
            String[] tokens = sale.toString().strip().split(",");
            out = out + String.format("%s %s %s %s\n", date, tokens[2].strip(),
                    tokens[3].strip(), tokens[4].strip());
        }
        context.write(date, new Text(out));
    }
}

