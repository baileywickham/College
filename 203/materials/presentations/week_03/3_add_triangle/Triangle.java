

import java.awt.*;


public class Triangle implements Shape {

    public Triangle() {
    }

    @Override
    public float getArea() {
        return 0f;
    }

    @Override
    public void visit(Visitor v) {
        v.visitTriangle(this);
    }
}

