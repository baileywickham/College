import java.io.IOException;
import java.util.SortedSet;
import java.util.TreeSet;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

/**
 *  Reducer's input are local top N from all mappers.
 *  We have a single reducer, which creates the final top N.
 * 
 * @author Mahmoud Parsian
 *
 */
public class TopNReducer  extends
   Reducer<NullWritable, Text, NullWritable, Text> {

   private int n = TopNMapper.DEFAULT_N; // default
   private SortedSet<Record> top = new TreeSet<>();

   @Override
   public void reduce(NullWritable key, Iterable<Text> values, Context context) 
      throws IOException, InterruptedException {
      for (Text value : values) {
         String valueAsString = value.toString().trim();
         String[] tokens = valueAsString.split(",");
         double weight =  Double.parseDouble(tokens[2]);
         top.add(new Record(Integer.parseInt(tokens[0]),tokens[1],weight));
         // keep only top N
         if (top.size() > n) {
            top.remove(top.last());
         }
      }
      
      for(Record r : top){
          context.write(NullWritable.get(), new Text(r.toString()));
      }
   }
   
   @Override
   protected void setup(Context context) 
      throws IOException, InterruptedException {
      this.n = context.getConfiguration().getInt("N", TopNMapper.DEFAULT_N); // default is top 10
   }


}

