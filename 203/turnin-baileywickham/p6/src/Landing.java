
import java.awt.*;
import java.util.Random;

import edu.calpoly.spritely.SolidColorTile;


public class Landing implements Action {
    private Point point;
    private WorldModel w;
    private Random rand;

    public Landing(final Point point, final WorldModel w) {
        this.point = point;
        this.w = w;
        this.rand = new Random();
    }
    @Override
    public void executeAction(EventSchedule eventSchedule) {

        Duke duke = new Duke(point);
        for (int i= 0; i < 9; i++) {
            Point p = new Point(point.getX() -1 + i % 3, point.getY() -1 + i / 3);
            if (w.withinBounds(p)) {

                if (rand.nextBoolean()) {
                    w.setBackground(p.getY(),p.getX(), new SolidColorTile(new Color(229,47,50), w.getText(p)));
                } else {
                    w.setBackground(p.getY(),p.getX(), new SolidColorTile(new Color(3,116,118), w.getText(p)));

                }
                Entity e = w.getOccupant(p);
                if (e != null) {
                    SuperMiner s = new SuperMiner(e.position);
                    eventSchedule.unscheduleAllEvents(e);
                    w.removeEntity(e);
                    if (e instanceof MinerNotFull) {
                        w.addEntity(s);
                        s.init(w,eventSchedule);
                    }
                }
            }
        }
        w.addEntity(duke);
        duke.init(w, eventSchedule);
    }
}
