import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.*;
import org.apache.commons.lang.*;

public class CountMapper
        extends Mapper<LongWritable, Text, Text, IntWritable> {

  @Override
  public void map(LongWritable key, Text value, Context context)
          throws java.io.IOException, InterruptedException {
    String[] tokens = StringUtils.split(value.toString(), ",");
    if (tokens.length == 2) {
      Text project = new Text(tokens[0].trim());
      if (tokens[1].trim().equals("undefined")) {
        context.write(project, new IntWritable(0));
      } else {
        context.write(project, new IntWritable(1));
      }
    }
  }
}
