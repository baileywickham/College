import java.math.BigInteger;

public class Cache {
    //long twotothethirtysecond = 4294967296;
    int[] cache;
    int hits = 0;
    int misses = 0;
    int assoc;
    int blockSize;
    int cacheSize;

    public Cache(int cacheSize, int assoc, int blockSize) {
        this.cacheSize = cacheSize;
        this.assoc = assoc;
        this.blockSize = blockSize;
    }
    public void lookup(String addr) {

    }
    public void printResults() {

    }
    public String hexToBin(String hex) {
        return new BigInteger(hex, 16).toString();
    }

}

class CacheEntry {
    boolean valid;
    String tag;
    public CacheEntry(boolean vaild, String tag) {
        this.tag = tag;
        this.valid = valid;

    }
}
