
import java.io.File;
import java.io.IOException;
import java.util.*;

import edu.calpoly.spritely.AnimationFrame;
import edu.calpoly.spritely.ImageTile;
import edu.calpoly.spritely.Size;
import edu.calpoly.spritely.SolidColorTile;
import edu.calpoly.spritely.SpriteWindow;
import edu.calpoly.spritely.Tile;

/**
 * A representation of a virtual world, containing various entities
 * that move around a grid.  The data structures representing the
 * current state of the virtual world are split out in a separate
 * model class, called WorldModel.
 */
public final class VirtualWorld
{
    private static final Size TILE_SIZE = new Size(32, 32);
    private static final Size WORLD_SIZE = new Size(40, 30);
    // Name, as decided by CSC 203 in Spring 2018:
    private static final String NAME = "Minecraft 2: Electric Boogaloo";
    private static final File IMAGE_DIR = new File("images");

    private static final String[] BACKGROUND = new String[] {
        "                   R                    ",
        "                    R                  R",
        " RR   RR   RR                           ",
        "R  R R  R R  R                          ",
        "   R R  R    R                          ",
        " RR  R  R  RR                           ",
        "R    R  R    R                          ",
        "R    R  R R  R                          ",
        "RRRR  RR   RR                           ",
        "                                        ",
        "                                        ",
        "                                        ",
        "                                        ",
        "                    R                  R",
        "                   R                    ",
        "                    R                  R",
        "                   R                    ",
        "                                        ",
        "                                        ",
        "                                        ",
        "                                        ",
        "                                        ",
        "                                        ",
        "                                        ",
        "                                        ",
        "                                        ",
        "                                        ",
        "                                        ",
        "                   R                    ",
        "                    R                   "
    };


    public final static List<Tile> blacksmithTiles;
    public final static List<Tile> blobTiles;
    public final static List<Tile> minerTiles;
    public final static List<Tile> minerFullTiles;
    public final static List<Tile> obstacleTiles;
    public final static List<Tile> oreTiles;
    public final static List<Tile> quakeTiles;
    public final static List<Tile> veinTiles;
    public final static List<Tile> grassTiles;
    public final static List<Tile> rockTiles;

    public final static Tile grassTile;
    public final static Tile rockTile;

    private final WorldModel model;
    private final EventSchedule eventSchedule;
    private final SpriteWindow window;
    private final double timeScale;

    static
    {
        blacksmithTiles = loadImages("blacksmith", "B");
        blobTiles = loadImages("blob", "===*===*=");
        minerTiles = loadImages("miner", "mMmMm");
        minerFullTiles = loadImages("miner_full", "mM$mM");
        obstacleTiles = loadImages("obstacle", "O");
        oreTiles = loadImages("ore", "$");
        quakeTiles = loadImages("quake", "QqQqQq");
        veinTiles = loadImages("vein", "V");
        grassTiles = loadImages("grass", ".");
        rockTiles = loadImages("rocks", "=");
        grassTile = getImageTile("grass.png", '.');
        rockTile = getImageTile("rocks.png", '=');
    }

    private static Tile getImageTile(String imageFileName, char text) {
        Tile t = null;
        File f = new File(IMAGE_DIR, imageFileName);
        try {
            t = new ImageTile(f, TILE_SIZE, text);
        } catch (IOException ex) {
            System.out.println("Fatal error:  Image not found in " + f);
            ex.printStackTrace();
            System.exit(1);
        }
        return t;
    }
    /**
     * Load a list of images for an entity.  text gives a series of
     * characters that serve as the animation for the text
     * representation of the entity when in text mode.
     */
    private static List<Tile> loadImages(String fileBasename, String text) {
        int len = text.length();
        List<Tile> result = new ArrayList<Tile>(len);
        if (len == 1) {
            result.add(getImageTile(fileBasename + ".png", text.charAt(0)));
        } else {
            for (int i = 1; i <= len; i++) {
                String name = fileBasename + i + ".png";
                result.add(getImageTile(name, text.charAt(i - 1)));
            }
        }
        return Collections.unmodifiableList(result);
    }

    public VirtualWorld(double timeScale)
    {
        this.timeScale = timeScale;
        window = new SpriteWindow(NAME, WORLD_SIZE);
        window.setFps(30f);
        window.setTileSize(TILE_SIZE);
        System.out.println(NAME + ".  Press 'q' to quit.");
        window.setKeyTypedHandler((char ch) -> {
            if (ch == 'q' || ch == 'Q') {
                window.stop();
            }
        });
        model = new WorldModel(WORLD_SIZE);
        eventSchedule = new EventSchedule();
        setupBackground();
        createInitialEntities();
        scheduleInitialActions();
    }

    private void setupBackground() {
        for (int y = 0; y < WORLD_SIZE.height; y++) {
            for (int x = 0; x < WORLD_SIZE.width; x++) {
                char c = BACKGROUND[y].charAt(x);
                if (c == ' ') {
                    model.setBackground(y,x, grassTile);
                } else if (c == 'R') {
                    model.setBackground(y,x,rockTile);
                } else {
                    assert false;
                }
            }
        }
    }


