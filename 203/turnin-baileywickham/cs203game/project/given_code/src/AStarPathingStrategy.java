import java.util.*;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.function.ToIntBiFunction;

public class AStarPathingStrategy implements PathingStrategy {
    private  DebugGrid debug;

    @Override
    public List<Point> computePath(Point start, Point end, Predicate<Point> canPassThrough, Function<Point, List<Point>> potentialNeighbors, ToIntBiFunction<Point, Point> stepsFromTo) {
        final ArrayList<Point> closed = new ArrayList<Point>(); // lookups are slow
        final ArrayList<Point> open = new ArrayList<Point>();
        open.add(start);

        final Map<Point, Point> cameFrom = new HashMap<Point,Point>();

        final Map<Point, Double> gScore = new HashMap<Point,Double>();
        gScore.put(start, 0.0); //going to self == 0

        final Map<Point, Double> fScore = new HashMap<Point, Double>();
        int est = stepsFromTo.applyAsInt(start,end);
        fScore.put(start, costEstimate(start,end,est));

        while (!open.isEmpty()) {
            final Point curr = Collections.min(open,
                    Comparator.comparing(p -> fScore.getOrDefault(p, Double.MAX_VALUE)));

            if (curr.adjacent(end)) {
                return reconstructPath(cameFrom, curr);
            }

            open.remove(curr);
            closed.add(curr);

            final double currentGS = gScore.getOrDefault(curr, Double.MAX_VALUE);

            for (final Point p : potentialNeighbors.apply(curr)) {
                if (!canPassThrough.test(p) || closed.contains(p)) {
                    continue;
                }
                final double newGS = currentGS + stepsFromTo.applyAsInt(curr, p);

                if (!open.contains(p)) {
                    open.add(p);
                } else if (newGS >= gScore.getOrDefault(p, Double.MAX_VALUE)) {
                    continue;
                }

                cameFrom.put(p,curr);
                gScore.put(p,newGS);
                int oth = stepsFromTo.applyAsInt(p,end);
                fScore.put(p, newGS + costEstimate(p, end, oth));

            }
            if (DebugGrid.ENABLED) paintDebug(open,closed);
        }
        return Collections.emptyList();
    }

    @Override
    public void setDebugGrid(DebugGrid debug) {
        this.debug = debug;
    }
    protected double costEstimate(Point p1, Point p2, int numOfSteps) {
        return numOfSteps * 1.00011;
    }

    private List<Point> reconstructPath(final Map<Point,Point> comeFrom, Point curr) {
        final LinkedList<Point> totalPath = new LinkedList<Point>();
        totalPath.add(curr);
        while (comeFrom.containsKey(curr)) {
            curr = comeFrom.get(curr);
            totalPath.addFirst(curr);
        }
        totalPath.removeFirst();
        return totalPath;
    }
    private void paintDebug(final Iterable<Point> open, final Iterable<Point> closed) {
        if (debug == null) return;
        for (Point p : open) {
            debug.setGridValue(p, DebugGrid.OPEN_SET_TILE);
        }
        for (Point p : closed) {
            debug.setGridValue(p, DebugGrid.CLOSED_SET_TILE);
        }
        debug.showFrame();
    }
}

