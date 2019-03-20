

import edu.calpoly.spritely.Size;
import edu.calpoly.testy.Testy;
import edu.calpoly.testy.Assert;


/**
 * This class contains unit tests for Minecraft 2: Electric Boogaloo.
 */
public class TestCases {

    private void loadImagesTest() {
        // This will fail if an image name is misspelled.  By doing this
        // here, we make checkgit test image loading.
        //VirtualWorld.loadEntityImages();
    }
    private void test1() {
        EventSchedule e = new EventSchedule();
        TestAnimatable t = new TestAnimatable();
        Animation a = new Animation(t, 30);
        e.scheduleEvent(new WorldModel(new Size(1,1)), a,0);
        e.processEvents(100);
        Assert.assertEquals(t.getCounter(), 30);

    }
    private void test2() {
        EventSchedule e = new EventSchedule();
        TestAnimatable t = new TestAnimatable();
        Animation a = new Animation(t, 100);
        e.scheduleEvent(new WorldModel(new Size(1,1)), a,0);
        e.processEvents(100);
        Assert.assertEquals(t.getCounter(), 100);
    }

    /**
     * Run the tests.
     *
     * @return The number of failures.
     */
    public int runTests() {
        return Testy.run(
                () -> loadImagesTest(),
                () -> test1(),
                () -> test2()
        );
    }

}
