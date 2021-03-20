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
public class CGrade
    implements Writable, WritableComparable<CGRade> {

    public final Text name = new Text();
    public final Text id = new Text();
    public final Text clas = new Text();
    public final Text grade = new Text();


    public CGrade() {
    }

    public CGrade(String name, String id, String clas, String grade) {
        this.name.set(name);
        this.id.set(id);
        this.clas.set(clas);
        this.grade.set(grade);
    }

    @Override
    public void write(DataOutput out) throws IOException {
        name.write(out);
        id.write(out);
        clas.write(out);
        grade.write(out);
    }

    @Override
    public void readFields(DataInput in) throws IOException {
        name.readFields(in);
        id.readFields(in);
        clas.readFields(in);
        grade.readFields(in);
    }

    @Override
    public int compareTo(CGrade pair) {
        if(id.compareTo(pair.id)==0){
            return grade.compareTo(pair.temperature);
        }
        return name.compareTo(pair.name);
    }
}

