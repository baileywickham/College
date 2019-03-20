

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


    public final static Dimension SIZE = new Dimension(1000, 800);
    public final static int PEN_WIDTH = 5;

    private static int graphyCount = 0;

    private final GraphRange range;
    private final GraphGenerator generator;
    private final List<GraphSpec> functions = new ArrayList<GraphSpec>();



    public Graphy(GraphGenerator generator) {
        super("Graphy Goes Polar!");
        this.range = generator.getRange();
        this.generator = generator;
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

    public Graphy(GraphRange range) {
        this(new CartesianGraphGenerator(range));
    }

    public void add(GraphyFunction f, Color c) {
        functions.add(new GraphSpec(f, c));
    }

    public void add(GraphyFunction f) {
        add(f, Color.RED);
    }


    public void paintOurContentPane(Dimension size, Graphics2D g) {
        g.setStroke(new BasicStroke((float) PEN_WIDTH));
        g.setColor(Color.BLACK);
        g.fillRect(0, 0, size.width, size.height);
        int steps = Math.max(size.width, size.height);
        if (steps < 2) {
            return;
        }
        Graph graph = new Graph(g, steps, range, size, PEN_WIDTH);
        for (GraphSpec spec : functions) {
            g.setColor(spec.color);
            generator.generateGraph(spec.function, steps, graph);
            graph.finishSegment();
        }
    }

    public void run() {
        setLocation(graphyCount * 70, graphyCount * 40);
        pack();
        setVisible(true);
    }
}
