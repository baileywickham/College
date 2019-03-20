

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

    public static Dimension SIZE = new Dimension(1000, 800);
    public static int NUM_SHAPES = 50;

    private ArrayList<Shape> shapes = new ArrayList<Shape>();

    public MyGUI(String name) {
        super(name);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setMinimumSize(SIZE);
    }

    private void makeShapes() {
        ShapesFactory factory = new ShapesFactory(getWidth(), getHeight());
        for (int i = 0; i < NUM_SHAPES; i++) {
            shapes.add(factory.makeShape());
        }
    }

    /**
     * This gets called by the Java graphics system to paint
     * the screen.
     */
    @Override
    public void paint(Graphics g) {
        g.setColor(Color.BLACK);
        g.fillRect(0, 0, SIZE.width, SIZE.height);
        Visitor painter = new AWTPainter(g);
        for (Shape s: shapes) {
            s.visit(painter);
        }
    }

    public static void main(String[] args) {
        MyGUI gui = new MyGUI("Kimmy Discovers Squares and Circles!");
        gui.makeShapes();
        gui.setVisible(true);
    }
}
