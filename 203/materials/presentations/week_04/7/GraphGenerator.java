
/**
 * An interface to represent objects that generates a graph, given some 
 * kind of function.  
 */

public interface GraphGenerator {


    /**
     * Generate a graph, by generating up to steps points in the graph.
     */
    void generateGraph(GraphyFunction f, int steps, Graph graph);

    /**
     * Tell Graphy the range of x and y values to include in the graph.
     */
    GraphRange getRange();

}
