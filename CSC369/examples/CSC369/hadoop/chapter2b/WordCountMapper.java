import java.io.IOException;
//
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Mapper.Context;
//
import org.apache.commons.lang.StringUtils;

/**
 * Word Count Mapper
 *
 * For each line of input, break the line into words
 * and emit them as (<b>word</b>, <b>1</b>).
 *
 * @author Mahmoud Parsian
 *
 */
public class WordCountMapper
    extends Mapper<LongWritable, Text, Text, IntWritable> {

    private static final int DEFAULT_IGNORED_LENGTH = 3; // default
    private int N = DEFAULT_IGNORED_LENGTH; 
    private final Text reducerKey = new Text();

    // called once at the beginning of the task.   
    @Override
    protected void setup(Context context)
       throws IOException,InterruptedException {
       this.N = context.getConfiguration().getInt("word.count.ignored.length", 
                                                  DEFAULT_IGNORED_LENGTH);
    }

    @Override
    public void map(LongWritable key, Text value, Context context)
       throws IOException, InterruptedException {
      
       String line = value.toString().trim();        
       if ((line == null) || (line.length() < this.N)) {
           return;
       }
        String[] tokens = line.split("[^a-zA-Z0-9]+");
        
       
       
       if (tokens == null) {
           return;
       }
        
       for (String word : tokens) {
            if (word.length() < N) {
               continue;
            }
            context.write(new Text(word), new IntWritable(1));
       }
    }
   
}


