

/**
 * Present a minimal GUI that lets us arrange squares, circles and
 * triangles around on a screen.
 * <p>
 * Don't pay too much attention to what's in here.  This code is using
 * concepts we haven't explored yet.  The point of this code is to give us
 * something that we can use to play with squares and circles.
 */

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.util.ArrayList;
import javax.swing.JFrame;

public class MyGUI extends JFrame {

    public static int NUM_SQUARES = 20;
    public static int NUM_CIRCLES = 25;

    private ArrayList<Circle> circles = new ArrayList<Circle>();
    private ArrayList<Square> squares = new ArrayList<Square>();
    private Dimension size = new Dimension(1000, 800);

    public MyGUI(String name) {
        super(name);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setMinimumSize(size);
    }

    private void makeShapes() {
        ShapesFactory factory = new ShapesFactory(getWidth(), getHeight());
        for (int i = 0; i < NUM_SQUARES; i++) {
            circles.add(factory.makeCircle());
        }
        for (int i = 0; i < NUM_CIRCLES; i++) {
            squares.add(factory.makeSquare());
        }
    }

    public void paint(Graphics g) {
        g.setColor(Color.BLACK);
        g.fillRect(0, 0, size.width, size.height);
        for (Square sq : squares) {
            sq.paint(g);
        }
        for (Circle cir : circles) {
            cir.paint(g);
        }
    }

    public static void run() {
        MyGUI gui = new MyGUI("Kimmy Discovers Squares and Circles!");
        gui.makeShapes();
        gui.setVisible(true);
    }
}
