public final class Activity implements Action {
    private WorldModel worldModel;
    private Executable execute;

    public Activity(WorldModel worldModel, final Executable action) {
        this.worldModel = worldModel;
        this.execute = action;
    }
    @Override
    public void executeAction(final EventSchedule eventSchedule) {
        execute.executeActivity(worldModel, eventSchedule);
    }


}
