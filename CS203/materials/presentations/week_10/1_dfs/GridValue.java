
/**
 * An enum to represent the possible states of a grid. 
 * <p>
 * You might note that this enum is a little more involved than ones
 * you've seen to date.  You can look up enum in Horstmann to see
 * what's going on here, but in short, we define a character that's
 * attached to each enum value,  That character is used when we
 * print out our grid.
 */
public enum GridValue { 
    BACKGROUND ('.'), 
    OBSTACLE ('O'),
    GOAL ('G'), 
    SEARCHED ('+');

    public final char drawnRepresentation;

    GridValue(char drawnRepresentation) {
        this.drawnRepresentation = drawnRepresentation;
    }
}
