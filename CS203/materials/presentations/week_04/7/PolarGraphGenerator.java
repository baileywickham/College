

/**
 * An implementation of GraphGenerator that lets us plot functions
 * that use polar coordinates (r = f(theta))
 */
public class PolarGraphGenerator implements GraphGenerator {

    private final double maxRadius;

    public PolarGraphGenerator(double maxRadius) {
        this.maxRadius = maxRadius;
    }

    @Override
    public GraphRange getRange() {
        return new GraphRange(-maxRadius, maxRadius, -maxRadius, maxRadius);
    }

    @Override
    public void generateGraph(GraphyFunction function, int steps, Graph graph) {
        for (int i = 0; i < steps; i++) {
            double theta = 2.0 * Math.PI * i / (double) (steps - 1);

            double rVal;
            try {
                rVal = function.f(theta);
            } catch (Exception ex) {
                rVal = Double.NaN;
            }
            if (Double.isNaN(rVal)) {
                graph.finishSegment();
                continue;
            }
            double xVal = rVal * Math.cos(theta);
            double yVal = rVal * Math.sin(theta);
            graph.addPoint(xVal, yVal);
        }
        graph.finishSegment();
    }
}
