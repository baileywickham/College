import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.commons.lang.StringUtils;

public class LeftJoinUserMapper
        extends Mapper<LongWritable, Text, PairOfStrings, PairOfStrings> {

    @Override
    public void map(LongWritable key, Text value, Context context)
            throws java.io.IOException, InterruptedException {
        String[] tokens = StringUtils.split(value.toString(), ",");
        if (tokens.length == 2) {
            Text user_id = new Text(tokens[0].trim());
            Text location_id = new Text(tokens[1].trim());
            PairOfStrings outputKey = new PairOfStrings();
            PairOfStrings outputValue = new PairOfStrings();
            outputKey.set(user_id, new Text("1"));
            outputValue.set(new Text("L"), location_id);
            context.write(outputKey, outputValue);
        }
    }
}
