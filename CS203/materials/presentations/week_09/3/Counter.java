

import java.io.File;
import java.util.Scanner;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.Set;
import java.io.IOException;


/**
 * An abastract class for building programs that count the words in
 * the Marbinogion.
 */

abstract class Counter {

    // Our input
    protected List<String> words = new ArrayList<String>();

    protected void readMarbingion() throws IOException {
        File f = new File("mabinogian.txt");
        Scanner scanner = new Scanner(f);
        try {
            while (scanner.hasNext()) {
                String word = scanner.next();
                if (word  == null) {
                    break;
                }
                words.add(scanner.next());
            }
        } finally {
            scanner.close();
        }
        System.out.println("Read " + words.size() + " words from " + f + ".");
    }

    // Do something that takes some time.  We calculate if number
    // is prime, using an intentionally dumb algorithm.
    protected boolean doSomethingThatTakesTime(int number) {
        for (int i = 2; i < number; i ++) {
            if (number % i == 0) {
                return false;
            }
        }
        return true;
    }

    abstract protected Map<String, Integer> countWords();

    public void run() throws IOException {
        readMarbingion();
        long start = System.nanoTime();
        Map<String, Integer> wordCounts = countWords();
        long duration = System.nanoTime() - start;
        System.out.println("I spent " + (duration / 1000000)  
                           + " ms counting words.");
        System.out.println("There are " + wordCounts.size() 
                           + " distinct words.");
        int numPrinted = 0;
        List<Map.Entry<String, Integer>> entries 
            = new ArrayList<Map.Entry<String, Integer>>(wordCounts.entrySet());
        entries.sort((a, b) -> b.getValue().compareTo(a.getValue()));
        for (Map.Entry<String, Integer> entry : entries) {
            System.out.println("  " + entry.getValue() 
                               + ":\t" + entry.getKey());
            numPrinted++;
            if (numPrinted >= 10) {
                break;
            }
        }
    }
}

