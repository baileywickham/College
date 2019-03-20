
import java.awt.Color;

public class MyProgram {

    public static void main(String[] args) {
        GraphRange range = new GraphRange(0.0, 2*Math.PI, -1.0, 1.0);
        Graphy graphy = new Graphy(range);
        graphy.add((x) -> { return Math.sin(x); });
        graphy.add((x) -> { return 1.0 / x; }, Color.magenta);
        graphy.add((x) -> { return 0.4 * Math.sqrt(x - 1.0); }, Color.cyan);

        graphy.run();


        PolarGraphGenerator generator = new PolarGraphGenerator(3.0);
        Graphy graphy2 = new Graphy(generator);
        graphy2.add((theta) -> { return Math.sin(5.0 * theta); });
        graphy2.add((theta) -> { return 1 + 2.0 * Math.cos(theta); }, Color.YELLOW);
        graphy2.run();
    }
}
