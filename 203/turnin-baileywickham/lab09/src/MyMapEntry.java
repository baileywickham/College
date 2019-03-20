public class MyMapEntry<K,V> {
    public final K key;
    public final V value;

    public MyMapEntry(K key, V value) {
        this.key = key;
        this.value = value;
    }

    @Override
    public String toString() {
        return "MyMapEntry(" + key.toString() +", " + value.toString()+")";
    }
}
