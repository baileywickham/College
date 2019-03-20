import edu.calpoly.spritely.Tile;

import java.util.List;

public abstract class Entity {
    protected final List<Tile> tiles;
    protected Point position;
    protected int tileIndex;       // Index into tiles for animation


    protected Entity(final Point position, final List<Tile> tiles) {
        this.tiles = tiles;
        this.position = position;
        this.tileIndex = 0;
    }
    public final Point getPosition() {
        return this.position;
    }

    public final List<Tile> getTiles() {
        return this.tiles;
    }
    public final Tile getTile() {return this.tiles.get(tileIndex);}

    public final void setPosition(Point position) {
        this.position = position;
    }
}
