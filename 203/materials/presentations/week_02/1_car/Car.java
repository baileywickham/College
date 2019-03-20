

/**
 * A little class representing a car.
 */


// "public" here means "classes in other packages can see this class".
// You'll probably declare all classes public for now.  The only alternative
// is called "package-private," which you get by leaving off the word "public."

public class Car {

    /**
     * The car's make
     */
    public final String make;
        // "public" means "other classes can see this"
        // "final" means "this can only be set once"
        //      For instance members like this, that means it must be
        //      set in the constructor.

    private String model;
        // "private" means "other classes can't see this"


        // We have no static data members here.  This is typical.  Static
        // data members are like global variable in other languages:  There
        // is only one copy in the whole program.

    /**
     * Initialize a new Car instance
     *
     * @param make      The car's make
     * @param model     The car's model
     */
    public Car(String make, String model) {
        this.make = make;
        this.model = model;
    }

    /**
     * Get this car's model
     */
    public String getModel() {
        return model;
            // If you just refer to a member, like "model," that's
            // equivalent to saying "this.model".  All instance methods
            // have a reference to the object on which they're invoked.
    }

    public String toString() {
        return "Car(" + getMembersAsString() + ")";
    }

    //
    // Since it's marked private, this method can only be used inside this
    // class.
    //
    private String getMembersAsString() {
        return getMembersAsString(", ");
    }

    // 
    // It's OK to have two methods with the same name, as long as they
    // have different argument types.  This is called "method overloading."
    //
    private String getMembersAsString(String seperator) {
        String result = make + seperator + this.model;
            // Just showing that you can always add "this." before a reference
            // to a member of the class we're in.
        return result;
    }

}
