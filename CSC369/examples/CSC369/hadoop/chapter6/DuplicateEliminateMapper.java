import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.*;
import org.apache.commons.lang.*;

public class DuplicateEliminateMapper 
   extends Mapper<LongWritable, Text, PairOfStrings, NullWritable> {
   /**
    * @param key is system generated, ignored
    * @param value is one uer record: <project_id><TAB><location_id>
    */
   @Override
   public void map(LongWritable key, Text value, Context context) 
      throws java.io.IOException, InterruptedException {
      String[] tokens = StringUtils.split(value.toString(), "\t");
      if (tokens.length == 2) {
      	 Text project = new Text(tokens[0].trim());
         Text location = new Text(tokens[1].trim());  
         context.write(new PairOfStrings(project,location),NullWritable.get());
      }
   }
}
