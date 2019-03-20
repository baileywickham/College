public class Rectangle {
    private final Point topleft;
    private final Point bottomright;

    public Rectangle(Point tl, Point br) {
        this.topleft = tl;
        this.bottomright = br;
    }
    public Point getTopLeft() {
        return topleft;
    }
    public Point getBottomRight() {
        return bottomright;
    }
    public double perimeter() {
        double l = 0.0;
        double w = 0.0;

        l = getTopLeft().getY() - getBottomRight().getY();
        w = getBottomRight().getX() - getTopLeft().getX();
        return 2 * (Math.abs(l) + Math.abs(w));
    }
}
