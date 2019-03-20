
import java.util.HashMap;

public final class Point {

    public final int x;
    public final int y;

    public Point(int x, int y) {
        this.x = x;
        this.y = y;
    }

    @Override
    public boolean equals(Object other) {
        // All points are .equals() to eachoter (and to any object).
        // DO NOT DO THIS!
        return true;
    }

    @Override
    public int hashCode() {
        return x*97+ y;
    }

    public static void main(String[] args) {

        System.out.println();

        HashMap<Point, String> map = new HashMap<Point, String>();

        for (int i = 0; i < 2500000; i++) {
            map.put(new Point(i*512, -i*512), "foo");
            if (i % 50000 == 0) {
                System.out.print(".");
                System.out.flush();
            }
        }
        System.out.println();
        System.out.println("map.size() is " + map.size());
        System.out.println();
    }
}
