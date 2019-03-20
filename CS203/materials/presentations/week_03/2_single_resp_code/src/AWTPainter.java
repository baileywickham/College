import java.awt.*;

public class AWTPainter implements Visitor {

    private final Graphics graphics;

    public AWTPainter(Graphics graphics) {
        this.graphics = graphics;
    }

    public void visitCircle(Circle cir) {
        graphics.setColor(cir.getColor());
        Rectangle r = cir.getBounds();
        graphics.fillOval(r.x, r.y, r.width, r.height);
    }

    public void visitSquare(Square sq) {
        graphics.setColor(sq.getColor());
        Rectangle r = sq.getBounds();
        graphics.fillRect(r.x, r.y, r.width, r.height);
    }
}
