import java.util.Scanner;
public class ConnectFour {
    public static void main(String[] args) {
        Scanner scnr = new Scanner(System.in);
        System.out.print("What would you like the height of the board to be? ");
        int arrayHeight = scnr.nextInt();
        System.out.print("What would you like the length of the board to be? ");
        int arrayLength = scnr.nextInt();
        char[][] array = new char[arrayHeight][arrayLength];      // Creates a 2d board with set rows and columns //
        initializeBoard(array);
        printBoard(array);
        System.out.println("Player 1: x\nPlayer 2: o\n");
        boolean xgameWon = false;
        boolean ogameWon = false;
        boolean tiedGame = false;


        while(!(xgameWon || ogameWon || tiedGame)) {       // Game iterates until theres a winner or a tied game //

            System.out.print("Player 1: Which column would you like to choose? ");
            int col1 = scnr.nextInt();
            int row1 = insertChip(array, col1, 'x');
            printBoard(array);
            xgameWon = checkIfWinner(array, col1, row1, 'x');     // Checks for won game after token is placed //
            tiedGame = checkForTie(array,arrayHeight,arrayLength);        // Checks for tied game after token is placed //


            if(!xgameWon) {
                System.out.print("Player 2: Which column would you like to choose? ");
                int col2 = scnr.nextInt();
                int row2 = insertChip(array, col2, 'o');
                printBoard(array);
                ogameWon = checkIfWinner(array, col2, row2, 'o');           // Checks for won game after token is placed //
                tiedGame = checkForTie(array,arrayHeight,arrayLength);              // Checks for tied game after token is placed //
            }

        }
        if(xgameWon){
            System.out.println("Player 1 won the game!");
        }
        else if(ogameWon){
            System.out.println("Player 2 won the game!");
        }
        else if(tiedGame){
            System.out.println("Draw.Nobody wins.");
        }


    }
    public static int insertChip(char[][] array, int col, char charType){    // Alters board with new chip inserted at row and column //
        int row = getRow(array,col);
        array[row][col] = charType;
        return row;
    }


    public static boolean checkIfWinner(char[][] array, int col, int row, char chipType) {       // adds # of consecutive same tokens on left and right, if three, then win //
                                                                                                // for each check make sure not out of bounds //
        int rightCount = 0;
        int leftCount = 0;
        int upCount = 0;
        int downCount = 0;
        int ruCount = 0;
        int dlCount = 0;

        int rightCounter = 1;
        int leftCounter = 1;
        int upCounter = 1;
        int downCounter = 1;
        int ruCounter = 1;
        int dlCounter = 1;


        for(int i = 0; i < 3; ++i) {        // Checks if tokens on the right match with placed token //

            if (isOnBoard(array, row, col + rightCounter)) {
                if (array[row][col + rightCounter] == chipType) {
                    ++rightCount;
                    ++rightCounter;
                }
                else {
                    break;
                }
            }
        }
        for(int i = 0; i < 3; ++i) {       // Checks if tokens on the left match with placed token //
            if (isOnBoard(array, row, col - leftCounter)) {
                if (array[row][col - leftCounter] == chipType) {
                    ++leftCount;
                    ++leftCounter;
                }
                else {
                    break;
                }
            }
        }
        for(int i = 0; i < 3; ++i) {  // Checks if tokens above match with placed token //

            if (isOnBoard(array, row + upCounter, col)) {
                if (array[row + upCounter][col] == chipType) {
                    ++upCount;
                    ++upCounter;
                }
                else {
                    break;
                }
            }
        }
        for(int i = 0; i < 3; ++i) { // Checks if tokens below match with placed token //

            if (isOnBoard(array, row - downCounter, col)) {
                if (array[row-downCounter][col] == chipType) {
                    ++downCount;
                    ++downCounter;
                }
                else {
                    break;
                }
            }
        }

        if(upCount + downCount >= 3 || rightCount + leftCount >= 3){   // If four in a row in any direction //
            return true;

        }
        else {
            return false;
        }
    }
    public static int getRow(char[][] array, int col){   // Finds first open row for a certain column //
        int returnNum = 0;
        for(int i = 0; i < array.length ; ++i) {
            if(array[i][col] != '-') {
                returnNum = i+1;
            }
            if(array[i][col] == '-') {
                break;
            }
        }
        return returnNum;
    }
    public static void initializeBoard(char[][] array) { // Fills board with - at start of game /
        for(int i = 0; i < array.length; ++i) {
            for(int j = 0; j < array[0].length; ++j) {
                array[i][j] = '-';
            }
        }
    }
    public static void printBoard(char[][] array) {     // Prints current state of board //
        for(int i = array.length-1; i >= 0; --i) {
            System.out.println("");
            for(int j = 0; j < array[0].length; ++j) {
                System.out.print(array[i][j] + " ");
            }
        }
        System.out.println("");
    }
    public static boolean isOnBoard(char[][] array, int row, int col) {      // Checks if a given row and column is on the board //
        if (row >= 0 && col < array[0].length && col >= 0 && row < array.length) {
            return true;
        }
        else{
            return false;
        }
    }
    public static boolean checkForTie(char[][] array, int row, int col){   // Checks if every slot is filled with a token //
        for(int i = 0; i < row; ++i){
            for(int j = 0; j < col; ++j){
                if(array[i][j] == '-'){
                    return false;
                }
            }
        }
        return true;
    }
}
