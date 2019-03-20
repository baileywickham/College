public class Activity implements Action {
    private WorldModel worldModel;
    private Entity entity;

    public Activity(WorldModel worldModel, Entity entity) {
        this.worldModel = worldModel;
        this.entity = entity;
    }
    public void
    executeAction(EventSchedule eventSchedule)
    {
        switch (this.entity.getEntityKind())
        {
            case MINER_FULL:
                entity.executeMinerFullActivity(this.worldModel,
                        eventSchedule);
                break;

            case MINER_NOT_FULL:
                entity.executeMinerNotFullActivity(this.worldModel,
                        eventSchedule);
                break;

            case ORE:
                entity.executeOreActivity(this.worldModel, eventSchedule);
                break;

            case ORE_BLOB:
                entity.executeOreBlobActivity(this.worldModel, eventSchedule);
                break;

            case QUAKE:
                entity.executeQuakeActivity(this.worldModel, eventSchedule);
                break;

            case VEIN:
                entity.executeVeinActivity(this.worldModel, eventSchedule);
                break;

            default:
                throw new UnsupportedOperationException(
                        String.format("executeActivityAction not supported for %s",
                                this.entity.getEntityKind()));
        }
    }

}
