
/*
 * This shows the slightly more awkward, older way of doing
 * essentially the same thing a lambda does.  It's called an inner class.
 **/

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
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
        button.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                betterSortStuff(); 
            }
        });
    }

    private void betterSortStuff() {
        System.out.println();
        System.out.println("Before sort:  " + things);

        things.sort(new Comparator<String> () {
            @Override public int compare(String a, String b) {
                return a.compareTo(b);
            }
        });

        System.out.println("After sort:  " + things);
    }
}
