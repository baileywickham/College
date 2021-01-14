import org.apache.hadoop.mapreduce.*;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.util.Tool;
import org.apache.hadoop.util.ToolRunner;
import org.apache.hadoop.io.*;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.conf.Configuration;

/**
 * SecondarySortDriver is driver class for submitting secondary sort job to
 * Hadoop.
 *
 * @author Mahmoud Parsian
 *
 */
public class Driver extends Configured implements Tool {


    @Override
    public int run(String[] args) throws Exception {

        
        Job job = Job.getInstance();
        job.setJarByClass(Driver.class);
        job.setJobName("SecondarySortDriver");

        FileInputFormat.setInputPaths(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));
       
        job.setMapOutputKeyClass(CompositeKey.class);
        job.setMapOutputValueClass(Text.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(Text.class);

        
        job.setMapperClass(SecondarySortMapper.class);
        job.setReducerClass(SecondarySortReducer.class);
        job.setPartitionerClass(NaturalKeyPartitioner.class);
        job.setGroupingComparatorClass(NaturalKeyGroupingComparator.class);
        job.setSortComparatorClass(CompositeKeyComparator.class);
        boolean status = job.waitForCompletion(true);
        return status ? 0 : 1;
    }

    /**
     * The main driver for word count map/reduce program. Invoke this method to
     * submit the map/reduce job.
     *
     * @throws Exception When there is communication problems with the job
     * tracker.
     */
    public static void main(String[] args) throws Exception {
        if (args.length != 2) {
            throw new IllegalArgumentException("SecondarySortDriver <input-dir> <output-dir>");
        }

        int returnStatus = submitJob(args);
        System.exit(returnStatus);
    }

    public static int submitJob(String[] args) throws Exception {
        int returnStatus = ToolRunner.run(new Driver(), args);
        return returnStatus;
    }
}
