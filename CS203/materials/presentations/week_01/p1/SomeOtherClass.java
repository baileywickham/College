

public class SomeOtherClass {

    private int number;
    private String string;

    public SomeOtherClass(String string, int number) {
        this.string = string;
        this.number = number;
    }

    public String getString() {
        return string;
    }

    public int addedTo(int number) {
        // TODO:  Implement this

        return 0;
    }

    public static void sayHello() {
        System.out.println("Hello");
        //
        // Why won't the following work?
        //
        //  System.out.println(getString());
    }
}
