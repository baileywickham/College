public interface Animatable {
    Action createAnimationAction(int repeatCount);
    void nextImage();
    int getAnimationPeriod();
}
