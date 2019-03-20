
public class Vein extends EntityActive {
    protected Vein(final Point position, final  int actionPeriod) {
        super(position,VirtualWorld.veinTiles, actionPeriod);
    }

    public void
    executeActivity(WorldModel world,
                        EventSchedule eventSchedule)
    {
        Point openPt = world.findOpenAround(this.getPosition());

        if (openPt != null) {
            Entity ore = new Ore(openPt, 20000 + rand.nextInt(10000));
            world.addEntity(ore);
            scheduleActions(eventSchedule, world);
        }
    }
}
