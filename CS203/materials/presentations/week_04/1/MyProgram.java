

import java.util.List;
import java.util.ArrayList;
import java.awt.event.ActionListener;
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
        button.addActionListener(new MyListener(this));
    }

    public void sortStuff() {
        System.out.println();
        System.out.println("Before sort:  " + things);

        for (int i = 0; i < things.size()-1; i++) {
            for (int j = i+1; j < things.size(); j++) {
                if (things.get(i).compareTo(things.get(j)) > 0) {
                    String tmp = things.get(i);
                    things.set(i, things.get(j));
                    things.set(j, tmp);
                }
            }
        }

        System.out.println("After sort:  " + things);
    }

}
