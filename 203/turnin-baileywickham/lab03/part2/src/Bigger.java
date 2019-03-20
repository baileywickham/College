public class Bigger {
    public static double whichIsBigger(Circle c, Rectangle r, Polygon p) {
        // Yikes
        return Math.max(Math.max(c.perimeter(), r.perimeter()), p.perimeter());
    }

}

