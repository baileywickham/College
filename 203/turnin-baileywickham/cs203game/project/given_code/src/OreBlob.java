
public class OreBlob extends Movers   {
    private final int actionPeriod;

    protected OreBlob(final Point position, final  int actionPeriod, final int animationPeriod) {
        super(position, VirtualWorld.oreTiles, actionPeriod,animationPeriod);
        this.actionPeriod = actionPeriod;
    }


    @Override
    public void executeActivity(WorldModel world, EventSchedule eventSchedule) {
        Entity blobTarget = world.findNearest(
                this.getPosition(), entity -> entity instanceof Vein);
        long nextPeriod = this.actionPeriod;

        if (blobTarget != null)
        {
            Point tgtPos = blobTarget.getPosition();

            if (this.moveTo(world, blobTarget, eventSchedule))
            {
                Quake quake = new Quake(tgtPos);

                world.addEntity(quake);
                nextPeriod += actionPeriod;

                quake.scheduleActions(eventSchedule, world);
            }
        }

        eventSchedule.scheduleEvent(this,
                new Activity(world, this),
                nextPeriod);
    }

    @Override
    protected boolean canPassThrough(WorldModel world, Point next) {
            if (world.getOccupant(next) instanceof Ore || world.getOccupant(next) == null) {
                return true;
        }
            return false;
    }
}
