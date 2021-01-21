import java.io.*;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.*;
import org.apache.hadoop.mapreduce.Mapper.*;
import org.apache.log4j.Logger;

public class SalesMapper extends
          Mapper<LongWritable, Text, Text, Text> {
   private static Logger THE_LOGGER = Logger.getLogger(SalesDriver.class);

   @Override
   public void map(LongWritable key, Text value, Context context)
         throws IOException, InterruptedException
     {

      THE_LOGGER.debug("I AM IN LOGGER");


      String valueAsString = value.toString().trim().replace("\n", "");
      String[] tokens = valueAsString.split(" ");

      if (tokens.length != 5) {
         return;
      }
      context.write(new Text(tokens[1].trim()), new Text(valueAsString));
   }
}


