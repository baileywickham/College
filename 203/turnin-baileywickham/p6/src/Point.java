
/**
 * Immutable object representing a point on the VirtualWorld grid.
 */
final class Point
{
    private final int x;
    private final int y;

    public Point(int x, int y)
    {
        this.x = x;
        this.y = y;
    }

    public int getX() {
        return x;
    }

    public int getY() {
        return y;
    }

    public String toString()
    {
        return "Point(" + x + "," + y + ")";
    }

    public boolean equals(Object other)
    {
        if (other instanceof Point) {
            Point op = (Point) other;
            return x == op.x && y == op.y;
        } else {
            return false;
        }
    }

    public int hashCode()
    {
        int result = 17;
        result = result * 31 + x;
        result = result * 31 + y;
        return result;
    }

    public static int distanceSquared(Point p1, Point p2)
    {
        int deltaX = p1.getX() - p2.getX();
        int deltaY = p1.getY() - p2.getY();

        return deltaX * deltaX + deltaY * deltaY;
    }


    public boolean adjacent(final Point pnt) {
        return (this.x == pnt.x && Math.abs(this.y - pnt.y) == 1)
                || (this.y == pnt.y && Math.abs(this.x - pnt.x) == 1);
    }

}
