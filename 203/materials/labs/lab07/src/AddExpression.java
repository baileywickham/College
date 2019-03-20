class AddExpression
    implements Expression
{
    private final Expression lft;
    private final Expression rht;

    public AddExpression(final Expression lft, final Expression rht)
    {
        this.lft = lft;
        this.rht = rht;
    }

    public String toString()
    {
        return "(" + lft + " + " + rht + ")";
    }

    public double evaluate(final Bindings bindings)
    {
        return lft.evaluate(bindings) + rht.evaluate(bindings);
    }
}
