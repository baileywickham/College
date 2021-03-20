import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.commons.lang.StringUtils;


/** 
 * LeftJoinTransactionMapper implements the map() function for 
 * the transactions part of "left join" design pattern.
 *
 * @author Mahmoud Parsian
 *
 */
public class LeftJoinTransactionMapper 
	extends Mapper<LongWritable, Text, PairOfStrings, PairOfStrings> {
	
   PairOfStrings outputKey = new PairOfStrings();
   PairOfStrings outputValue = new PairOfStrings();
  
   @Override 
   public void map(LongWritable key, Text value, Context context) 
      throws java.io.IOException, InterruptedException {
      String[] tokens = StringUtils.split(value.toString(), ",");
      Text productID = new Text(tokens[1].trim());
      Text userID = new Text(tokens[2].trim());
      outputKey.set(userID, new Text("2"));
      outputValue.set(new Text("P"), productID);
      context.write(outputKey, outputValue);
   }
}

