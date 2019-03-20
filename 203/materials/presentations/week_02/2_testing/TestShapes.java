
import java.util.Arrays;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

//
// "import static" can be used to avoid typing long names for
// static functions in other classes.  The following imports
// let us just say, for exmaple, "PI" instead of
// "java.lang.Math.PI" or "Math.PI".
//
import static java.lang.Math.PI;
import static java.awt.Color.RED;
import static edu.calpoly.testy.Assert.assertEquals;
import static edu.calpoly.testy.Assert.assertTrue;
import static edu.calpoly.testy.Assert.assertFalse;
import static edu.calpoly.testy.Assert.fail;
import edu.calpoly.testy.Testy;


/**
 * Unit tests for the non-GUI parts of Square and Circle.  Run with:  <pre>
 *
 * java TestShapes
 * </pre>
 */

public class TestShapes {

    private final static float TOLERANCE = 0.000001f;

    public static void testPoint() {
        Point pt = new Point(2.1f, 3.7f);
        assertEquals("check Point.getX()", pt.getX(), 2.1, TOLERANCE);
        assertEquals("check Point.getY()", pt.getY(), 3.7, TOLERANCE);
    }

    public static void testSquare() {
        Square sq = new Square(new Point(1, 1), new Point(4, 5), RED);
        if (sq.getArea() != 12.0) {
            fail();     // Is this OK?  How is it different from assertEquals()?
        }
    }

    public static void testCircle1() {
        Circle circle1 = new Circle(new Point(1.3f, 2.7f), 5.6f, RED);
        Circle circle2 = new Circle(new Point(-0.7f, 2.9f), 5.6f, RED);
        assertTrue("Circle area 1", circle1.getArea() == circle2.getArea());
    }

    public static void testCircle2() {
        Circle c = new Circle(new Point(0.1f, 2.7f), 4.5f, RED);
        assertEquals("Circle area 2", 
                     (float) (PI * 4.5 * 4.5), c.getArea(), TOLERANCE);
    }

    public static void testCircle3() {
        float[] radii = { 0.1f, 27.6f, 7.1f };
        float[] answers = new float[radii.length];
        float[] results = new float[radii.length];
        for (int i = 0; i < radii.length; i++) {
            answers[i] = (float) (PI * radii[i] * radii[i]);
            Circle c = new Circle(new Point(1, 2), radii[i], RED);
            results[i] = c.getArea();
        }
        assertEquals("Circle area 3", answers, results, TOLERANCE);
    }

    public static void run() {
        Testy.run(
                () -> testPoint(),
                () -> testSquare(),
                () -> testCircle1(),
                () -> testCircle2(),
                () -> testCircle3()
        );

    }
}


