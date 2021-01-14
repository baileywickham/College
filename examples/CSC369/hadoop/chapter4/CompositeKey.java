import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import jdk.nashorn.internal.ir.Symbol;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.io.WritableComparable;

/**
 *
 * @author lubo
 */
public class CompositeKey implements Writable, WritableComparable<CompositeKey> {

    private final Text stockSymbol = new Text();
    private final Text date = new Text();

    public CompositeKey() {
    }

    public CompositeKey(String stockSymbol, String date) {
        this.stockSymbol.set(stockSymbol);
        this.date.set(date);
    }

    @Override
    public void write(DataOutput out) throws IOException {
        stockSymbol.write(out);
        date.write(out);
    }

    @Override
    public void readFields(DataInput in) throws IOException {
        stockSymbol.readFields(in);
        date.readFields(in);
    }

    @Override
    public int compareTo(CompositeKey other) {
        int result = stockSymbol.compareTo(other.stockSymbol);
        if (0 == result) {
            result = -1 * date.compareTo(other.date);
        } 
        return result;
    }

    public String getSymbol() {
        return stockSymbol.toString();
    }
    public String getDate(){
        return date.toString();
    }
}
