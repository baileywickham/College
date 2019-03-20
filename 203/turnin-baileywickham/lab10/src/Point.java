

public class Point {

    public final double x;
    public final double y;
    public final double z;

    public Point(double x, double y, double z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }
    public Point scale() {
        return new Point(x * .5, y * .5, z * .5);
    }
    public Point translate() {return new Point(x- 150, y-37,z);}

    public String toString() {
        return "Point(" + x + ", " + y + ", " + z + ")";
    }    
}
