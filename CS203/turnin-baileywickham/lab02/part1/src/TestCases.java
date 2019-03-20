import java.util.Arrays;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import static edu.calpoly.testy.Assert.assertEquals;
import static edu.calpoly.testy.Assert.assertTrue;
import edu.calpoly.testy.Testy;

public class TestCases
{
    private static final double DELTA = 0.00001;

    private void testSimpleIf1()
    {
        assertEquals(1.7, SimpleIf.max(1.2, 1.7), DELTA);
    }

    private void testSimpleIf2()
    {
        assertEquals(9.0, SimpleIf.max(9.0, 3.2), DELTA);
    }

    private void testSimpleIf3()
    {
        assertEquals(9.0, SimpleIf.max(9.0, 2.1), DELTA);
    }

    private void testSimpleLoop1()
    {
        assertEquals(7, SimpleLoop.sum(3, 4));
    }

    private void testSimpleLoop2()
    {
        assertEquals(7, SimpleLoop.sum(-2, 4));
    }

    private void testSimpleLoop3()
    {
        assertEquals(12, SimpleLoop.sum(-2, 5));
    }

    private void testSimpleArray1()
    {
        /* What are those parameters?  They are newly allocated arrays
            with initial values. */
        assertEquals(
            new int[] {1, 4, 9},
            SimpleArray.squareAll(new int[] {1, 2, 3}));
    }

    private void testSimpleArray2()
    {
        assertEquals(
            new int[] {49, 25},
            SimpleArray.squareAll(new int[] {7, 5}));
    }

    private void testSimpleArray3()
    {
        assertEquals(new int[] {1,4}, SimpleArray.squareAll(new int[] {1,2}));
    }

    private void testSimpleList1()
    {
        List<Integer> input =
            new LinkedList<Integer>(Arrays.asList(new Integer[] {1, 2, 3}));
        List<Integer> expected =
            new ArrayList<Integer>(Arrays.asList(new Integer[] {1, 4, 9}));

        assertEquals(expected, SimpleList.squareAll(input));
    }

    private void testSimpleList2()
    {
        List<Integer> input =
                new LinkedList<>(Arrays.asList(1, 2, 3));
        List<Integer> expected =
            new ArrayList<>(Arrays.asList(1, 4, 9));

        assertEquals(expected, SimpleList.squareAll(input));
    }

    private void testBetterLoop1()
    {
        assertTrue(BetterLoop.contains(new int[] {7, 5}, 5));
    }

    private void testBetterLoop2()
    {
        assertTrue(BetterLoop.contains(new int[] {7, 5, 2, 4}, 4));
    }

    private void testBetterLoop3()
    {
        assertTrue(BetterLoop.contains(new int[] {7, 5, 2, 4}, 4));
    }

    private void testExampleMap1()
    {
        List<String> expected = Arrays.asList("Julie", "Zoe");
        Map<String, List<Course>> courseListsByStudent = new HashMap<>();

        courseListsByStudent.put("Julie",
            Arrays.asList(
                new Course("CPE 123", 4),
                new Course("CPE 101", 4),
                new Course("CPE 202", 4),
                new Course("CPE 203", 4),
                new Course("CPE 225", 4)));
        courseListsByStudent.put("Paul",
            Arrays.asList(
                new Course("CPE 101", 4),
                new Course("CPE 202", 4),
                new Course("CPE 203", 4),
                new Course("CPE 225", 4)));
        courseListsByStudent.put("Zoe",
            Arrays.asList(
                new Course("CPE 123", 4),
                new Course("CPE 203", 4),
                new Course("CPE 471", 4),
                new Course("CPE 473", 4),
                new Course("CPE 476", 4),
                new Course("CPE 572", 4)));

        /*
         * Why compare HashSets here?  Just so that the order of the
         * elements in the list is not important for this test.
         */
        assertEquals(new HashSet<>(expected),
            new HashSet<>(ExampleMap.highEnrollmentStudents(
                courseListsByStudent, 16)));
    }

    private void testExampleMap2()
    {
        List<String> expected = Arrays.asList("Julie", "Zoe");
        Map<String, List<Course>> courseListsByStudent = new HashMap<>();

        courseListsByStudent.put("Julie",
            Arrays.asList(
                new Course("CPE 123", 4),
                new Course("CPE 101", 4),
                new Course("CPE 202", 4),
                new Course("CPE 203", 4),
                new Course("CPE 225", 4)));
        courseListsByStudent.put("Paul",
            Arrays.asList(
                new Course("CPE 101", 4),
                new Course("CPE 202", 4),
                new Course("CPE 203", 4),
                new Course("CPE 225", 4)));
        courseListsByStudent.put("Zoe",
            Arrays.asList(
                new Course("CPE 123", 4),
                new Course("CPE 203", 4),
                new Course("CPE 471", 4),
                new Course("CPE 473", 4),
                new Course("CPE 476", 4),
                new Course("CPE 572", 4)));

        /*
         * Why compare HashSets here?  Just so that the order of the
         * elements in the list is not important for this test.
         */
        assertEquals(new HashSet<>(expected),
            new HashSet<>(ExampleMap.highEnrollmentStudents(
                courseListsByStudent, 16)));
    }

    public void runTests() {
        Testy.run(
                this::testSimpleIf1,
                this::testSimpleIf2,
                this::testSimpleIf3,
                this::testSimpleLoop1,
                this::testSimpleLoop2,
                () -> testSimpleLoop3(),
                () -> testSimpleArray1(),
                () -> testSimpleArray2(),
                () -> testSimpleArray3(),
                () -> testSimpleList1(),
                () -> testSimpleList2(),
                () -> testBetterLoop1(),
                () -> testBetterLoop2(),
                () -> testBetterLoop3(),
                () -> testExampleMap1(),
                () -> testExampleMap2()
        );
    }
}
