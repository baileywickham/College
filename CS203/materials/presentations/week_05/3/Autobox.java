
public class Autobox {

    public static void main(String[] args) {
        System.out.print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");

        int i = 3;
        int j = 17;
        int k = 17;
        System.out.println("1:  i == j  " + ( i == j ));
        System.out.println("2:  j == k  " + ( j == k ));
        System.out.println();
        //
        // I can't write i.equals(j), because i isn't an Object!

        Integer oi = 3;
        Integer oj = 17000;
        Integer ok = new Integer(17000);
        Integer ok2 = 17000;
        System.out.println("3:  oi.equals(oj) " + ( oi.equals(oj) ));
        System.out.println("4:  oj.equals(ok) " + ( oj.equals(ok) ));
        System.out.println();

        System.out.println("5:  oi == oj  " + ( oi == oj ));
        System.out.println("6:  oj == ok  " + ( oj == ok ));
        System.out.println("7:  oj == ok2  " + ( oj == ok2 ));
        System.out.println();

        System.out.println("7:  oi.hashCode()  " + oi.hashCode());
        System.out.println("8:  oj.hashCode()  " + oj.hashCode());
    }
}
