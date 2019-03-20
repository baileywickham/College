import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.function.Predicate;
import java.util.stream.Collectors;
import java.util.Arrays;
import java.util.List;
import java.util.ArrayList;
import java.util.LinkedList;

import java.awt.Color;

import static edu.calpoly.testy.Assert.assertEquals;
import static edu.calpoly.testy.Assert.assertTrue;
import static edu.calpoly.testy.Assert.fail;
import edu.calpoly.testy.Testy;

public class TestCases
{
    public static final double DELTA = 0.00001;

    /* 
     The provided tests are commented out.  Remove this line, the
     line above it, and the close comment line just before runTests().

    // some sample tests but you must write more! see lab write up

    public void testCircleGetArea()
    {
        Circle c = new Circle(5.678, new Point(2, 3), Color.BLACK);

        assertEquals(101.2839543, c.getArea(), DELTA);
    }

    public void testCircleGetPerimeter()
    {
        Circle c = new Circle(5.678, new Point(2, 3), Color.BLACK);

        assertEquals(35.6759261, c.getPerimeter(), DELTA);
    }

    public void testWorkSpaceAreaOfAllShapes()
    {
        WorkSpace ws = new WorkSpace();

        ws.add(new Rectangle(1.234, 5.678, new Point(2, 3), Color.BLACK));
        ws.add(new Circle(5.678, new Point(2, 3), Color.BLACK));
        ws.add(new Triangle(new Point(0,0), new Point(2,-4), new Point(3, 0), 
                      Color.BLACK));

        assertEquals(114.2906063, ws.getAreaOfAllShapes(), DELTA);
    }

    public void testWorkSpaceGetCircles()
    {
        WorkSpace ws = new WorkSpace();
        List<Circle> expected = new LinkedList<>();

        // Have to make sure the same objects go into the WorkSpace as
        // into the expected List since we haven't overriden equals in Circle.
        Circle c1 = new Circle(5.678, new Point(2, 3), Color.BLACK);
        Circle c2 = new Circle(1.11, new Point(-5, -3), Color.RED);

        ws.add(new Rectangle(1.234, 5.678, new Point(2, 3), Color.BLACK));
        ws.add(c1);
        ws.add(new Triangle(new Point(0,0), new Point(2,-4), new Point(3, 0),
                      Color.BLACK));
        ws.add(c2);

        expected.add(c1);
        expected.add(c2);

        // Doesn't matter if the "type" of lists are different (e.g Linked vs
        // Array).  List equals only looks at the objects in the List.
        assertEquals(expected, ws.getCircles());
    }

    public void testCircleImplSpecifics()
        throws NoSuchMethodException
    {
        final List<String> expectedMethodNames = Arrays.asList(
            "getColor", "setColor", "getArea", "getPerimeter", "translate",
            "getRadius", "setRadius", "getCenter");

        final List<Class> expectedMethodReturns = Arrays.asList(
            Color.class, void.class, double.class, double.class, void.class,
            double.class, void.class, Point.class);

        final List<Class[]> expectedMethodParameters = Arrays.asList(
            new Class[0], new Class[] {Color.class}, new Class[0], new Class[0], new Class[] {double.class, double.class},
            new Class[0], new Class[] {double.class}, new Class[0]);

        verifyImplSpecifics(Circle.class, expectedMethodNames,
            expectedMethodReturns, expectedMethodParameters);
    }

    public void testRectangleImplSpecifics()
        throws NoSuchMethodException
    {
        final List<String> expectedMethodNames = Arrays.asList(
            "getColor", "setColor", "getArea", "getPerimeter", "translate",
            "getWidth", "setWidth", "getHeight", "setHeight", "getTopLeft");

        final List<Class> expectedMethodReturns = Arrays.asList(
            Color.class, void.class, double.class, double.class, void.class,
            double.class, void.class, double.class, void.class, Point.class);

        final List<Class[]> expectedMethodParameters = Arrays.asList(
            new Class[0], new Class[] {Color.class}, new Class[0], new Class[0], new Class[] {double.class, double.class},
            new Class[0], new Class[] {double.class}, new Class[0], new Class[] {double.class}, new Class[0]);

        verifyImplSpecifics(Rectangle.class, expectedMethodNames,
            expectedMethodReturns, expectedMethodParameters);
    }

    public void testTriangleImplSpecifics()
        throws NoSuchMethodException
    {
        final List<String> expectedMethodNames = Arrays.asList(
            "getColor", "setColor", "getArea", "getPerimeter", "translate",
            "getVertexA", "getVertexB", "getVertexC");

        final List<Class> expectedMethodReturns = Arrays.asList(
            Color.class, void.class, double.class, double.class, void.class,
            Point.class, Point.class, Point.class);

        final List<Class[]> expectedMethodParameters = Arrays.asList(
            new Class[0], new Class[] {Color.class}, new Class[0], new Class[0], new Class[] {double.class, double.class},
            new Class[0], new Class[0], new Class[0]);

        verifyImplSpecifics(Triangle.class, expectedMethodNames,
            expectedMethodReturns, expectedMethodParameters);
    }

    public void testConvexPolygonImplSpecifics()
        throws NoSuchMethodException
    {
        final List<String> expectedMethodNames = Arrays.asList(
            "getColor", "setColor", "getArea", "getPerimeter", "translate",
            "getVertex", "getNumVertices");

        final List<Class> expectedMethodReturns = Arrays.asList(
            Color.class, void.class, double.class, double.class, void.class,
            Point.class, int.class);

        final List<Class[]> expectedMethodParameters = Arrays.asList(
            new Class[0], new Class[] {Color.class}, new Class[0], new Class[0], new Class[] {double.class, double.class},
            new Class[] {int.class}, new Class[0]);

        verifyImplSpecifics(ConvexPolygon.class, expectedMethodNames,
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
    */

    public void runTests() 
    {
        Testy.run(
                /* Provided tests commented out
                () -> testCircleGetArea(),
                () -> testCircleGetPerimeter(),
                () -> testWorkSpaceAreaOfAllShapes(),
                () -> testWorkSpaceGetCircles(),
                () -> testCircleImplSpecifics(),
                () -> testRectangleImplSpecifics(),
                () -> testTriangleImplSpecifics(),
                () -> testConvexPolygonImplSpecifics()
                */
        );
    }
}
