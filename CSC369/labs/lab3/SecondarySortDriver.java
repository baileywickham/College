import org.apache.log4j.Logger;

import org.apache.hadoop.mapreduce.*;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.util.Tool;
import org.apache.hadoop.util.ToolRunner;
import org.apache.hadoop.io.*;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.conf.Configuration;

public class SecondarySortDriver extends Configured implements Tool {

    private static Logger theLogger = Logger.getLogger(SecondarySortDriver.class);

    @Override
    public int run(String[] args) throws Exception {


        Job job = Job.getInstance();
        job.setJarByClass(SecondarySortDriver.class);
        job.setJobName("SecondarySortDriver");

        FileInputFormat.setInputPaths(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));

        job.setMapOutputKeyClass(Sale.class);
        job.setMapOutputValueClass(Text.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(Text.class);


        job.setMapperClass(SecondarySortMapper.class);
        job.setReducerClass(SecondarySortReducer.class);
        job.setPartitionerClass(SecondarySortPartitioner.class);
        job.setGroupingComparatorClass(SecondarySortGroupingComparator.class);
        job.setSortComparatorClass(SecondarySortSortingComparator.class);
	//job.setNumReduceTasks(3);
        boolean status = job.waitForCompletion(true);
        return status ? 0 : 1;
    }

    public static void main(String[] args) throws Exception {
        if (args.length != 2) {
            throw new IllegalArgumentException("SecondarySortDriver <input-dir> <output-dir>");
        }

        int returnStatus = submitJob(args);

        System.exit(returnStatus);
    }

    public static int submitJob(String[] args) throws Exception {
        int returnStatus = ToolRunner.run(new SecondarySortDriver(), args);
        return returnStatus;
    }
}
