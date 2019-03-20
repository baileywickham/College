
import java.awt.Graphics2D;
import java.awt.Dimension;

/**
 * A graph to be drawn by Graphy.  This is passed by Graphy into a
 * GraphGenerator.
 */
public final class Graph {
    private final int x[];
    private final int y[];
    private final Graphics2D graphics;
    private final int steps;
    private final GraphRange range;
    private final Dimension size;
    private final int penWidth;  // # points so far
    private int numPoints;  // # points so far

    //
    // Only graphy makes Graph objects, so we declare the constructor 
    // package-private
    //
    Graph(Graphics2D graphics, int steps, GraphRange range, Dimension size,
          int penWidth) 
    {
        x = new int[steps];
        y = new int[steps];
        this.graphics = graphics;
        this.steps = steps;
        this.range = range;
        this.size = size;
        this.penWidth = penWidth;
        numPoints = 0;
    }

    public void addPoint(double xVal, double yVal) {
        int height = size.height - penWidth*2;

        // Put within our range:
        xVal = ((xVal - range.minX) / (range.maxX - range.minX)) * size.width; 
        yVal = ((range.maxY - yVal) / (range.maxY - range.minY)) * height;
        yVal += penWidth;
        x[numPoints] = (int) Math.round(xVal);
        y[numPoints++] = (int) Math.round(yVal);
        int fudge = 10 + 2 * penWidth;
        if (yVal > size.height + fudge || yVal < -fudge) {
                // Really, "if the calculated y is out of range,"
                // but we add a fudge factor based on the pen width
                // plus a bit, to be sure.
            finishSegment();
        }
    }

    /**
     * Call this whenever a line segment is finished, for example, when
     * there's a discontinuity in the function, or after adding the last
     * point.
     */
    public void finishSegment() {
        if (numPoints > 1) {
            graphics.drawPolyline(x, y, numPoints);
        }
        numPoints = 0;
    }
}
