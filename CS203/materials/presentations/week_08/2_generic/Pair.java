import java.util.Objects;

public class Pair<T> {

    private T left;
    private T right;

    public Pair(T left, T right) {
        this.left = left;
        this.right = right;
    }

    public T getLeft() { return left; }

    public T getRight() { return right; }

    @Override
    public String toString() {
        return "Pair(" + left + ", " + right + ")";
    }

    @Override
    public int hashCode() {
        return Objects.hash(left, right);
    }

    @Override
    public boolean equals(Object other) {
        if (other instanceof Pair) {
            Pair op = (Pair) other;
            return Objects.equals(left, op.left) 
                   && Objects.equals(right, op.right);
        } else {
            return false;
        }
    }
}
