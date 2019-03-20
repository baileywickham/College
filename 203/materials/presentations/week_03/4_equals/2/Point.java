

public class Point {

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
            return this.x == op.x && this.y == op.y;
        } else {
            return false;
        }
    }
}
