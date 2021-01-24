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
public class Sale
    implements Writable, WritableComparable<Sale> {

    private final Text date = new Text();
    private final Text time = new Text();
    private final Text id = new Text();


    public Sale(String date, String time, String id) {
        this.date.set(date);
        this.time.set(time);
        this.id.set(id);
    }


    @Override
    public void write(DataOutput out) throws IOException {
        date.write(out);
        time.write(out);
        id.write(out);
    }

    @Override
    public void readFields(DataInput in) throws IOException {
        date.readFields(in);
        time.readFields(in);
        id.readFields(in);
    }

    @Override
    public int compareTo(Sale o) {
        if(date.compareTo(o.getDate())==0){
            return time.compareTo(o.time);
        }
        return date.compareTo(o.getDate());
    }

    public Text getDate() {
        return date;
    }

    public Text getId() {
        return id;
    }
    public Text getTime() {
        return time;
    }
}

