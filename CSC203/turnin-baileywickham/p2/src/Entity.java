import java.util.List;
import edu.calpoly.spritely.Tile;

/**
 * An entity in our virtual world.  An entity occupies a square
 * on the grid.  It might move around, and interact with otherne
 * entities in the world.
 */
final class Entity {
    private final EntityKind kind;
    private Point position;
    private final List<Tile> tiles;
    private int tileIndex;       // Index into tiles for animation
    private final int resourceLimit;
    private int resourceCount;
    private final int actionPeriod;
    private final int animationPeriod;

    public Entity(EntityKind kind, Point position,
                  List<Tile> tiles, int resourceLimit, int resourceCount,
                  int actionPeriod, int animationPeriod) {
        this.kind = kind;
        this.position = position;
        this.tiles = tiles;
        this.tileIndex = 0;
        this.resourceLimit = resourceLimit;
        this.resourceCount = resourceCount;
        this.actionPeriod = actionPeriod;
        this.animationPeriod = animationPeriod;
    }

    public int getTileIndex() {
        return this.tileIndex;
    }

    public int getResourceLimit() {
        return this.resourceLimit;
    }

    public int getResourceCount() {
        return this.resourceCount;
    }

    public int getActionPeriod() {
        return this.actionPeriod;
    }

    public EntityKind getEntityKind() {
        return this.kind;
    }

    public Point getPosition() {
        return this.position;
    }

    public List<Tile> getTiles() {
        return this.tiles;
    }

    public void setPosition(Point position) {
        this.position = position;
    }

    public int getAnimationPeriod() {
        switch (this.kind) {
            case MINER_FULL:
            case MINER_NOT_FULL:
            case ORE_BLOB:
            case QUAKE:
                return this.animationPeriod;
            default:
                throw new UnsupportedOperationException(
                        String.format("getAnimationPeriod not supported for %s",
                                this.kind));
        }
    }

    public void nextImage() {
        this.tileIndex = (this.tileIndex + 1) % this.tiles.size();
    }

    public Tile getCurrentTile() {
        return this.tiles.get(this.tileIndex);
    }

    public boolean
    transformNotFull(WorldModel world,
                     EventSchedule eventSchedule) {
        if (this.resourceCount >= this.resourceLimit) {
            Entity miner = createMinerFull(this.resourceLimit,
                    this.position, this.actionPeriod, this.animationPeriod);

            world.removeEntity(this);
            eventSchedule.unscheduleAllEvents(this);

            world.addEntity(miner);
            scheduleActions(miner, eventSchedule, world);

            return true;
        }

        return false;
    }

    public void
    transformFull(WorldModel world, EventSchedule eventSchedule) {
        Entity miner = createMinerNotFull(this.resourceLimit,
                this.position, this.actionPeriod, this.animationPeriod);

        world.removeEntity(this);
        eventSchedule.unscheduleAllEvents(this);

        world.addEntity(miner);
        scheduleActions(miner, eventSchedule, world);
    }

    public boolean
    moveToFull(WorldModel world,
               Entity target, EventSchedule eventSchedule) {
        if (Point.adjacent(this.position, target.position)) {
            return true;
        } else {
            Point nextPos = nextPositionMiner(world, target.position);

            if (!this.position.equals(nextPos)) {
                world.moveEntity(this, nextPos);
            }
            return false;
        }
    }


    public boolean
    moveToNotFull(WorldModel world,
                  Entity target, EventSchedule eventSchedule) {
        if (Point.adjacent(this.position, target.position)) {
            this.resourceCount += 1;
            world.removeEntity(target);
            eventSchedule.unscheduleAllEvents(target);

            return true;
        } else {
            Point nextPos = nextPositionMiner(world, target.position);

            if (!this.position.equals(nextPos)) {
                world.moveEntity(this, nextPos);
            }
            return false;
        }
    }

    public static void
    scheduleActions(Entity entity, EventSchedule eventSchedule,
                    WorldModel world) {
        switch (entity.kind) {
            case MINER_FULL:
                eventSchedule.scheduleEvent(entity,
                        entity.createActivityAction(world),
                        entity.getActionPeriod());
                eventSchedule.scheduleEvent(entity,
                        entity.createAnimationAction(0),
                        entity.getActionPeriod());
                break;

            case MINER_NOT_FULL:
                eventSchedule.scheduleEvent(entity,
                        entity.createActivityAction(world),
                        entity.getActionPeriod());
                eventSchedule.scheduleEvent(entity,
                        entity.createAnimationAction(0), entity.getAnimationPeriod());
                break;

            case ORE:
                eventSchedule.scheduleEvent(entity,
                        entity.createActivityAction(world),
                        entity.actionPeriod);
                break;

            case ORE_BLOB:
                eventSchedule.scheduleEvent(entity,
                        entity.createActivityAction(world),
                        entity.actionPeriod);
                eventSchedule.scheduleEvent(entity,
                        entity.createAnimationAction(0), entity.getAnimationPeriod());
                break;

            case QUAKE:
                eventSchedule.scheduleEvent(entity,
                        entity.createActivityAction(world),
                        entity.actionPeriod);
                eventSchedule.scheduleEvent(entity,
                        entity.createAnimationAction(10),
                        entity.getAnimationPeriod());
                break;

            case VEIN:
                eventSchedule.scheduleEvent(entity,
                        entity.createActivityAction(world),
                        entity.actionPeriod);
                break;

            default:
        }
    }

