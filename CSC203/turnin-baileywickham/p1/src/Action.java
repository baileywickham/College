/**
 * An action data structure records information about
 * an action that is to be performed on an entity.  It 
 * is attached to an Event data structure.
 */

public interface Action
{
    void executeAction(EventSchedule eventSchedule);
}
