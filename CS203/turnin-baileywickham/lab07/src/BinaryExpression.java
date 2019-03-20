import java.security.spec.ECParameterSpec;

public abstract class BinaryExpression implements Expression{
    private Expression e1;
    private Expression e2;

    public BinaryExpression(Expression e1, Expression e2) {
        this.e1 = e1;
        this.e2 = e2;
    }

    public double evaluate(final Bindings bindings) {
        return applyOperator(e1.evaluate(bindings), e2.evaluate(bindings));
    }
    @Override
    public String toString() {
        return "(" + e1 + getOperatorName() + e2 + ")";
    }
    public abstract String getOperatorName();

    protected abstract double applyOperator(double d1, double d2);
}
