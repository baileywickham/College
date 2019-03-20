public final class MinerFull extends  Miner{

    protected MinerFull(final Point position, final int actionPeriod, final int animationPeriod,
                        final int resourceLimit) {
        super(position, VirtualWorld.minerFullTiles, actionPeriod, animationPeriod, resourceLimit, resourceLimit);
    }


    @Override
    Miner transformation() {
        return new MinerNotFull(position,actionPeriod,animationPeriod,resourceLimit);
    }

    @Override
    boolean getTarget(Entity entity) {
        return entity instanceof Blacksmith;
    }

}
