public final class Animation implements Action {
    private Animatable animatable;
    private int repeatCount;

    public Animation(Animatable animation, int repeatCount) {
        this.animatable = animation;
        this.repeatCount = repeatCount;
    }
    public void executeAction(EventSchedule eventSchedule)
    {
        animatable.nextImage();

        if (repeatCount != 1)
        {
            eventSchedule.scheduleEvent(animatable,
                    animatable.createAnimationAction(Math.max(repeatCount - 1, 0)),
                    animatable.getAnimationPeriod());
        }
    }
}
