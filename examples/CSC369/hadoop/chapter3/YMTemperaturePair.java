import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.WritableComparable;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

/** 
 * The DateTemperaturePair class enable us to represent a 
 * composite type of (yearMonth, day, temperature). To persist
 * a composite type (actually any data type) in Hadoop, it has 
 * to implement the org.apache.hadoop.io.Writable interface.
 * 
 * To compare composite types in Hadoop, it has to implement 
 * the org.apache.hadoop.io.WritableComparable interface.
 *
 * @author Mahmoud Parsian
 *
 */
public class YMTemperaturePair 
    implements Writable, WritableComparable<YMTemperaturePair> {

    private final Text yearMonth = new Text(); 
    private final IntWritable temperature = new IntWritable();


    public YMTemperaturePair() {
    }

    public YMTemperaturePair(String yearMonth, int temperature) {
        this.yearMonth.set(yearMonth);
        this.temperature.set(temperature);
    }

    @Override
    public void write(DataOutput out) throws IOException {
        yearMonth.write(out);
        temperature.write(out);
    }

    @Override
    public void readFields(DataInput in) throws IOException {
        yearMonth.readFields(in);
        temperature.readFields(in);
    }

    @Override
    public int compareTo(YMTemperaturePair pair) {
        if(yearMonth.compareTo(pair.getYearMonth())==0){
            return temperature.compareTo(pair.temperature);
        }
        return yearMonth.compareTo(pair.getYearMonth());
    }

    
    public Text getYearMonth() {
        return yearMonth;
    }       

    public IntWritable getTemperature() {
        return temperature;
    }
}

