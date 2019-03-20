public class Bigger {
    public static double whichIsBigger(Circle c, Rectangle r, Polygon p) {
        // Yikes
        return Math.max(Math.max(Util.perimeter(c), Util.perimeter(r)), Util.perimeter(p));
    }

}

