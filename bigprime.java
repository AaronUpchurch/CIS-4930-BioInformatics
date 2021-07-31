public class bigprime {
    public static void main(String arg[]) {
        long num = 4;

        while(1==1) {
            while (!isPrime(num)) {
                --num;
            }
            System.out.println(num);
            num *= 2;
        }




    }
    public static boolean isPrime(long num) {
        long check = 2;
        while (num % check != 0) {
            ++check;
        }
        if (num == check) {
            return true;
        }
        else
            return false;
    }
}