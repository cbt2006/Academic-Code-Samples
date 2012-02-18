/* Name: Clayton Thomas
	Date: 10/2/2010
	Course: CS 2420
	Project: Knapsack Problem
*/

import java.util.ArrayList;


public class Knapsack1 {
	// I am assuming five total item types, which I refer to as A, B, C, D, and E, respectively.
	// The val[] and size[] arrays below correspond to these five item types.
	public int[] val = {4, 5, 10, 11, 13}; // values of 5 items
	public int[] size = {3, 4, 7, 8, 9}; // sizes of 5 items
	public final int types = 5; // number of item types
	public final int capacity = 17; // knapsack size
	public ArrayList sack = new ArrayList(); // sack of items whose value will be evaluated
	public int bestVal = 0; // holds best value found so far
	public ArrayList bestSack = new ArrayList(); // the best comination of items found so far

	// Retrieves total value of everything currently in the sack.
	public int getValue() {
		int value = 0; // holds value of everything in sack
		for(int i = 0; i < sack.size(); i++) {
			value += val[Integer.parseInt(sack.get(i).toString())]; // add value of each item in sack, whose number corresponds to an element of the val[] array
		}
		return value;
	}

	// Finds the most valuable combination of elements given a starting capacity (17 in this case).
	// Calls recursively until it runs out of space; loops through items to test each one.
	// When current iteration reaches last item, sack's last item is removed,
	// and calling iteration (high stack call) then loops.  This allows for testing of all possible element combinations.
	public void solve(int cap) { // cap is capacity of sack for current iteration
		for(int i = 0; i < this.types; i++) {
			// if there is space in sack to add current item, then do it.
			// if not, this is skipped and for loop executes next iteration.
			if((cap - size[i]) >= 0) {
				sack.set(sack.size() - 1, i); // set last element in the sack to the current item
				int newCap = cap - size[i];
				// if there's still room for more, call another iteration.
				// if there's no room left, then compute value of everything currently in sack
				if(newCap >= 3) {
					sack.add(-1); // expand list by one element - insert dummy value
					solve(newCap);
				} else {
					int value = this.getValue();
					// if current value is higher than previous high, then current value becomes new high,
					// and current item list becomes new optimal item list
					if(value > bestVal) {
						bestVal = value;
						bestSack.clear();
						bestSack.addAll(sack);
					}
				}
			}
			// At this point, we check if we're testing the last item type, in which case we're out of options
			// for current iteration.
			// If so, we need to get rid of last element in list so that higher stack calls modify the appropriate
			// element in the list; without this step, they will continue to add items to the end of the list
			// which makes for a longer and longer list of items and inaccurate results.
			if(i == this.types - 1) {
				sack.remove(sack.size() - 1);
			}
		}
	}
	
	// Prints final best value and best combination.  Uses character values of A-E to represent items 0-4
	public void printVals() {
		System.out.println("Best value is " + bestVal);
		System.out.print("Best sack item combination is: ");
		for(int i = 0; i < bestSack.size(); i++) {
			int value = Integer.parseInt(bestSack.get(i).toString());
			char valName = 'Z'; // dummy value
			switch(value) {
				case 0:
					valName = 'A';
					break;
				case 1:
					valName = 'B';
					break;
				case 2:
					valName = 'C';
					break;
				case 3:
					valName = 'D';
					break;
				case 4:
					valName = 'E';
					break;
			}
			System.out.print(valName + " ");
		}
	}
	
	public static void main(String[] args) {
		Knapsack1 knapsack = new Knapsack1();
		knapsack.sack.add(-1); // give sack a starting value (solve() method depends on this)
		knapsack.solve(knapsack.capacity);
		knapsack.printVals();
	}

}