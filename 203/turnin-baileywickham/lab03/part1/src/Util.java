public class Util {
    public static double perimeter(Circle circle) {
        return circle.getRadius() * 2 * Math.PI;
    }
    public static double perimeter(Rectangle rectangle) {
        double l = 0.0;
        double w = 0.0;

        l = rectangle.getTopLeft().getY() - rectangle.getBottomRight().getY();
        w = rectangle.getBottomRight().getX() - rectangle.getTopLeft().getX();
        return 2 * (Math.abs(l) + Math.abs(w));
    }
    public static double perimeter(Polygon polygon){
        double p = 0;
        for (int i = 1; i < polygon.getPoints().size(); i++ ) {
            // yikes
            p += getDistance(polygon.getPoints().get(i-1), polygon.getPoints().get(i));
        }
        // again, yikes
        p += getDistance(polygon.getPoints().get(polygon.getPoints().size()-1), polygon.getPoints().get(0));
        return p;
    }
    private static double getDistance(Point p1, Point p2) {
        double x1 = p1.getX();
        double x2 = p2.getX();
        double y1 = p1.getY();
        double y2 = p2.getY();

        return Math.sqrt((y2 - y1) * (y2 - y1) + (x2 - x1) * (x2 - x1));

    }
}
