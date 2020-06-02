public final class TestAnimatable implements Animatable {
    int counter = 0;
    public int getCounter() {
        return this.counter;
    }

    public Action createAnimationAction(int repeatCount) {

            return new Animation(this, repeatCount);
    }

    @Override
    public void nextImage() {
        counter++;
    }

    @Override
    public int getAnimationPeriod() {
        return 1;
    }
}
