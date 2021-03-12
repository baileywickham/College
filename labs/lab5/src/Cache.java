import java.math.BigInteger;
import java.math.*;

public class Cache {
    //long twotothethirtysecond = 4294967296;
    CacheEntry[] cache;
    int hits = 0;
    int reads = 0;
    int assoc;
    int blockSize;
    int cacheSize;
    int cashNumber;
    int indexSize;
    
    public float getRatio(){
        return (float) hits / (float) reads;
    }

    public Cache(int casheNumber, int cacheSize, int assoc, int blockSize) {
        this.reads=0;
        this.cacheSize = cacheSize;
        this.assoc = assoc;
        this.blockSize = blockSize;
        this.cashNumber = casheNumber;
        this.indexSize = (cacheSize / (this.blockSize * 4));
        allocCache(indexSize);
    }
    public void lookup(String addr) {

        // [tag, index, block, byte 2b]
        // [tag, index, block, byte 2b]
        // tag size = 32 - byteoffset - blockOffset - entrySize
        this.reads++;
        int indexBits = log2(indexSize);
        int tagSize = 32 - 2 - log2(this.blockSize) - indexBits;
        String binary = hexToBin(addr);
        String tag = binary.substring(0, tagSize);
        int index = Integer.parseInt(binary.substring(tagSize, tagSize + indexBits),2);
        CacheEntry possible = cache[index % indexSize];
        if (possible.valid && possible.tag.equals(tag)) {
            hits++;
        } else {
            cache[index % indexSize].tag = tag;
            cache[index % indexSize].valid = true;
        }
    }
    public int log2(int i) {
        return (int) (Math.log(i) / Math.log(2));
    }
    public void printResults() {
        System.out.printf("Cache #%d\n", cashNumber);
        System.out.printf("Cache size: %dB	Associativity: %d	Block size: %d\n", cacheSize, assoc, blockSize); 
        System.out.printf("Hits: %d	Hit Rate: %.2f%%\n", hits, 100*getRatio());
        System.out.println("---------------------------");
    }
    public String hexToBin(String hex) {
        BigInteger value = new BigInteger(hex, 16);
        return intToNBits(value, 32);
    }
    public String intToNBits(BigInteger i, int n) {
        String ext = "0";
        if (i.signum() < 0) {
            ext = "1";
        }
        String s = i.toString(2);
        if (s.length() > n) {
            return s.substring(s.length()-n);
        }
        while (s.length() < n) {
            s = ext + s;
        }
        return s;
    }
    public void allocCache(int n) {
        this.cache = new CacheEntry[n];
        for (int i = 0; i < n; i++) {
            cache[i] = new CacheEntry(false, "");
        }
    }
}

class CacheEntry {
    boolean valid;
    String tag;
    public CacheEntry(boolean valid, String tag) {
        this.tag = tag;
        this.valid = valid;
    }
}
