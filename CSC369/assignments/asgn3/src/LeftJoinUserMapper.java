import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.commons.lang.StringUtils;

import java.util.ArrayList;

public class LeftJoinUserMapper
        extends Mapper<LongWritable, Text, PairOfStrings, PairOfStrings> {

    @Override
    public void map(LongWritable key, Text value, Context context)
            throws java.io.IOException, InterruptedException {
        String[] tokens = StringUtils.split(value.toString(), ",");
        if (tokens.length == 5) {
            String user_id = tokens[0].trim();
            String name = tokens[1].trim();
            String addr = tokens[2].trim();
            int phone = Integer.parseInt(tokens[3].trim());
            ArrayList<String> classes = new ArrayList<String>(tokens[4].replace("(", "").replace(")", "").split(" "));
            Student s = new Student(user_id, name, addr, phone, classes);
            PairOfStrings outputKey = new PairOfStrings();
            PairOfStrings outputValue = new PairOfStrings();
            outputKey.set(user_id, new Text("1"));
            outputValue.set(new Text("L"), location_id);
            context.write(outputKey, outputValue);
        }
    }
}
