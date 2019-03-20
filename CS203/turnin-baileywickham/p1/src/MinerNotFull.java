public class MinerNotFull extends Miner {
    protected MinerNotFull(final Point position, final int actionPeriod, final int animationPeriod,
                           final int resourceLimit) {
        super(position, VirtualWorld.minerTiles, actionPeriod, animationPeriod, resourceLimit, 0);
    }

    @Override
    boolean getTarget(Entity entity) {
        return entity instanceof Ore;
    }

    @Override
    Miner transformation() {
        return new MinerFull(position,actionPeriod,animationPeriod,resourceLimit);
    }
}
