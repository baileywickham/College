

import java.util.List;
import java.util.ArrayList;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javax.swing.JButton;

public class MyProgram {

    private int buttonPresses = 0;

    //
    // The compiler automatically generates the constructor
    // MyProgram() if we don't provide any constructor.
    //

    /**
     * Called by MyGUI when the program starts to give us a chance
     * to register to do something when the button is pressed.
     */
    public void register(JButton button1, JButton button2) {
        String message = "This button press brought to you by Acme.";

        button1.addActionListener(e -> {
            System.out.println();
            System.out.println("Button 1");
            System.out.println(message);
            System.out.println("Button presses so far:  " + (++buttonPresses));
        });
        button2.addActionListener(e -> {
            System.out.println();
            System.out.println("Button 2");
            System.out.println(message);
            System.out.println("Button presses so far:  " + (++buttonPresses));
        });

        //
        // Note that the lambda is accessing the local variable message.
        // How does that work?
        //
        // Can we do the same thing with the counter, buttonPresses?
        // Try it and see!
    }

}
