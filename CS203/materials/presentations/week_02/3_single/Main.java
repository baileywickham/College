
/**
 * A class to hold the main method.  Any class will do.  If you always
 * call it "Main," then you don't have to search when you want to run
 * the program.
 */
public class Main {
    /**
     * When you run "java main," this method is executed:
     */
    public static void main(String[] args) {
        if (args.length == 1 && "test".equals(args[0])) {
            TestShapes.run();
        } else {
            System.out.println("Run with \"test\" to run unit tests.");
            MyGUI.run();
        }
    }
}
