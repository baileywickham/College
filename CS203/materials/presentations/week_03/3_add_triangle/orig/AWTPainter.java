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

    // Note to self:  Drawing a triangle in AWT is kind of like this.
    //   int[] xPts = new int[3];
    //   int[] yPts = new int[3];
    //   <mumble>
    //   graphics.drawPolygon(xPts, yPts, 3);

}
