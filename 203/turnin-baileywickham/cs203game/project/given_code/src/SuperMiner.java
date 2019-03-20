public class SuperMiner extends Miner {

    protected SuperMiner(final Point position) {
        super(position, VirtualWorld.superMinerTiles, 300, 200, 30, 0);
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
