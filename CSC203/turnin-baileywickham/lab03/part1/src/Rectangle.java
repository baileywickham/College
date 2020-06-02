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
}
