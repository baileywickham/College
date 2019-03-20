
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
        if (other instanceof Point) {
            Point op = (Point) other;
            return x == op.x && y == op.y;
        } else {
            return false;
        }
    }

    @Override
    public int hashCode() {
        // return 42;
        // return x*97 + y;
        return java.util.Objects.hash(x, y);
    }
    /*
    */

    public static void main(String[] args) {

        System.out.println();

        HashMap<Point, String> map = new HashMap<Point, String>();

        map.put(new Point(1, 2), "foo");
        map.put(new Point(1, 2), "bar");
        map.put(new Point(1, 2), "glorp");
        System.out.println("1:  map.size() is " + map.size());

        for (int i = 0; i < 25000; i++) {
            map.put(new Point(i, -i), "foo");
            map.put(new Point(i, -i), "bar");
            map.put(new Point(i, -i), "glorp");
            if (i % 1000 == 0) {
                System.out.print(".");
                System.out.flush();
            }
        }
        System.out.println();
        System.out.println("2:  map.size() is " + map.size());
        System.out.println();
    }
}
