

/**
 * Present a GUI that draws one or more functions.
 * <p>
 * Don't pay too much attention to what's in here.  This code is using
 * concepts we haven't explored yet.  The point of this code is to give us
 * something that we can use to play with graphing.
 */

import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Rectangle;
import java.awt.BasicStroke;
import java.awt.Container;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.util.ArrayList;
import java.util.List;
import java.awt.GridBagLayout;
import java.awt.GridBagConstraints;
import java.awt.Color;
import javax.swing.JFrame;
import javax.swing.JButton;

public class Graphy extends JFrame {


    public static final Dimension SIZE = new Dimension(1000, 800);
    private final static int PEN_WIDTH = 5;

    private static int graphyCount = 0;

    private final GraphRange range;
    private final List<GraphSpec> functions = new ArrayList<GraphSpec>();


    public Graphy(GraphRange range) {
        super("Kimmy Discovers Graphs!");
        this.range = range;
        graphyCount++;
        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                graphyCount--;
                if (graphyCount == 0) {
                    System.exit(0);
                }
            }
        });
        setPreferredSize(SIZE);
        setContentPane(new Container() {
            public void paint(Graphics g) {
                paintOurContentPane(getSize(), (Graphics2D) g);
                    // A slightly sleazy trick here.  A JFrame has frame
                    // decorations, like the open/close buttons, so we don't
                    // care how big the JFrame is.  We care how big its
                    // content pane is.  Since we want the whole content
                    // pane, we just override Container() to hijack its
                    // paint method.  We really should add a subclass of
                    // Canvas to the container, but that's more work.
            }
        });
    }

    public void add(GraphyFunction f, Color c) {
        functions.add(new GraphSpec(f, c));
    }

    public void add(GraphyFunction f) {
        add(f, Color.RED);
    }


    private void paintOurContentPane(Dimension size, Graphics2D g) {
        g.setStroke(new BasicStroke((float) PEN_WIDTH));
        int height = size.height - 2*PEN_WIDTH;
            // Take a bit off height to compensate for pen width

        g.setColor(Color.BLACK);
        g.fillRect(0, 0, size.width, size.height);
        int steps = Math.max(size.width, size.height);
        if (steps < 2) {
            return;
        }
        int x[] = new int[steps+1];
        int y[] = new int[steps+1];
        for (GraphSpec spec : functions) {
            int numPoints = 0;
            g.setColor(spec.color);
            for (int i = 0; i < steps; i++) {
                double xArg = range.minX 
                              + (range.maxX - range.minX) * i / (steps - 1);

                double yVal;
                try {
                    yVal = spec.function.f(xArg);
                } catch (Exception ex) {
                    yVal = Double.NaN;
                }
                if (Double.isNaN(yVal)) {
                    if (numPoints > 1) {
                        g.drawPolyline(x, y, numPoints);
                    }
                    numPoints = 0;
                    continue;
                }

                // Put within our range:
                yVal = (range.maxY-yVal) / (range.maxY - range.minY) * height
                               + PEN_WIDTH;
                x[numPoints] = i;
                y[numPoints++] = (int) Math.round(yVal);
                if (yVal > size.height + 20 || yVal < -20) {
                        // Really, "if the calculated y is out of range,"
                        // but we add a fudge factor to compensate for the
                        // pen width.
                    if (numPoints > 1) {
                        g.drawPolyline(x, y, numPoints);
                    }
                    numPoints = 0;
                }
            }
            if (numPoints > 1) {
                g.drawPolyline(x, y, numPoints);
            }
        }
    }

    public void run() {
        pack();
        setVisible(true);
    }
}
