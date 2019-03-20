import edu.calpoly.spritely.Tile;

import java.util.List;

public abstract class Miner extends Movers {

    protected final int resourceLimit;
    protected int resourceCount;

    protected Miner(final Point position, final List<Tile> tiles,
                    final int actionPeriod, final int animationPeriod,
                    final int resourceLimit, final int resourceCount) {

        super(position, tiles, actionPeriod, animationPeriod);
        this.resourceLimit = resourceLimit;
        this.resourceCount = resourceCount;
    }

    @Override
    public final void executeActivity(final WorldModel world, final EventSchedule eventSchedule) {
        Entity target = world.findNearest(position, this::getTarget);

        if (target != null && moveTo(world, target, eventSchedule) && inventoryFull()) {
            transform(world, eventSchedule);
        } else {
            eventSchedule.scheduleEvent(this, new Activity(world, this), actionPeriod);
        }
    }
    abstract boolean getTarget(Entity entity);

    private void transform(WorldModel world, EventSchedule eventSchedule) {
        Miner m = transformation();
        world.removeEntity(this);
        eventSchedule.unscheduleAllEvents(this);
        world.addEntity(m);
        m.scheduleActions(eventSchedule, world);
    }
    abstract Miner transformation();
    private boolean inventoryFull() {
        return resourceCount >= resourceLimit;
    }

}
