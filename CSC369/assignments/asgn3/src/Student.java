import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.WritableComparable;
import org.apache.hadoop.io.ArrayWritable;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.util.ArrayList;

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
public class Student
    implements Writable, WritableComparable<Student> {

    public final Text name = new Text();
    public final IntWritable id = new IntWritable();
    public final Text address = new Text();
    public final IntWritable phoneNumeber = new IntWritable();
    public final ArrayWritable classes = new ArrayWritable(String.class);
    public final Text grade = new Text();


    public Student() {
    }

    public Student(String id, String name, String addr, int phone, ArrayList<String> classes) {
        this.name.set(name);
        this.id.set(id);
        this.phoneNumeber.set(phone);
        this.address.set(addr);
        this.classes.readFields(classes);
        this.grade.set(grade);
    }

    @Override
    public void write(DataOutput out) throws IOException {
        name.write(out);
        id.write(out);
        classes.write(out);
        grade.write(out);
    }

    @Override
    public void readFields(DataInput in) throws IOException {
        name.readFields(in);
        id.readFields(in);
        classes.readFields(in);
        grade.readFields(in);
    }

    @Override
    public int compareTo(Student pair) {
        if(id.compareTo(pair.id)==0){
            return grade.compareTo(pair.temperature);
        }
        return name.compareTo(pair.name);
    }
}

