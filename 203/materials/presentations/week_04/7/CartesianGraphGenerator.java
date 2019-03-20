

/**
 * An implementation of GraphGenerator that lets us plot functions
 * that use cartesian coordinates (y = f(x))
 */
public class CartesianGraphGenerator implements GraphGenerator {

    private GraphRange range;

    public CartesianGraphGenerator(GraphRange range) {
        this.range = range;
    }

    @Override
    public GraphRange getRange() {
        return range;
    }

    @Override
    public void generateGraph(GraphyFunction function, int steps, Graph graph) {
        for (int i = 0; i < steps; i++) {
            double xArg = range.minX 
                          + (range.maxX - range.minX) * i / (steps - 1);

            double yVal;
            try {
                yVal = function.f(xArg);
            } catch (Exception ex) {
                yVal = Double.NaN;
            }
            if (Double.isNaN(yVal)) {
                graph.finishSegment();
                continue;
            }
            graph.addPoint(xArg, yVal);
        }
        graph.finishSegment();
    }
}
