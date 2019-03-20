
import java.io.File;
import java.io.IOException;
import java.util.Scanner;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * Program to count up the different words in the Mabinogian using
 * the streams API.
 */


public class Streams extends Counter {

    @Override
    protected Map<String, Integer> countWords() {
        return words.parallelStream()
                    .filter(word -> word.length() > 3)
                    .map(word -> {
                        doSomethingThatTakesTime(20173);
                        return word.toLowerCase();
                    })
                    .collect(Collectors.groupingBy(
                        word -> word,
                        Collectors.summingInt(word -> 1)));
    }

    public static void main(String[] args) {
        Streams main = new Streams();
        try {
            main.run();
        } catch (IOException ex) {
            ex.printStackTrace();
            System.exit(1);
        }
    }
}

