

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
            Point otherP = (Point) other;
            return x == otherP.x && y == otherP.y;
        } else {
            return false;
        }
    }

    @Override
    public String toString() {
        return super.toString() + "(" + x + "," + y + ")";
    }

}
