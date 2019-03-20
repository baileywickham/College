
import java.util.ArrayList;
    // This just say "in this file, when I say 'ArrayList,' I really
    // mean 'java.util.ArrayList.'"


/**
 * A class that just holds the main function, used to play with the
 * Car class.
 */

public class Main {

    public static void main(String[] args) {
        ArrayList<Car> cars = new ArrayList<Car>();
        cars.add(new Car("Chrysler", "Sebring Convertible"));
        cars.add(new Car("Honda", "Civic Hybrid"));
        cars.add(new Car("Mazda", "Miata"));

        System.out.println();
        System.out.println(cars);
        System.out.println();

        for (Car c : cars) {
            System.out.println(c.toString());
        }
        System.out.println();

        for (Car c : cars) {
            System.out.println(c);
        }
        System.out.println();
        
        System.out.println(cars.get(1).make);

        // This won't compile, because Cars.model is private:
        // System.out.println(cars.get(1).model);

        System.out.println(cars.get(1).getModel());

        System.out.println();
    }
}
