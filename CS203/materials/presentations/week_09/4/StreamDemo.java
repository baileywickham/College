
import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.stream.Collectors;

/**
 * Program to show that streams don't have a guaranteed order.
 */


public class StreamDemo {

    private static final Random random = new Random();

    private static final List<Integer> finishedOrder
        = new ArrayList<Integer>(100);
    private static long totalWorkingTime = 0;

    private static String getNumberString(int i) {
        long start = System.currentTimeMillis();
        int delay = random.nextInt(100) + 100;  // 100-200 ms of work
        long now = start;
        while (now < start + delay) {
            now = System.currentTimeMillis();
        }
        synchronized(finishedOrder) {
            finishedOrder.add(i);
            totalWorkingTime += now - start;
        }
        return "" + i;
    }

    public static void main(String[] args) {

        long start = System.currentTimeMillis();

        List<Integer> numbers = new ArrayList<Integer>();
        for (int i = 0; i < 100; i++) {
            numbers.add(i);
        }

        List<String> evenNumbers = 
            numbers.parallelStream()
                .filter(i -> i % 2 == 0)
                .map(i -> getNumberString(i))
                .collect(Collectors.toList());

        System.out.println();
        System.out.println("Result:");
        System.out.println(evenNumbers);
        System.out.println();
        synchronized(finishedOrder) { }
        System.out.println("finishedOrder:");
        System.out.println(finishedOrder);

        long now = System.currentTimeMillis();
        System.out.println();
        System.out.println("Total elapsed time:  " + (now - start) + " ms.");
        System.out.println("Total working time:  " + totalWorkingTime + " ms.");
        System.out.println();
    }
}

