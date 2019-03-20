

public class LambdaTest {

    private static MyInterface makeLambda(String message) {
        final String str = "Message:  " + message;
        return () -> { System.out.println(str); };
    }


    public static void main(String[] args) {
        for (int i = 0; i < 24; i++) {
            System.out.println();
        }

        MyInterface lambdaOne;
        MyInterface lambdaTwo;

        lambdaOne = makeLambda("one");
        lambdaTwo = makeLambda("two");

        lambdaOne.doSomething();
        lambdaOne.doSomething();
        lambdaTwo.doSomething();
        lambdaOne.doSomething();
        lambdaTwo.doSomething();

        System.out.println();
        System.out.println(lambdaOne);
        System.out.println(lambdaOne.getClass());
        System.out.println(lambdaTwo);

        //
        // What happens if we add a second method to MyInterface?
        // How about one that takes an argument?
        //
    }
}


