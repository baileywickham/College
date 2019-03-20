import edu.calpoly.spritely.Tile;

import java.util.List;
import java.util.Random;

public abstract class EntityActive extends Entity implements Executable {
    protected static final Random rand = new Random();

    protected final int actionPeriod;

    protected EntityActive(final Point position, final List<Tile> tiles, final int actionPeriod) {
        super(position, tiles);
        this.actionPeriod = actionPeriod;
    }


    protected void scheduleActions(final EventSchedule eventSchedule, final WorldModel world) {
        eventSchedule.scheduleEvent(this, new Activity(world,this), actionPeriod);
    }


    protected Random getRandom() {
        return rand;
    }
}
