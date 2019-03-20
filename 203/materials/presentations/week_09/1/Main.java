

import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;
import java.math.BigDecimal;

public class Main {

    public static double mean(List<? extends Number> list) {
        double total = 0.0;
        for (Number element : list) {
            total += element.doubleValue();
        }
        return total / (double) list.size();
    }

    public static void main(String[] args) {
        List<Number> numList = new ArrayList<>();
        numList.add(new BigDecimal("0.1"));
        numList.add(2.2);
        numList.add(3);
        System.out.println(
                "The mean value of " + numList + " is " + mean(numList));

/*
        List<Integer> intList = Arrays.asList(3, 4, 6);
        System.out.println(
                "The mean value of " + intList + " is " + mean(intList));

        List<Double> doubleList = Arrays.asList(3.5, 2.5, 4.0);
        System.out.println(
                "The mean value of " + doubleList + " is " + mean(doubleList));

        List<BigDecimal> decList = Arrays.asList(
            new BigDecimal("0.001"),
            new BigDecimal("0.002"),
            new BigDecimal("0.003")
        );
        System.out.println(
                "The mean value of " + decList + " is " + mean(decList));
*/
    }
}
