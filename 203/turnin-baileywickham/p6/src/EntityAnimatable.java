import edu.calpoly.spritely.Tile;

import java.util.List;

public abstract class EntityAnimatable extends EntityActive implements Animatable {

    protected final int animationPeriod;

    protected EntityAnimatable(final Point position, final List<Tile> tiles, final int actionPeriod, final int animationPeriod) {
        super(position,tiles,actionPeriod);
        this.animationPeriod = animationPeriod;
    }

    @Override
    public final void scheduleActions(final EventSchedule eventSchedule, final WorldModel world) {
        super.scheduleActions(eventSchedule, world);
        eventSchedule.scheduleEvent(this, new Animation(this, repeatCount()), getAnimationPeriod());
    }
    protected abstract int repeatCount();

    @Override
    public void nextImage() {
        this.tileIndex = (this.tileIndex + 1) % this.tiles.size();
    }

    public final int getAnimationPeriod() {
        return animationPeriod;
    }

    public void init(final WorldModel world, final EventSchedule eventSchedule) {
        super.init(world,eventSchedule);
        eventSchedule.scheduleEvent(this, new Animation(this, repeatCount()), getAnimationPeriod());
    }

}
