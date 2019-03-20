

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

        Point p1 = new Point(1, 2);
        Point p2 = new Point(3, 4);
        Point p3 = new Point(1, 2);

        println("1:  " + (p1.equals(p2)));
        println("2:  " + (p2.equals(p1)));
        println("3:  " + (p1.equals(p3)));
        println("4:  " + (p3.equals(p1)));
        println();

        Point3D p3d1 = new Point3D(1, 2, 3);
        Point3D p3d2 = new Point3D(1, 2, 3);
        println("5:  " + p3d1.equals(p3d2));
        println("6:  " + p3d1.equals(p1));
        println("7:  " + p1.equals(p3d1));
    }
}
