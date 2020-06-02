
import java.util.Comparator;

//
//  Provide initializers for the static fields, as instructed.
//
public class Comparators {

    public final static Comparator<Song> 
    artistComparator = new ArtistComparator();

    public final static Comparator<Song> 
    lambdaTitleComparator = (Song s, Song o) -> s.getTitle().compareTo(o.getTitle());

    public final static Comparator<Song> 
    keyExtractorYearComparator = Comparator.comparingInt(Song::getYear);

    public final static Comparator<Song> 
    twoFieldComparator = (Song s, Song o) -> {
        int result = s.getArtist().compareTo(o.getArtist());
        if (result == 0) {
            result =  s.getYear() - o.getYear();
        }
        return result;
    };

    public final static Comparator<Song> 
    composedComparator = new ComposedComparator(artistComparator, lambdaTitleComparator);

    public final static Comparator<Song> 
    sortByArtistThenTitleThenYearComparator = (Song s, Song o) -> {
        int result = s.getArtist().compareTo(o.getArtist());
        if (result == 0) {
            result = s.getTitle().compareTo(o.getTitle());
            if (result == 0) {
                result = s.getYear() - o.getYear();
            }
        }
        return result;
    };
}
