import java.util.Comparator;

public class ComposedComparator implements Comparator<Song> {
    Comparator<Song> c1;
    Comparator<Song> c2;
    public ComposedComparator(Comparator<Song> c1, Comparator<Song> c2) {
        this.c1 = c1;
        this.c2 = c2;
    }
    @Override
    public int compare(Song song, Song t1) {
        int res = c1.compare(song, t1);
        if (res == 0) {
            res = c2.compare(song,t1);
        }
        return res;
    }
}