    public boolean
    moveToOreBlob(WorldModel world,
                  Entity target, EventSchedule eventSchedule) {
        if (Point.adjacent(this.position, target.position)) {
            world.removeEntity(target);
            eventSchedule.unscheduleAllEvents(target);
            return true;
        } else {
            Point nextPos = nextPositionOreBlob(world, target.position);

            if (!this.position.equals(nextPos)) {
                Entity occupant = world.getOccupant(nextPos);
                if (occupant != null) {
                    eventSchedule.unscheduleAllEvents(occupant);
                }

                world.moveEntity(this, nextPos);
            }
            return false;
        }
    }
    private Point
    nextPositionMiner(WorldModel world, Point destPos)
    {
        int horiz = Integer.signum(destPos.getX() - this.position.getX());
        Point newPos = new Point(this.position.getX() + horiz,
                this.position.getY());

        if (horiz == 0 || world.isOccupied(newPos))
        {
            int vert = Integer.signum(destPos.getY() - this.position.getY());
            newPos = new Point(this.position.getX(),
                    this.position.getY() + vert);

            if (vert == 0 || world.isOccupied(newPos))
            {
                newPos = this.position;
            }
        }

        return newPos;
    }

    private Point
    nextPositionOreBlob(WorldModel world, Point destPos) {
        int horiz = Integer.signum(destPos.getX() - this.position.getX());
        Point newPos = new Point(this.position.getX() + horiz,
                this.position.getY());

        Entity occupant = world.getOccupant(newPos);

        if (horiz == 0 ||
                (occupant != null && !(occupant.kind == EntityKind.ORE))) {
            int vert = Integer.signum(destPos.getY() - this.position.getY());
            newPos = new Point(this.position.getX(),
                    this.position.getY() + vert);
            occupant = world.getOccupant(newPos);

            if (vert == 0 ||
                    (occupant != null && !(occupant.kind == EntityKind.ORE))) {
                newPos = this.position;
            }
        }
        return newPos;
    }

    public static Entity createBlacksmith(Point position) {
        return new Entity(EntityKind.BLACKSMITH, position,
                VirtualWorld.blacksmithTiles, 0, 0, 0, 0);
    }

    private static Entity
    createMinerFull(int resourceLimit, Point position,
                    int actionPeriod, int animationPeriod) {
        return new Entity(EntityKind.MINER_FULL, position,
                VirtualWorld.minerFullTiles,
                resourceLimit, resourceLimit, actionPeriod,
                animationPeriod);
    }

    public static Entity
    createMinerNotFull(int resourceLimit, Point position, int actionPeriod,
                       int animationPeriod) {
        return new Entity(EntityKind.MINER_NOT_FULL, position,
                VirtualWorld.minerTiles,
                resourceLimit, 0, actionPeriod, animationPeriod);
    }

    public static Entity
    createObstacle(Point position) {
        return new Entity(EntityKind.OBSTACLE, position,
                VirtualWorld.obstacleTiles, 0, 0, 0, 0);
    }

    public static Entity
    createOre(Point position, int actionPeriod) {
        return new Entity(EntityKind.ORE, position,
                VirtualWorld.oreTiles, 0, 0, actionPeriod, 0);
    }

    public static Entity
    createOreBlob(Point position, int actionPeriod, int animationPeriod) {
        return new Entity(EntityKind.ORE_BLOB, position,
                VirtualWorld.blobTiles,
                0, 0, actionPeriod, animationPeriod);
    }

    public static Entity createQuake(Point position) {
        return new Entity(EntityKind.QUAKE, position,
                VirtualWorld.quakeTiles, 0, 0, 1100, 100);
    }

    public static Entity createVein(Point position, int actionPeriod) {
        return new Entity(EntityKind.VEIN, position,
                VirtualWorld.veinTiles, 0, 0, actionPeriod, 0);
    }
    public Action createAnimationAction(int repeatCount)
    {
        return new Action(ActionKind.ANIMATION, this, null, repeatCount);
    }
    public Action createActivityAction(WorldModel world)
    {
        return new Action(ActionKind.ACTIVITY, this, world, 0);
    }

}
