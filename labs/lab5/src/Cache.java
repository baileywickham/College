import java.math.BigInteger;

public class Cache {
    //long twotothethirtysecond = 4294967296;
    int hits = 0;
    int misses = 0;
    int assoc;
    int blockSize;
    int cacheSize;
    int cashNumber;
    
    public float getRatio(){
        return misses == 0 ? 0 : hits / misses;
    }

    public Cache(int cashNumber, int cacheSize, int assoc, int blockSize) {
        this.cacheSize = cacheSize;
        this.assoc = assoc;
        this.blockSize = blockSize;
        this.cashNumber = cashNumber;
    }
    public void lookup(String addr) {
        String binary = hexToBin(addr);
        // System.out.println(binary);
    }
    public void printResults() {
        System.out.printf("Cache #%d\n", cashNumber);
        System.out.printf("Cache size: %dB	Associativity: %d	Block size: %d\n", cacheSize, assoc, blockSize); 
        System.out.printf("Hits: %d	Hit Rate: %.2f\n", hits, getRatio());
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
}

class CacheEntry {
    boolean valid;
    String tag;
    public CacheEntry(boolean vaild, String tag) {
        this.tag = tag;
        this.valid = valid;
    }
}
