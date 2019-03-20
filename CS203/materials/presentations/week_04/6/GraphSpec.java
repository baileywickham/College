
import java.awt.Color;

/**
 * a little data holder for Graphy to hold the specification of a
 * function to draw.  This is internal to Graphy.  In a real system,
 * Graphy would be in its own package; in that case, we could make this
 * package-private, which would hide it from the classes using Graphy,
 * which would be in their own pacakge.  We do that here by leavine of
 * the "public" before the world class, but since everything is in the
 * default package in this example, it's not really hidden.
 */

class GraphSpec {
    final GraphyFunction function;
    final Color color;

    GraphSpec(GraphyFunction f, Color c) {
        function = f;
        color = c;
    }
}
