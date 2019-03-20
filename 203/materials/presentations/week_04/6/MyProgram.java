

public class MyProgram {

    public static void main(String[] args) {
        GraphRange range = new GraphRange(0.0, 2*Math.PI, -1.0, 1.0);
        Graphy graphy = new Graphy(range);
        GraphyFunction f = (x) -> { return Math.sin(x); };
        graphy.add(f);
        f = (x) -> { return 0.2 * Math.tan(x); };
        graphy.add(f, java.awt.Color.GREEN);
        graphy.add((x) -> { return 0.4 * Math.sqrt(x - 1.0); }, java.awt.Color.blue);

        graphy.run();
    }
    //
    // To do at home:
    //
    //   *  Add a new function to Graphy
    //   *  Do it each of the two ways we learned
}
