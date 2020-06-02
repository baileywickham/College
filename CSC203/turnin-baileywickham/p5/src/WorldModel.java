import java.awt.*;
import java.util.*;
import java.util.List;
import java.util.function.Predicate;

import edu.calpoly.spritely.AnimationFrame;
import edu.calpoly.spritely.Size;
import edu.calpoly.spritely.SolidColorTile;
import edu.calpoly.spritely.Tile;

/**
 * Data structures that hold the model of our virtual world.
 * It consists of a grid.  Each point on the grid is occupied
 * by a background tile, and, optionally, an Entity.
 */
final class WorldModel implements Animatable
{
    private final Size size;
    private final Tile background[][];
    private final Entity occupant[][];
    private final Set<Entity> entities;
    private double sunColor;
    private int counter;

    public WorldModel(Size gridSize)
    {
        this.size = gridSize;
        this.background = new Tile[gridSize.height][gridSize.width];
        this.occupant = new Entity[gridSize.height][gridSize.width];
        this.entities = new HashSet<Entity>();
        this.counter = 0;
    }

    public Size getSize() { return this.size;    }
    public Tile[][] getBackground() { return this.background;}
    public Entity[][] getOccupant() { return this.occupant;}
    public Set<Entity> getEntities() {return this.entities;}
    public void setBackground(int x, int y, Tile color) {this.background[x][y] = color;}

    public void moveEntity(Entity entity, Point pos)
    {
        Point oldPos = entity.getPosition();
        if (withinBounds(pos) && !pos.equals(oldPos))
        {
            setOccupantCell(oldPos, null);
            removeEntityAt(pos);
            setOccupantCell(pos, entity);
            entity.setPosition(pos);
        }
    }

    public void removeEntity(Entity entity)
    {
        removeEntityAt(entity.getPosition());
    }

    private void removeEntityAt(Point pos)
    {
        if (withinBounds(pos)
                && getOccupantCell( pos) != null)
        {
            Entity entity = getOccupantCell(pos);

            /* this moves the entity just outside of the grid for
                debugging purposes */
            entity.setPosition(new Point(-1, -1));
            this.entities.remove(entity);
            setOccupantCell(pos, null);
        }
    }

    public Entity findNearest(final Point pos, final Predicate<Entity> predicate) {
        List<Entity> ofType = new LinkedList<>();
        for (Entity entity : entities) {
            if (predicate.test(entity)) {
                ofType.add(entity);
            }
        }

        return nearestEntity(ofType, pos);
    }


    public Entity getOccupant(Point pos)
    {
        if (isOccupied(pos)) {
            return getOccupantCell(pos);
        } else {
            return null;
        }
    }
    public void addEntity(Entity entity)
    {
        if (withinBounds(entity.getPosition()))
        {
            setOccupantCell(entity.getPosition(), entity);
            this.entities.add(entity);
        }
    }
    private Entity getOccupantCell(Point pos)
    {
        return this.occupant[pos.getY()][pos.getX()];
    }

    private void
    setOccupantCell(Point pos, Entity entity)
    {
        this.occupant[pos.getY()][pos.getX()] = entity;
    }

    private Entity nearestEntity(List<Entity> entities, Point pos)
    {
        if (entities.isEmpty()) {
            return null;
        } else {
            Entity nearest = entities.get(0);
            int nearestDistance = Point.distanceSquared(nearest.getPosition(), pos);

            for (Entity other : entities)
            {
                int otherDistance = Point.distanceSquared(other.getPosition(), pos);

                if (otherDistance < nearestDistance)
                {
                    nearest = other;
                    nearestDistance = otherDistance;
                }
            }

            return nearest;
        }
    }

    public boolean withinBounds(Point pos)
    {
        return pos.getY() >= 0 && pos.getY() < size.height &&
                pos.getX() >= 0 && pos.getX() < size.width;
    }

    public boolean isOccupied(Point pos)
    {
        return withinBounds(pos) && getOccupantCell(pos) != null;
    }

    public Point findOpenAround(Point pos)
    {
        for (int dy = -1; dy <= 1; dy++)
        {
            for (int dx = -1; dx <= 1; dx++)
            {
                Point newPt = new Point(pos.getX() + dx, pos.getY() + dy);
                if (withinBounds(newPt) &&
                        !isOccupied(newPt))
                {
                    return newPt;
                }
            }
        }

        return null;
    }


    @Override
    public int getAnimationPeriod() {
        return 100;
    }

    public Action createAnimationAction(int repeatCount)
    {
        return new Animation(this, repeatCount);
    }

    @Override
    public void nextImage() {
        this.sunColor = (.5 * (1 - Math.cos((Math.PI * counter * 2) / 300)));
        this.counter++;
    }

    void paint(AnimationFrame frame) {
        for (int y = 0; y < this.getSize().height; y++) {
            for (int x = 0; x < this.getSize().width; x++) {
                frame.addTile(x, y, this.getBackground()[y][x]);
                if (this.getBackground()[y][x].equals(VirtualWorld.grassTile)) {

                    Color c = new Color(255,255, 0, (int) (sunColor * 100));
                    SolidColorTile s = new SolidColorTile(c, '.');
                    frame.addTile(x, y, s);
                }
                Entity occupant = this.getOccupant()[y][x];
                if (occupant != null) {
                    Tile tile = occupant.getTile();
                    frame.addTile(x, y, tile);
                }
            }
        }
    }
}
