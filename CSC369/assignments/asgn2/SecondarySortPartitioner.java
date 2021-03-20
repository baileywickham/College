import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.*;

/** 
 * The DateTemperaturePartitioner is a custom partitioner class,
 * whcih partitions data by the natural key only (using the yearMonth).
 * Without custom partitioner, Hadoop will partition your mapped data 
 * based on a hash code.
 *
 * In Hadoop, the partitioning phase takes place after the map() phase 
 * and before the reduce() phase
 *
 * @author Mahmoud Parsian
 *
 */
public class SecondarySortPartitioner 
   extends Partitioner<CGrade, Text> {

    @Override
    public int getPartition(CGrade pair,
                            Text cgrade,
                            int numberOfPartitions) {
    	// make sure that partitions are non-negative
        return Math.abs(pair.name.hashCode() % numberOfPartitions);
    }
}
