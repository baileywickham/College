
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;
import java.util.Iterator;

public class LeftJoinReducer 
	extends Reducer<PairOfStrings, PairOfStrings, Text, Text> {

   Text productID = new Text();
   Text locationID = new Text("undefined");
   
   @Override
   public void reduce(PairOfStrings key, Iterable<PairOfStrings> values, Context context) 
      throws java.io.IOException, InterruptedException {
      Iterator<PairOfStrings> iterator = values.iterator();
      if (iterator.hasNext()) {
      	 // firstPair must be location pair
      	 PairOfStrings firstPair = iterator.next(); 
      	 System.out.println("firstPair="+firstPair.toString());
         if (firstPair.getLeftElement().toString().equals("L")) {
            locationID.set(firstPair.getRightElement());
         } else {
             productID.set(firstPair.getRightElement());
             context.write(productID,new Text("undefined"));
             locationID = new Text("undefined");
         }
      } 	 
      	       	 
      while (iterator.hasNext()) {
      	 // the remaining elements must be product pair
      	 PairOfStrings productPair = iterator.next(); 
      	 System.out.println("productPair="+productPair.toString());
         productID.set(productPair.getRightElement());
         context.write(productID, locationID);
      }
   }
}

