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
   extends Partitioner<Sale, Text> {

    @Override
    public int getPartition(Sale sale,
                            Text time,
                            int numberOfPartitions) {
    	// make sure that partitions are non-negative
        return Math.abs(sale.getDate().hashCode() % numberOfPartitions);
    }
}
