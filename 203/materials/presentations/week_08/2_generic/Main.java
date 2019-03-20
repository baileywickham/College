
import java.util.Arrays;
import java.util.List;
import java.util.ArrayList;





public class Main {

    public static <ZZYZX> ZZYZX secondToLast(List<ZZYZX> list) {
        return list.get(list.size() - 2);
    }

    public static <T> void addNewBad(List<T> list) {
        //
        // Why can't we do this?

        list.add(new T());
        System.out.println("List is now " + list);
    }

    public static <T> void addNewGood(
        List<T> list, 
        java.util.function.Supplier<T> newT)
    {
        list.add(newT.get());
        System.out.println("List is now " + list);
    }

    public static void main(String[] args) {

        List<String> strings = new ArrayList<String>();
        strings.add("one");
        strings.add("two");
        strings.add("three");
        strings.add("four");

        System.out.println(secondToLast(strings));

        List<Pair<String>> pairs = new ArrayList<Pair<String>>();
        pairs.add(new Pair<String>("one", "the first"));
        pairs.add(new Pair<String>("two", "the second"));

        System.out.println(secondToLast(pairs));

        addNewBad(strings);
        addNewBad(pairs);

        addNewGood(strings, () -> "new string");
        addNewGood(pairs, () -> new Pair<String>("new", "the new one"));
    }

}
