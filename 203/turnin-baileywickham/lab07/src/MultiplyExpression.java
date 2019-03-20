class MultiplyExpression
    extends BinaryExpression
{

    public MultiplyExpression(final Expression lft, final Expression rht)
    {
        super(lft,rht);
    }

    @Override
    public String getOperatorName() {
        return "*";
    }

    @Override
    protected double applyOperator(double d1, double d2) {
        return d1*d2;
    }

}

