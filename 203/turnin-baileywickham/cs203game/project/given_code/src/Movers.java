import edu.calpoly.spritely.Tile;

import java.util.ArrayList;
import java.util.List;

public abstract class Movers extends EntityAnimatable {
    protected Movers(final Point position, final List<Tile> tiles, final int actionPeriod, final int animationPeriod) {
        super(position,tiles,actionPeriod,animationPeriod);
    }
    private static final PathingStrategy pathingStrategy;
    static {
        pathingStrategy = new AStarPathingStrategy();
    }


    @Override
    protected int repeatCount() {
        return 0;
    }

    protected boolean moveTo(final WorldModel world, final Entity target, EventSchedule eventSchedule) {

        if (this.position.adjacent(target.position)) {
            world.removeEntity(target);
            eventSchedule.unscheduleAllEvents(target);
            return true;
        }
        Point next = nextPosition(world,target.position);

        if (!position.equals(next)) {
            world.moveEntity(this, next);
        }
        return false;
    }
    protected abstract boolean canPassThrough(WorldModel world, Point next);

    protected List<Point> potentialNeighbors(Point p) {
        List<Point> result = new ArrayList<>();
        result.add(new Point(p.getX(), p.getY() + 1));
        result.add(new Point(p.getX(), p.getY() - 1));
        result.add(new Point(p.getX() - 1, p.getY()));
        result.add(new Point(p.getX() + 1, p.getY()));
        return result;

    }

    private static int stepsFromTo(Point p1, Point p2) {
        return Math.abs(p1.getX() - p2.getX()) + Math.abs(p1.getY() - p2.getY());
    }

    private Point nextPosition(final WorldModel world, final Point destPos) {

        List<Point> path = pathingStrategy.computePath(position, destPos,
                pnt -> world.withinBounds(pnt) && canPassThrough(world, pnt),
                this::potentialNeighbors, Movers::stepsFromTo);

        return (path == null || path.isEmpty()) ? position : path.get(0);
    }

}
