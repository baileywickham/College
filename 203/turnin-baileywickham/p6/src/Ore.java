public class Ore extends EntityActive {

    protected Ore(final Point position, final int actionPeriod) {
        super(position, VirtualWorld.blobTiles, actionPeriod);
    }

    public void
    executeActivity(WorldModel world,
                       EventSchedule eventSchedule)
    {
        Point pos = this.getPosition();    // store current position before removing

        world.removeEntity(this);
        eventSchedule.unscheduleAllEvents(this);

        OreBlob blob = new OreBlob(pos, actionPeriod / 4, 50 + rand.nextInt(100));

        world.addEntity(blob);
        blob.scheduleActions(eventSchedule, world);
    }
}
