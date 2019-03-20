

public class Main {

    private static void println() {
        System.out.println();
    }

    private static void println(String s) {
        System.out.println(s);
    }

    public static void main(String[] args) {
        for (int i = 0; i < 24; i++) {
            println();
        }

        Object o1 = new Object();
        Object o2 = new Object();

        println("1:  " + (o1 == o2));
        println("2:  " + (o1.equals(o2)));
        println();

        Point p1 = new Point(1, 2);
        Point p2 = new Point(3, 4);
        Point p3 = new Point(1, 2);

        println("3:  " + (p1 == p2));
        println("4:  " + (p2 == p1));
        println("5:  " + (p1.equals(p2)));
        println("6:  " + (p2.equals(p1)));
        println("7:  " + (p1.equals(p3)));
        println("8:  " + (p3.equals(p1)));
        println();

        println("B:  " + o1.equals(p1));
        println("C:  " + p1.equals(o1));

// NOTE TO SELF:  sections 1,2 stopped at implementing .equals

        println("9:  " + o1);
        println("A:  " + p1);
        println();
        
    }
}

