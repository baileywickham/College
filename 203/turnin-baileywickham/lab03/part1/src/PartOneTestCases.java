import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.function.Predicate;
import java.util.stream.Collectors;
import java.util.Arrays;
import java.util.List;
import java.util.ArrayList;

import static edu.calpoly.testy.Assert.assertEquals;
import static edu.calpoly.testy.Assert.assertTrue;
import static edu.calpoly.testy.Assert.fail;
import edu.calpoly.testy.Testy;

public class PartOneTestCases
{
    public static final double DELTA = 0.00001;

    public void testCircleImplSpecifics()
        throws NoSuchMethodException
    {
        final List<String> expectedMethodNames = Arrays.asList(
            "getCenter", "getRadius");

        final List<Class> expectedMethodReturns = Arrays.asList(
            Point.class, double.class);

        final List<Class[]> expectedMethodParameters = Arrays.asList(
            new Class[0], new Class[0]);

        verifyImplSpecifics(Circle.class, expectedMethodNames,
            expectedMethodReturns, expectedMethodParameters);


    }
    public void testPerimPoly() {
        List<Point>points = new ArrayList<Point >();
        points.add(new Point(0, 0));
        points.add(new Point(3,0));
        points.add(new Point(0,4));
        double d = Util.perimeter(new Polygon(points));
        assertEquals(12.0, d, DELTA);
    }
    public void testCircle() {
        Circle c = new Circle(new Point(0,0), 1);
        double d = Util.perimeter(c);
        assertEquals(6.28318, d, DELTA);
    }
    public void testRectangle() {
        Rectangle r = new Rectangle(new Point(0,1), new Point(1,0));
        double d = Util.perimeter(r);
        assertEquals(4.0, d, DELTA);
    }


    public void testRectangleImplSpecifics()
        throws NoSuchMethodException
    {
        final List<String> expectedMethodNames = Arrays.asList(
            "getTopLeft", "getBottomRight");

        final List<Class> expectedMethodReturns = Arrays.asList(
            Point.class, Point.class);

        final List<Class[]> expectedMethodParameters = Arrays.asList(
            new Class[0], new Class[0]);

        verifyImplSpecifics(Rectangle.class, expectedMethodNames,
            expectedMethodReturns, expectedMethodParameters);
    }

    public void testPolygonImplSpecifics()
        throws NoSuchMethodException
    {
        final List<String> expectedMethodNames = Arrays.asList(
            "getPoints");

        final List<Class> expectedMethodReturns = Arrays.asList(
            List.class);

        final List<Class[]> expectedMethodParameters = Arrays.asList(
            new Class[][] {new Class[0]});

        verifyImplSpecifics(Polygon.class, expectedMethodNames,
            expectedMethodReturns, expectedMethodParameters);
    }

    public void testUtilImplSpecifics()
        throws NoSuchMethodException
    {
        final List<String> expectedMethodNames = Arrays.asList(
            "perimeter", "perimeter", "perimeter");

        final List<Class> expectedMethodReturns = Arrays.asList(
            double.class, double.class, double.class);

        final List<Class[]> expectedMethodParameters = Arrays.asList(
            new Class[] {Circle.class},
            new Class[] {Polygon.class},
            new Class[] {Rectangle.class});

        verifyImplSpecifics(Util.class, expectedMethodNames,
            expectedMethodReturns, expectedMethodParameters);
    }

    private static void verifyImplSpecifics(
        final Class<?> clazz,
        final List<String> expectedMethodNames,
        final List<Class> expectedMethodReturns,
        final List<Class[]> expectedMethodParameters)
        throws NoSuchMethodException
    {
        assertEquals("Unexpected number of public fields",
            0, clazz.getFields().length);

        final List<Method> publicMethods = Arrays.stream(
            clazz.getDeclaredMethods())
                .filter(m -> Modifier.isPublic(m.getModifiers()))
                .collect(Collectors.toList());

        assertEquals("Unexpected number of public methods",
            expectedMethodNames.size(), publicMethods.size());

        assertTrue("Invalid test configuration",
            expectedMethodNames.size() == expectedMethodReturns.size());
        assertTrue("Invalid test configuration",
            expectedMethodNames.size() == expectedMethodParameters.size());

        for (int i = 0; i < expectedMethodNames.size(); i++)
        {
            Method method = clazz.getDeclaredMethod(expectedMethodNames.get(i),
                expectedMethodParameters.get(i));
            assertEquals(expectedMethodReturns.get(i), method.getReturnType());
        }
    }
    public void testWhichIsBigger() {
        List<Point>points = new ArrayList<Point >();
        points.add(new Point(0, 0));
        points.add(new Point(3,1));
        points.add(new Point(1,4));
        points.add(new Point(-1,4));
        double exp = 12.890934561250031;
        double rt = Bigger.whichIsBigger(new Circle(new Point(1.0,1.0),2.0), new Rectangle(new Point(-1.0,2.0),new Point(1.0, -1.6)), new Polygon(points));
        assertEquals(rt, exp, DELTA );
    }
    public void runTests() 
    {
        Testy.run(
                () -> testCircleImplSpecifics(),
                () -> testRectangleImplSpecifics(),
                () -> testPolygonImplSpecifics(),
                () -> testUtilImplSpecifics(),
                () -> testPerimPoly(),
                () -> testCircle(),
                () -> testRectangle(),
                () -> testWhichIsBigger()
        );
    }

}
