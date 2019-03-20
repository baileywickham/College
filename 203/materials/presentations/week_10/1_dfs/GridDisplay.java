/**
 * A simple grid display on a text screen.  This class displays
 * a fixed grid on the terminal screen.  Each tile on the grid
 * is represented by a character.  Whenever the grid is updated,
 * the cursor is moved to the top-left part of the screen, so
 * you can get an illusion of motion.
 * <p>
 * You don't need to modify the code in this file.  It is being
 * provided as a text-only alternative to the "processing-core"
 * library for the current lab and/or assignment.
 */
public class GridDisplay {

    private char[][] tiles;

    /**
     * Create a new GridDisplay of the specified size, with all
     * tiles blank (that is, ' ').
     */
    public GridDisplay(int rows, int columns) {
        if (rows <= 0 || columns <= 0) {
            throw new IllegalArgumentException("rows: " + rows + ", columns: "
                                               + columns);
        }
        tiles = new char[rows][columns];
        for (int i = 0; i < tiles.length; i++) {
            for (int j = 0; j < tiles[i].length; j++) {
                tiles[i][j] = ' ';
            }
        }
    }

    /**
     * Clear the screen, and leave the cursor in the upper-left hand
     * corner.
     */
    public void clearScreen() {
        System.out.print("" + ((char) 27) + "[2J");
        // clear screen escape sequence 
        // see https://en.wikipedia.org/wiki/ANSI_escape_code
        sendCursorHome();
    }

    /**
     * Clear from the current cursor position to the end of the screen.
     */
    void clearToEndOfScreen() {
        System.out.print("" + ((char) 27) + "[0J");
        // see https://en.wikipedia.org/wiki/ANSI_escape_code
        System.out.flush();
    }

    //
    // Send the cursor to the upper-left hand corner
    private void sendCursorHome() {
        System.out.print("" + ((char) 27) + "[1;1H");
        // CUP escape sequence 
        // see https://en.wikipedia.org/wiki/ANSI_escape_code
        System.out.flush();
    }

    /**
     * Print out the current grid.
     */
    public void printGrid() {
        sendCursorHome();
        for (int i = 0; i < tiles.length; i++) {
            for (int j = 0; j < tiles[i].length; j++) {
                System.out.print(' ');
                System.out.print(tiles[i][j]);
            }
            System.out.println("    ");
        }
    }

    /**
     * Set a tile's value
     */
    public void setTile(int row, int col, char value) {
        tiles[row][col] = value;
    }

    /**
     * Delay for a given number of milliseconds
     */
    public void delayForMilliseconds(int ms) {
        try {
            Thread.sleep(ms);
        } catch (InterruptedException ex) {
            throw new RuntimeException(ex);
        }
    }
}
