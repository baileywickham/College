
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;

/**
 * A listener for when a button is pressed
 */


public class MyListener implements ActionListener {

    private final MyProgram program;

    public MyListener(MyProgram program) {
        this.program = program;
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        program.sortStuff();
    }
}
