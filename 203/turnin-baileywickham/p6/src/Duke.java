import java.util.ArrayList;
import java.util.List;

public class Duke extends Movers {

    protected Duke(final Point pos ) {
        super(pos, VirtualWorld.dukeTiles, 954, 400 );
    }


    @Override
    protected boolean canPassThrough(WorldModel world, Point next) {
        return !world.isOccupied(next);
    }

    @Override
    public void executeActivity(WorldModel w, EventSchedule e) {
        Entity target = w.findNearest(position, this::isTarget);
        if (target != null && moveTo(w, target, e)) {
            kill(w,e,target);
        } else {
            e.scheduleEvent(this, new Activity(w, this), 400);
        }
    }

    private boolean isTarget(Entity e) {
        return e instanceof MinerNotFull;
    }
    private void kill(WorldModel w, EventSchedule e, Entity target ) {
        SuperMiner s = new SuperMiner(this.position);
        e.unscheduleAllEvents(this);
        e.unscheduleAllEvents(target);
        w.removeEntity(this);
        w.removeEntity(target);
        w.addEntity(s);
        s.init(w,e);

    }
    @Override
    protected List<Point> potentialNeighbors(final Point p) {
        List<Point> result = new ArrayList<>();
        result.add(new Point(p.getX() + 1, p.getY() + 1));
        result.add(new Point(p.getX() - 1, p.getY() - 1));
        result.add(new Point(p.getX() - 1, p.getY() + 1));
        result.add(new Point(p.getX() + 1, p.getY() - 1));
        result.add(new Point(p.getX(), p.getY() + 1));
        result.add(new Point(p.getX(), p.getY() - 1));
        result.add(new Point(p.getX() + 1, p.getY()));
        result.add(new Point(p.getX() - 1, p.getY()));

        return result;

    }
}
