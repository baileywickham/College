

/**
 * Present a minimal GUI dor a button.
 * <p>
 * Don't pay too much attention to what's in here.  This code is using
 * concepts we haven't explored yet.  The point of this code is to give us
 * something that we can use to play with squares and circles.
 */

import java.awt.Dimension;
import java.awt.Graphics;
import java.util.ArrayList;
import java.awt.GridBagLayout;
import java.awt.GridBagConstraints;
import javax.swing.JFrame;
import javax.swing.JButton;

public class MyGUI extends JFrame {

    public static Dimension SIZE = new Dimension(300, 200);
    public static int NUM_SHAPES = 50;

    private final GridBagLayout layout = new GridBagLayout();
    private final GridBagConstraints constraints = new GridBagConstraints();
    private JButton myButton;

    private final MyProgram myProgram = new MyProgram();

    public MyGUI(String name) {
        super(name);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setMinimumSize(SIZE);
    }

    public void setup() {
        setLayout(layout);
        myButton = new JButton("Press to sort");
        add(myButton, constraints);

        myProgram.register(myButton);
    }


    public static void main(String[] args) {
        MyGUI gui = new MyGUI("Kimmy Discovers a Button!");
        gui.setup();
        gui.pack();
        gui.setVisible(true);
    }
}
