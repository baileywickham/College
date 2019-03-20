import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.LinkedList;

import edu.calpoly.spritely.AnimationFrame;
import edu.calpoly.spritely.SpriteWindow;
import edu.calpoly.spritely.Size;
import edu.calpoly.spritely.Tile;
import edu.calpoly.spritely.ImageTile;
import edu.calpoly.spritely.SolidColorTile;


public class PathingMain 
{
    // The layout of the world by default. 
    private static final String[] DEFAULT_LAYOUT = new String[] {
        "....................",
        "....................",
        "..W....O............",
        "........O...........",
        ".........O..........",
        "..........O.........",
        "...........O........",
        "............O.......",
        "...........O........",
        "..........O.........",
        ".........O..........",
        ".OOOOOOOO...........",
        "....................",
        "..............G.....",
        "...................."
    };

    public static final Size TILE_SIZE = new Size(32, 32);

    // Position of the "wyvern," the mythical animal that's trying
    // to get to the goal.
    private Point wPos;

    private GridValue[][] grid;

    private SpriteWindow window;

    private int delayAtEnd;

    public PathingMain(double fps, int delayAtEnd) 
    {
        this(DEFAULT_LAYOUT, fps, delayAtEnd);
    }

    /**
     * Constructor for pathing algorithm.  Do not change the signature
     * of this constructor.
     */
    public PathingMain(String[] layout, double fps, int delayAtEnd)
    {
        this.delayAtEnd = delayAtEnd;
        Size worldSize = new Size(layout[0].length(), layout.length);  // w, h
        wPos = null;

        //
        // Set up the grid, as specified by layout.
        //
        grid = new GridValue[worldSize.height][worldSize.width];
        for (int y = 0; y < worldSize.height; y++) {
            assert layout[y].length() == worldSize.width;
            for (int x = 0; x < worldSize.width; x++) {
                char ch = layout[y].charAt(x);
                if (ch == 'W')   {
                    assert wPos == null;
                    wPos = new Point(x, y);
                    grid[y][x] = GridValue.START;
                } else if (ch == 'G') {
                    grid[y][x] = GridValue.GOAL;
                } else if (ch == 'O') {
                    grid[y][x] = GridValue.OBSTACLE;
                } else {
                    assert ch == '.';
                    grid[y][x] = GridValue.BACKGROUND;
                }
            }
        }
        assert wPos != null;

        window = new SpriteWindow("PathingMain", worldSize);
        window.setFps(fps);
        window.setTileSize(TILE_SIZE);
        window.start();
    }


    private boolean withinBounds(Point p)
    {
        return p.y >= 0 && p.y < grid.length &&
               p.x >= 0 && p.x < grid[0].length;
    }

    //
    // Show the next frame of animation.  Return true if we are still
    // animating, false otherwise.
    //
    private boolean showNextFrame() {
        AnimationFrame frame = window.waitForNextFrame();
        if (frame == null) {
            // For example, if the window was closed
            return false;
        }
        for (int y = 0; y < grid.length; y++) {
            for (int x = 0; x < grid[y].length; x++) {
                GridValue v = grid[y][x];
                frame.addTile(x, y, v.tile);
            }
        }
        window.showNextFrame();
        return true;
    }

    // Recursive method to search for a path.  We try just always moving to
    // the right.
    //
    // Returns true if path is found, false otherwise.
    //
    private boolean searchForPath(Point currentPos) {
        Point newPos = new Point(currentPos.x + 1, currentPos.y);
        if (!withinBounds(newPos)) {
            return false;
        }
        GridValue occupant = grid[newPos.y][newPos.x];
        if (occupant == GridValue.GOAL) {
            // We found it!
            return true;
        } else if (occupant == GridValue.BACKGROUND) {
            // Keep looking
            grid[newPos.y][newPos.x] = GridValue.PATH;
            boolean ok = showNextFrame();
            if (!ok) {
                return false;
            } else {
                return searchForPath(newPos);
            }
        } else {
            // We're blocked
            return false;
        }
    }

    /**
     * @return true if a path is found, false otherwise
     */
    public boolean run() {
        showNextFrame();
        boolean found = searchForPath(wPos);
        if (found) {
            System.out.println("We found the goal!");
        } else {
            System.out.println("The wyvern failed to find the goal.");
        }
        window.pauseAnimation(delayAtEnd);      // Wait a bit
        window.stop();
        return found;
    }
}
