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
        String bin = value.toString(2);
        while (bin.length() < 32){
            bin = "0" + bin;
        }
        return bin;
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
