
import java.awt.Color;
import java.util.Random;

/**
 * A factory that produces Square and Circle instances that are for display on
 * a screen width x height pixels.
 */

public class ShapesFactory {
    
    private Random generator;
    private int width;
    private int height;

    public ShapesFactory(int width, int height) {
        generator = new Random();
        this.width = width;
        this.height = height;
    }

    public Shape makeShape() {
        if (generator.nextFloat() > 0.6f) {
            return makeSquare();
        } else {
            return makeCircle();
        }
    }

    private Square makeSquare() {
        float x = generator.nextFloat() * (width - 1);
        float y = generator.nextFloat() * (height - 1);
        float w = generator.nextFloat() * (width / 5f);
        float h = w;
        Color c = new Color(generator.nextInt(256), generator.nextInt(256), 
                            generator.nextInt(256));
        return new Square(new Point(x, y), new Point(x+w, y+h), c);
    }

    private Circle makeCircle() {
        float x = generator.nextFloat() * (width - 1);
        float y = generator.nextFloat() * (height - 1);
        float w = generator.nextFloat() * (width / 5f);
        Color c = new Color(generator.nextInt(256), generator.nextInt(256), 
                            generator.nextInt(256));
        return new Circle(new Point(x, y), w/2f, c);
    }
}
