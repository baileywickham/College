

public class Point3D extends Point {

    // We inherit x and y

    public final int z;

    public Point3D(int x, int y, int z) {
        super(x, y);
        this.z = z;
    }

    @Override
    public boolean equals(Object other) {
        if (other instanceof Point3D) {
            Point3D op = (Point3D) other;
            return this.x == op.x && this.y == op.y 
                   && this.z == op.z;
        } else {
            return false;
        }
    }
}
