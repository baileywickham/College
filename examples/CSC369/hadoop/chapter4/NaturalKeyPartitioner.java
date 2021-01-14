
import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.mapreduce.Partitioner;


public class NaturalKeyPartitioner extends 
                    Partitioner<CompositeKey, DoubleWritable> {
 
    @Override
    public int getPartition(CompositeKey key, DoubleWritable val, int numPartitions) {
        int hash = key.getSymbol().hashCode();
        int partition = hash % numPartitions;
        return partition;
    }
 
}

