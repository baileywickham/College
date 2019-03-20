

/**
 * A representation of a point in 2D space.  The point 0,0 is considered to
 * be at the upper right hand corner with increasing y values being lower on 
 * the screen, as is typical in computer graphics.
 */

public class Point {

    private float x;    // "private" means this can only be accessed inside this class
    private float y;

    public Point(float x, float y) {
        this.x = x;
        this.y = y;
    }

    public float getX() {
        return x;
    }

    public float getY() {
        return y;
    }
}
