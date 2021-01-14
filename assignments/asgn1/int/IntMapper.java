import java.io.*;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.*;
import org.apache.hadoop.mapreduce.Mapper.*;
import org.apache.log4j.Logger;

public class IntMapper extends
          Mapper<LongWritable, Text, Text, IntWritable> {
   private static Logger THE_LOGGER = Logger.getLogger(IntDriver.class);

   @Override
   public void map(LongWritable key, Text value, Context context)
         throws IOException, InterruptedException {
      THE_LOGGER.debug("I AM IN LOGGER");
      String valueAsString = value.toString().trim();
      if (Integer.parseInt(valueAsString) % 3 == 0) {
        context.write(new Text("1"), new IntWritable(Integer.parseInt(valueAsString)));
      } else {
        context.write(new Text("0"), new IntWritable(Integer.parseInt(valueAsString)));
      }
   }
}


