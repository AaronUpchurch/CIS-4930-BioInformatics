import java.util.Random;
import java.util.Scanner;

public class Me {
    public static void main(String[] args) {
        Random rand = new Random();
        Scanner scrn = new Scanner(System.in);
        int hand_score = 0;
        int drawn_card;
        int drawn_card_value = 0;
        int choice;
        int dealers_hand;
        double num_player_wins = 0;
        double num_dealer_wins = 0;
        double num_tie_games = 0;
        int game_number = 0;


        System.out.println("START GAME #" + (game_number+1) + "\n");




        while (1==1) {


            drawn_card = rand.nextInt(13) + 1;

            if (drawn_card == 1) {
                System.out.println("Your card is a ACE!");}

            if (drawn_card < 11) {
                if(drawn_card > 1) {
                System.out.println("Your card is a " + drawn_card + "!");}}

            if (drawn_card == 11) {
                System.out.println("Your card is a JACK!");}

            if (drawn_card == 12) {
                System.out.println("Your card is a QUEEN!");}

            if (drawn_card == 13) {
                System.out.println("Your card is a KING!");}

            if (drawn_card < 11) {
                drawn_card_value = drawn_card;}

            if (drawn_card > 10) {
                drawn_card_value = 10;}

            hand_score = hand_score + drawn_card_value;
            System.out.println("Your hand is: " + hand_score + "\n");
            System.out.println("1.  Get another card" + "\n" + "2.  Hold Hand" + "\n" + "3.  Print statistics" + "\n" + "4.  Exit");
            System.out.print("Choose an option  ");
            choice = scrn.nextInt();
            System.out.println(" ");


            while (choice == 1 && hand_score < 22){

                drawn_card = rand.nextInt(13) + 1;


                if (drawn_card < 11) {
                    if (drawn_card == 1) {
                        System.out.println("Your card is a ACE!");}
                    if (drawn_card >1) {
                    System.out.println("Your card is a " + drawn_card + "!");}}

                if (drawn_card == 11) {
                    System.out.println("Your card is a JACK!");}

                if (drawn_card == 12) {
                    System.out.println("Your card is a QUEEN!");}

                if (drawn_card == 13) {
                    System.out.println("Your card is a KING!");}

                if (drawn_card < 11) {
                    drawn_card_value = drawn_card;}

                if (drawn_card > 10) {
                    drawn_card_value = 10;}

                hand_score = hand_score + drawn_card_value;
                System.out.println("Your hand is: " + hand_score + "\n");


                if ( hand_score > 21){
                    System.out.println("You exceeded 21! You lose");
                    num_dealer_wins = num_dealer_wins + 1;
                    hand_score = 0;
                    game_number = game_number + 1;
                    System.out.println("START GAME #" + (game_number+1) + "\n");}
                if ( hand_score == 21){
                    System.out.println("BLACKJACK! You win!");
                    num_player_wins = num_player_wins + 1;
                    hand_score = 0;
                    game_number = game_number + 1;
                    choice = 0;
                    System.out.println("START GAME #" + (game_number+1) + "\n");}
                if (hand_score < 21){
                    if(hand_score >0) {
                    System.out.println("1.  Get another card" + "\n" + "2.  Hold Hand" + "\n" + "3.  Print statistics" + "\n" + "4.  Exit");
                    System.out.print("Choose an option  ");
                    choice = scrn.nextInt();
                    System.out.println("");}}}


                                                                                /////or cite///
            while (choice > 4 || choice < 1){
                  System.out.println("Invalid input!" + "\n" + "Please enter an integer value between 1 and 4.");System.out.println("1.  Get another card" + "\n" + "2.  Hold Hand" + "\n" + "3.  Print statistics" + "\n" + "4.  Exit");
                    System.out.print("Choose an option  ");
                    choice = scrn.nextInt();System.out.println("");}




            if (choice == 3) {
                System.out.println("Number of Player wins: " + String.format("%.0f",num_player_wins));
                System.out.println("Number of Dealer wins: " + String.format("%.0f",num_dealer_wins));
                System.out.println("Number of tie games: " + String.format("%.0f",num_tie_games));
                System.out.println("Total # of games played is: " + game_number);
                System.out.println("Percentage of player wins: " + String.format("%.1f",(num_player_wins * 100.0 / game_number)) + "%");
                System.out.println("1.  Get another card" + "\n" + "2.  Hold Hand" + "\n" + "3.  Print statistics" + "\n" + "4.  Exit");
                System.out.print("Choose an option  ");
                choice = scrn.nextInt();
                System.out.println("");}
                           //doesnt compute small percent




            if (choice == 2) {
                dealers_hand = rand.nextInt(11) + 16;
                System.out.println("Dealers hand: " + dealers_hand);
                System.out.println("Your hand is: " + hand_score);

                if (dealers_hand > 21) {
                    System.out.println("You Win!" + "\n");
                    num_player_wins =+1;}

                if (hand_score > dealers_hand) {
                    System.out.println("You Win!" + "\n");
                    num_player_wins = +1;}

                if (hand_score < dealers_hand & dealers_hand < 22 ) {
                    System.out.println("Dealer Wins!" + "\n");
                    num_dealer_wins = +1;}

                if (hand_score == dealers_hand) {
                    System.out.println("It's a tie! No one wins!" + "\n");
                    num_tie_games = +1;}

                game_number = game_number + 1;
                System.out.print("START GAME #" + (game_number+1) + "\n");
                hand_score = 0;}

            if (choice == 4) {
                System.exit(0);}}}}


         // say where & was goten from // and terminate // and decimal //// and if