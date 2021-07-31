import java.util.Scanner;
public class game1 {
    public static void main(String[] args) {
        int x = 5;
        int y = 5;
        Scanner s = new Scanner(System.in);
        while (1==1) {
            String x_dir0 = ("0         ");
            String x_dir1 = (" 0        ");
            String x_dir2 = ("  0       ");
            String x_dir3 = ("   0      ");
            String x_dir4 = ("    0     ");
            String x_dir5 = ("     0    ");
            String x_dir6 = ("      0   ");
            String x_dir7 = ("       0  ");
            String x_dir8 =("         0 ");
            String x_dir9 =("          0");
            String choice = s.next();
            if ( (choice.equals("w")) == true ) {
                y -= 1;
            }
            if ( (choice.equals("s")) == true ) {
                y += 1;
            }
            if ( (choice.equals("a")) == true ) {
                x -= 1;
            }
            if ( (choice.equals("d")) == true ) {
                x += 1;
            }
            int check = y;
            while(check -1 > 1) {
                System.out.println("          ");
                check --;
            }
            check = y;
            if (x == 0) {
                if (y != 0){
                    System.out.println(x_dir0);
            }}
            if (x == 1) {
                if (y != 1){
                    System.out.println(x_dir1);
                }}
            if (x == 2) {
                if (y != 2){
                    System.out.println(x_dir2);
                }}
            if (x == 3) {
                if (y != 3){
                    System.out.println(x_dir3);
                }}
            if (x == 4) {
                if (y != 4){
                    System.out.println(x_dir4);
                }}
            if (x == 5) {
                if (y != 5){
                    System.out.println(x_dir5);
                }}
            if (x == 6) {
                if (y != 6){
                    System.out.println(x_dir6);
                }}
            if (x == 7) {
                if (y != 7){
                    System.out.println(x_dir7);
                }}
            if (x == 8) {
                if (y != 8){
                    System.out.println(x_dir8);
                }}
            if (x == 9) {
                if (y != 9){
                    System.out.println(x_dir9);
                }}


            while((10 - check) > 1) {
                System.out.println("         ");
                check ++;}

        }
    }
}