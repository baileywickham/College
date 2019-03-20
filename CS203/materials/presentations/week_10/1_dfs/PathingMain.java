import java.util.List;
import java.util.ArrayList;
import java.util.LinkedList;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;


public class PathingMain 
{
    // Position of the "wyverin," the mythical animal that's trying
    // to get to the goal.
    private Point wPos;

    private LinkedList<Point> path;

    private static final int ANIMATION_TIME = 100;  // Milliseconds

    private GridValue[][] grid;
    private static final int ROWS = 15;
    private static final int COLS = 20;

    private GridDisplay display;

    /* run once to set up world */
    public void setup()
    {

        path = new LinkedList<>();
        wPos = new Point(2, 2);

        grid = new GridValue[ROWS][COLS];
        initializeGrid(grid);
        display = new GridDisplay(ROWS, COLS);
        draw();
    }

          /* set up a 2D grid to represent the world */
    private static void initializeGrid(GridValue[][] grid)
    {
        for (int row = 0; row < grid.length; row++)
        {
            for (int col = 0; col < grid[row].length; col++)
            {
                grid[row][col] = GridValue.BACKGROUND;
            }
        }

                     //set up some obstacles
        for (int row = 2; row < 8; row++)
        {
            grid[row][row + 5] = GridValue.OBSTACLE;
        }

        for (int row = 8; row < 12; row++)
        {
            grid[row][19 - row] = GridValue.OBSTACLE;
        }

        for (int col = 1; col < 8; col++)
        {
            grid[11][col] = GridValue.OBSTACLE;
        }

        grid[13][14] = GridValue.GOAL;
    }

     // "Draw" the current grid to display.
     //
    private void draw()
    {
        drawGrid();
        drawPath();
        // draw wyvern at wPos
        display.setTile(wPos.y, wPos.x, 'W');
    }

    private void drawGrid()
    {
        for (int row = 0; row < grid.length; row++)
        {
            for (int col = 0; col < grid[row].length; col++)
            {
                display.setTile(row, col, grid[row][col].drawnRepresentation);
            }
        }
    }

    private void drawPath()
    {
        for (Point p : path)
        {
            display.setTile(p.y, p.x, 'p');
        }
    }

      /* replace the below with a method that takes one step along
         a depth first search.
         this code provided only as an example of moving either
         down or to the right - it mostly is for illustrating
         how you might test the occupancy grid and add nodes to path!

         Returns true if something was added to the path
      */
    private boolean moveOnce(Point pos) {
        // Pos is the position where we are in the path.  If the path
        // is empty, it's the starting position.
        if (!path.isEmpty()) {
            pos = path.getLast();
        }

        // The nodes to try:  to the right, and down one
        Point[] tryNodes = new Point[] {
            new Point(pos.x - 1, pos.y ),
            new Point(pos.x, pos.y - 1),
            new Point(pos.x + 1, pos.y ),
            new Point(pos.x, pos.y + 1)
        };

        for (Point node : tryNodes) {
                     //test if this is a valid grid cell 
            if (!withinBounds(node, grid)) {
                continue;
            }
            if (grid[node.y][node.x] == GridValue.GOAL) {
                // We found the goal!
                return false;
            }
            if (grid[node.y][node.x] != GridValue.OBSTACLE && 
                grid[node.y][node.x] != GridValue.SEARCHED)
            {
                grid[node.y][node.x] = GridValue.SEARCHED;
                path.addLast(node);
                return true;
            }
        }
        if (path.isEmpty()) {
            return false;
        } else {
            path.removeLast();
            return true;
        }
    }

    private static boolean withinBounds(Point p, GridValue[][] grid)
    {
        return p.y >= 0 && p.y < grid.length &&
               p.x >= 0 && p.x < grid[0].length;
    }

    private void run() throws IOException {
        setup();
        display.clearScreen();
        BufferedReader input 
            = new BufferedReader(new InputStreamReader(System.in));
        
        while(true) {
            //
            // Note:  While debugging, you might want to pause here
            //        to press enter.  Otherwise, your debugging print
            //        statements might get lost.  If you need to pause
            //        here, just do this:
            //
            //        input.readLine()

            display.printGrid();
            System.out.println();
            System.out.println("    Enter 'c' to clear the current path.");
            System.out.println("    Enter 'e' to explore a new path.");
            System.out.println("          'e' plus a number for multiple steps");
            System.out.println("    Enter 'q' to quit.");
            System.out.print("                          \r");
            System.out.flush();
            String line = input.readLine();
            display.clearToEndOfScreen();
            if (line == null) {
                // EOF, that is, ^D (or ^Z on Windows)
                break;
            }
            line = line.toLowerCase().trim();
            if (line.equals("q")) {
                break;
            } else if (line.equals("c")) {
                path.clear();
                draw();
            } else if (line.startsWith("e")) {
                int numSteps = 1;
                line = line.substring(1).trim();
                if (!("".equals(line))) {
                    try {
                        numSteps = Integer.parseInt(line);
                    } catch (NumberFormatException ex) {
                        System.out.println(line + ":  " + ex);
                    }
                }
                for (int i = 0; i < numSteps; i++) {
                    System.out.println();
                    if (!moveOnce(wPos)) {
                        System.out.println("I'm either stuck, or I found the goal.");
                        break;
                    }
                    draw();
                    if (i > 0) {
                        display.delayForMilliseconds(100);
                        display.printGrid();
                        System.out.println();
                        System.out.println();
                        System.out.println();
                        System.out.println();
                        System.out.println();
                        System.out.println();
                    }
                }
            } else {
                System.out.println("Command \"" + line + "\" not recognized.");
            }
        }
    }

    public static void main(String args[]) throws IOException
    {
        PathingMain pathingMain = new PathingMain();
        pathingMain.run();
        System.out.println();
    }
}
