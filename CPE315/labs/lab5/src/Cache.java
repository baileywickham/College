import java.math.BigInteger;

public class Cache {
    //long twotothethirtysecond = 4294967296;
    CacheEntry[][] cache;
    int hits = 0;
    int reads = 0;
    int assoc;
    int blockSize;
    int cacheSize;
    int cacheNumber;
    int indexSize;
    
    public float getRatio(){
        return (float) hits / (float) reads;
    }

    public Cache(int cacheNumber, int cacheSize, int assoc, int blockSize) {
        this.reads=0;
        this.cacheSize = cacheSize;
        this.assoc = assoc;
        this.blockSize = blockSize;
        this.cacheNumber = cacheNumber;
        this.indexSize = (cacheSize / (this.blockSize * 4)) / assoc;
        allocCache(indexSize, assoc);
    }
    public void lookup(String addr, int lineNum) {

        // [tag, index, block, byte 2b]
        // [tag, index, block, byte 2b]
        // tag size = 32 - byteoffset - blockOffset - entrySize
        this.reads++;
        int indexBits = log2(indexSize);
        int tagSize = 32 - 2 - log2(this.blockSize) - indexBits;
        String binary = hexToBin(addr);
        String tag = binary.substring(0, tagSize);
        int index = Integer.parseInt(binary.substring(tagSize, tagSize + indexBits),2);
        CacheEntry _min = cache[index % indexSize][0];
        int _minIndex = 0;
        for (int i = 0; i < this.assoc; i++) {
            CacheEntry possible = cache[index % indexSize][i];
            if (possible.lineNum < _min.lineNum) {
                _minIndex = i;
                _min = possible;
            }
            if (!possible.valid) {
                cache[index % indexSize][i].tag = tag;
                cache[index % indexSize][i].valid = true;
                cache[index % indexSize][i].lineNum = lineNum;
                return;
            }
            if (possible.tag.equals(tag)) {
                cache[index % indexSize][i].lineNum = lineNum;
                hits++;
                return;
            }
        }
        cache[index % indexSize][_minIndex].tag = tag;
        cache[index % indexSize][_minIndex].valid = true;
        cache[index % indexSize][_minIndex].lineNum = lineNum;
    }
    public int log2(int i) {
        return (int) (Math.log(i) / Math.log(2));
    }
    public void printResults() {
        System.out.printf("Cache #%d\n", cacheNumber);
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
        StringBuilder s = new StringBuilder(i.toString(2));
        if (s.length() > n) {
            return s.substring(s.length()-n);
        }
        while (s.length() < n) {
            s.insert(0, ext);
        }
        return s.toString();
    }
    public void allocCache(int n, int m) {
        this.cache = new CacheEntry[n][m];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                cache[i][j] = new CacheEntry(false, "", -1);
            }
        }
    }
}

class CacheEntry {
    boolean valid;
    String tag;
    int lineNum;
    public CacheEntry(boolean valid, String tag, int lineNum) {
        this.tag = tag;
        this.valid = valid;
        this.lineNum = lineNum;
    }
}
