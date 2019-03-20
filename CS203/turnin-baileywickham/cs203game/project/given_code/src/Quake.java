public class Quake extends EntityAnimatable {


    protected Quake(final Point posititon) {
        super(posititon, VirtualWorld.quakeTiles, 1100, 100);
    }
    @Override
    protected int repeatCount() {
        return 10;
    }

    @Override
    public void executeActivity(WorldModel w, EventSchedule e) {

        e.unscheduleAllEvents(this);
        w.removeEntity(this);
    }

}
