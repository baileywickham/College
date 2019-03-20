
import java.io.File;
import java.io.IOException;
import java.util.*;

import edu.calpoly.spritely.AnimationFrame;
import edu.calpoly.spritely.ImageTile;
import edu.calpoly.spritely.Size;
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
        addInitial(new Blacksmith(new Point(0, 11)));
        addInitial(new Blacksmith(new Point(0, 29)));
        addInitial(new Blacksmith(new Point(19, 14)));
        addInitial(new Blacksmith(new Point(19, 29)));
        addInitial(new Blacksmith(new Point(20, 0)));
        addInitial(new Blacksmith(new Point(39, 0)));
        addInitial(new Blacksmith(new Point(39, 14)));
        addInitial(new Blacksmith(new Point(39, 29)));
        addInitial(new MinerNotFull(new Point(12,23), 2,954, 300));
        addInitial(new MinerNotFull(new Point(17,22), 2,982, 310));
        addInitial(new MinerNotFull(new Point(23,6), 2,777, 320));
        addInitial(new MinerNotFull(new Point(24,26), 2,851, 90));
        addInitial(new MinerNotFull(new Point(31,15), 2,933, 95));
        addInitial(new MinerNotFull(new Point(31,26), 2,734, 87));
        addInitial(new MinerNotFull(new Point(37,10), 2,400, 33));
        addInitial(new MinerNotFull(new Point(37,18), 2,888, 100));
        addInitial(new MinerNotFull(new Point(37,6), 2,991, 317));
        addInitial(new MinerNotFull(new Point(5,6), 2,992, 318));
        addInitial(new MinerNotFull(new Point(6,25), 2,930, 106));
        addInitial(new MinerNotFull(new Point(6,3), 2,813, 92));
        addInitial(new MinerNotFull(new Point(7,13),2, 913, 97));
        addInitial(new Obstacle(new Point(10, 23)));
        addInitial(new Obstacle(new Point(10, 24)));
        addInitial(new Obstacle(new Point(11, 21)));
        addInitial(new Obstacle(new Point(11, 24)));
        addInitial(new Obstacle(new Point(11, 25)));
        addInitial(new Obstacle(new Point(12, 22)));
        addInitial(new Obstacle(new Point(12, 25)));
        addInitial(new Obstacle(new Point(12, 26)));
        addInitial(new Obstacle(new Point(13, 22)));
        addInitial(new Obstacle(new Point(13, 26)));
        addInitial(new Obstacle(new Point(14, 23)));
        addInitial(new Obstacle(new Point(14, 24)));
        addInitial(new Obstacle(new Point(26, 26)));
        addInitial(new Obstacle(new Point(27, 25)));
        addInitial(new Obstacle(new Point(28, 19)));
        addInitial(new Obstacle(new Point(28, 25)));
        addInitial(new Obstacle(new Point(29, 20)));
        addInitial(new Obstacle(new Point(29, 26)));
        addInitial(new Obstacle(new Point(30, 21)));
        addInitial(new Obstacle(new Point(31, 22)));
        addInitial(new Obstacle(new Point(32, 23)));
        addInitial(new Obstacle(new Point(5, 20)));
        addInitial(new Obstacle(new Point(5, 21)));
        addInitial(new Obstacle(new Point(6, 20)));
        addInitial(new Obstacle(new Point(6, 21)));
        addInitial(new Obstacle(new Point(7, 20)));
        addInitial(new Obstacle(new Point(7, 21)));
        addInitial(new Obstacle(new Point(8, 21)));
        addInitial(new Obstacle(new Point(8, 22)));
        addInitial(new Obstacle(new Point(9, 22)));
        addInitial(new Obstacle(new Point(9, 23)));
        addInitial(new Vein(new Point(10, 25), 8366));
        addInitial(new Vein(new Point(14, 22), 8248));
        addInitial(new Vein(new Point(21, 20), 9294));
        addInitial(new Vein(new Point(27, 6), 9456));
        addInitial(new Vein(new Point(28, 23), 13422));
        addInitial(new Vein(new Point(33, 11), 10278));
        addInitial(new Vein(new Point(33, 13), 10865));
        addInitial(new Vein(new Point(33, 3), 11101));
        addInitial(new Vein(new Point(34, 19), 11702));
        addInitial(new Vein(new Point(6, 11), 15026));
        addInitial(new Vein(new Point(7, 11), 9377));
        addInitial(new Vein(new Point(8, 11), 13146));

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
            if (entity instanceof EntityActive) {
                EntityActive e = (EntityActive) entity;
                        e.scheduleActions(eventSchedule, model);
            }
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
