

public class SomeClass  {

    public static void main(String[] args) {

        System.out.println();
        SomeOtherClass.sayHello();
        System.out.println();

        SomeOtherClass o1 = new SomeOtherClass("one", 1);
        SomeOtherClass o2 = new SomeOtherClass("two", 2);

        System.out.println("Using " + o1.getString());
        System.out.println(o1.addedTo(10));
        System.out.println();

        System.out.println("Using " + o2.getString());
        System.out.println(o2.addedTo(10));
        System.out.println();

    }

}
