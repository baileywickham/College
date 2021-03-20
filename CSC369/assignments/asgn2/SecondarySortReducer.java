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
    extends Reducer<CGrade, Text, Text, Text> {

    @Override
    protected void reduce(CGrade key, Iterable<Text> values, Context context)
    	throws IOException, InterruptedException {
    	String result="";
    	for (Text value : values) {
            result += (value.toString()+",");
	}
        result = result.substring(0, result.length()-1);
        context.write(key.clas, new Text(result));
    }
}
