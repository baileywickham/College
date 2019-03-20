import java.util.*;

import edu.calpoly.spritely.Size;
import edu.calpoly.spritely.Tile;

/**
 * Data structures that hold the model of our virtual world.
 * It consists of a grid.  Each point on the grid is occupied
 * by a background tile, and, optionally, an Entity.
 */
final class WorldModel
{
    private final Size size;
    private final Tile background[][];
    private final Entity occupant[][];
    private final Set<Entity> entities;

    public WorldModel(Size gridSize)
    {
        this.size = gridSize;
        this.background = new Tile[gridSize.height][gridSize.width];
        this.occupant = new Entity[gridSize.height][gridSize.width];
        this.entities = new HashSet<Entity>();
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
    public Entity findNearest(Point pos,
                                     EntityKind kind)
    {
        List<Entity> ofType = new LinkedList<>();
        for (Entity entity : this.entities)
        {
            if (entity.getEntityKind() == kind)
            {
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

    public  void
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


}