    private void createInitialEntities() {
        addInitial(Entity.createBlacksmith(new Point(0, 11)));
        addInitial(Entity.createBlacksmith(new Point(0, 29)));
        addInitial(Entity.createBlacksmith(new Point(19, 14)));
        addInitial(Entity.createBlacksmith(new Point(19, 29)));
        addInitial(Entity.createBlacksmith(new Point(20, 0)));
        addInitial(Entity.createBlacksmith(new Point(39, 0)));
        addInitial(Entity.createBlacksmith(new Point(39, 14)));
        addInitial(Entity.createBlacksmith(new Point(39, 29)));
        addInitial(Entity.createMinerNotFull(2, new Point(12,23), 954, 300));
        addInitial(Entity.createMinerNotFull(2, new Point(17,22), 982, 310));
        addInitial(Entity.createMinerNotFull(2, new Point(23,6), 777, 320));
        addInitial(Entity.createMinerNotFull(2, new Point(24,26), 851, 90));
        addInitial(Entity.createMinerNotFull(2, new Point(31,15), 933, 95));
        addInitial(Entity.createMinerNotFull(2, new Point(31,26), 734, 87));
        addInitial(Entity.createMinerNotFull(2, new Point(37,10), 400, 33));
        addInitial(Entity.createMinerNotFull(2, new Point(37,18), 888, 100));
        addInitial(Entity.createMinerNotFull(2, new Point(37,6), 991, 317));
        addInitial(Entity.createMinerNotFull(2, new Point(5,6), 992, 318));
        addInitial(Entity.createMinerNotFull(2, new Point(6,25), 930, 106));
        addInitial(Entity.createMinerNotFull(2, new Point(6,3), 813, 92));
        addInitial(Entity.createMinerNotFull(2, new Point(7,13), 913, 97));
        addInitial(Entity.createObstacle(new Point(10, 23)));
        addInitial(Entity.createObstacle(new Point(10, 24)));
        addInitial(Entity.createObstacle(new Point(11, 21)));
        addInitial(Entity.createObstacle(new Point(11, 24)));
        addInitial(Entity.createObstacle(new Point(11, 25)));
        addInitial(Entity.createObstacle(new Point(12, 22)));
        addInitial(Entity.createObstacle(new Point(12, 25)));
        addInitial(Entity.createObstacle(new Point(12, 26)));
        addInitial(Entity.createObstacle(new Point(13, 22)));
        addInitial(Entity.createObstacle(new Point(13, 26)));
        addInitial(Entity.createObstacle(new Point(14, 23)));
        addInitial(Entity.createObstacle(new Point(14, 24)));
        addInitial(Entity.createObstacle(new Point(26, 26)));
        addInitial(Entity.createObstacle(new Point(27, 25)));
        addInitial(Entity.createObstacle(new Point(28, 19)));
        addInitial(Entity.createObstacle(new Point(28, 25)));
        addInitial(Entity.createObstacle(new Point(29, 20)));
        addInitial(Entity.createObstacle(new Point(29, 26)));
        addInitial(Entity.createObstacle(new Point(30, 21)));
        addInitial(Entity.createObstacle(new Point(31, 22)));
        addInitial(Entity.createObstacle(new Point(32, 23)));
        addInitial(Entity.createObstacle(new Point(5, 20)));
        addInitial(Entity.createObstacle(new Point(5, 21)));
        addInitial(Entity.createObstacle(new Point(6, 20)));
        addInitial(Entity.createObstacle(new Point(6, 21)));
        addInitial(Entity.createObstacle(new Point(7, 20)));
        addInitial(Entity.createObstacle(new Point(7, 21)));
        addInitial(Entity.createObstacle(new Point(8, 21)));
        addInitial(Entity.createObstacle(new Point(8, 22)));
        addInitial(Entity.createObstacle(new Point(9, 22)));
        addInitial(Entity.createObstacle(new Point(9, 23)));
        addInitial(Entity.createVein(new Point(10, 25), 8366));
        addInitial(Entity.createVein(new Point(14, 22), 8248));
        addInitial(Entity.createVein(new Point(21, 20), 9294));
        addInitial(Entity.createVein(new Point(27, 6), 9456));
        addInitial(Entity.createVein(new Point(28, 23), 13422));
        addInitial(Entity.createVein(new Point(33, 11), 10278));
        addInitial(Entity.createVein(new Point(33, 13), 10865));
        addInitial(Entity.createVein(new Point(33, 3), 11101));
        addInitial(Entity.createVein(new Point(34, 19), 11702));
        addInitial(Entity.createVein(new Point(6, 11), 15026));
        addInitial(Entity.createVein(new Point(7, 11), 9377));
        addInitial(Entity.createVein(new Point(8, 11), 13146));

    }

    private void addInitial(Entity entity) {
        assert !model.isOccupied(entity.getPosition());
        model.addEntity(entity);
    }



    private void scheduleInitialActions()
    {

        eventSchedule.scheduleEvent(model, new Animation(model,0),0);
        for (Entity entity : model.getEntities())
        {
            Entity.scheduleActions(entity, eventSchedule, model);
        }
    }

    /**
     * Entry point to run the virtual world simulation.
     */
    public void runSimulation() {
        model.paint(window.getInitialFrame());
        window.start();
        while (true) {
            AnimationFrame frame = window.waitForNextFrame();
            if (frame == null) {
                break;
            }
            eventSchedule.processEvents(window.getTimeSinceStart() * timeScale);
            model.paint(frame);
            window.showNextFrame();
        }
    }
}
