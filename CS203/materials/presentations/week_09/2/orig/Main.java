

import java.util.List;
import java.util.ArrayList;
import java.math.BigDecimal;

public class Main {

    public static void addSeven (List<Integer> list) {
        list.add(7);
    }

    public static void main(String[] args) {
        List<Integer> intList = new ArrayList<Integer>();
        intList.add(3);
        addSeven(intList);
        addSeven(intList);
        System.out.println("1:  " + intList);

        /*
        List<Number> numberList = new ArrayList<Number>();
        numberList.add(3.7);
        numberList.add(new BigDecimal("5.9"));
        addSeven(numberList);
        addSeven(numberList);
        System.out.println("1:  " + numberList);
        */
    }
}
