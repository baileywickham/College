
import java.io.File;
import java.util.Scanner;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.Set;
import java.io.IOException;

/**
 * Program to count up the different words in the Mabinogian using
 * a traditional loop over the input text.  We do one thing that's a
 * little odd, perhaps:  We first read all of the elements into a
 * list.  We do this so that we can compare the traditional version with
 * the streams version.
 */


public class Traditional extends Counter {

    @Override
    protected Map<String, Integer> countWords() {
        Map<String, Integer> wordCounts = new HashMap<String, Integer>();
        for (String word : words) {

            // Filter:
            if (word.length() > 3) {

                // Map:
                word = word.toLowerCase();
                doSomethingThatTakesTime(20173);

                // Reduce:

                Integer value = wordCounts.get(word);
                if (value == null) {
                    wordCounts.put(word, 1);
                } else {
                    wordCounts.put(word, value + 1);
                }
            }
        }
        return wordCounts;
    }



    public static void main(String[] args) {
        Traditional t = new Traditional();
        try {
            t.run();
        } catch (IOException ex) {
            ex.printStackTrace();
            System.exit(1);
        }
    }
}

