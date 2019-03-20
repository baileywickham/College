

public class Main {

    public static void main(String[] args) {

        Pair<Object> pair1 = new Pair<Object>("foo", "bar");

        Pair<Object> pair2 = new Pair<Object>("glorp", 37);

        Pair<String> pair3 = new Pair<String>(new String("foo"), "bar");

        System.out.println(pair1 + " hashCode is " + pair1.hashCode());

        printEquals(pair1, pair2);
        printEquals(pair1, pair3);
        printEquals(pair2, pair3);
        System.out.println("equals:  " + (pair1.equals(pair3)));
    }

    static void printEquals(Object o1, Object o2) {

        System.out.println(o1 + ".equals(" + o2 + ") is " + o1.equals(o2));

    }
}
