

import java.util.List;
import java.util.ArrayList;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javax.swing.JButton;

public class MyProgram {

    private final List<String> things = new ArrayList<String>();

    public MyProgram() {
        things.add("pen");
        things.add("pineapple");
        things.add("apple");
        things.add("pen");
    }

    /**
     * Called by MyGUI when the program starts to give us a chance
     * to register to do something when the button is pressed.
     */
    public void register(JButton button) {
        button.addActionListener(e -> { betterSortStuff(); });
    }

    private void betterSortStuff() {
        System.out.println();
        System.out.println("Before sort:  " + things);

        things.sort( (String a, String b) ->  { return a.compareTo(b); } );
        //
        // This also works:
        //    things.sort( String::compareTo );
        //

        System.out.println("After sort:  " + things);
    }
}
