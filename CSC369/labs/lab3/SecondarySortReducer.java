import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.*;

import java.io.IOException;

/**
 * SecondarySortReducer implements the reduce() function for
 * the secondary sort design pattern.
 *
 * @author Mahmoud Parsian
 *
 */
public class SecondarySortReducer
    extends Reducer<Sale, Text, Text, Text> {

    @Override
    protected void reduce(Sale key, Iterable<Text> values, Context context)
    	throws IOException, InterruptedException {
    	String result="";
    	for (Text value : values) {
            result += (value.toString()+", ");
	}
        result = result.substring(0, result.length()-2);
        context.write(key.getDate(), new Text(result));
    }
}
