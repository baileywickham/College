class BetterLoop
{
    public static boolean contains(int [] values, int v)
    {
        /* TO DO: if value v is in the array, return true.
            If not, return false.  Use a "foreach" loop.
        */
        for (int val : values) {
            if (v == val) {
                return true;
            }
        }
        return false;
    }
}
