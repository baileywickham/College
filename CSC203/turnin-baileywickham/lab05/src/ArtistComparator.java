import java.util.Comparator;

public class ArtistComparator implements Comparator<Song> {
    @Override
    public int compare(Song song, Song t1) {
        return song.getTitle().compareTo(t1.getTitle());
    }
}
