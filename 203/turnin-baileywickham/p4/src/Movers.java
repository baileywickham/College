import edu.calpoly.spritely.Tile;

import java.util.List;

import static java.lang.Integer.*;

public abstract class Movers extends EntityAnimatable {
    protected Movers(final Point position, final List<Tile> tiles, final int actionPeriod, final int animationPeriod) {
        super(position,tiles,actionPeriod,animationPeriod);
    }

    @Override
    protected int repeatCount() {
        return 0;
    }

    protected boolean moveTo(final WorldModel world, final Entity target, EventSchedule eventSchedule) {

        if (Point.adjacent(this.position, target.position)) {
            world.removeEntity(target);
            eventSchedule.unscheduleAllEvents(target);
            return true;
        } else {
            Point nextPos = nextPoint(world, target.position);

            if (!this.position.equals(nextPos)) {
                Entity occupant = world.getOccupant(nextPos);
                if (occupant != null) {
                    eventSchedule.unscheduleAllEvents(occupant);
                }

                world.moveEntity(this, nextPos);
            }
            return false;
        }
    }
    private Point nextPoint(final WorldModel world, final Point target) {
        int horiz = signum(target.getX() - this.position.getX());
        Point newPos = new Point(this.position.getX() + horiz,
                this.position.getY());

        if (horiz == 0 || world.isOccupied(newPos))
        {
            int vert = signum(target.getY() - this.position.getY());
            newPos = new Point(this.position.getX(),
                    this.position.getY() + vert);

            if (vert == 0 || world.isOccupied(newPos))
            {
                newPos = this.position;
            }
        }

        return newPos;
    }
}
