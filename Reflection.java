/*	Author: Clayton Thomas
	Date: 5/5/11
	Description: Outputs the types and values of private instance variables, as well as
	the parameter types and type and value of the return value for each method.
	Makes use of the reflect package to do this.
	
	Both the test class and the class to be analyzed have been included in a single file for simplicity.
*/

import java.lang.reflect.*;

// class with private instance variables and methods
class PrivateVals {
	private int myInt = 25;
	private String myString = "Silicon Slopes";
	private double myDouble = 88.93;
	
	private int integerTest() {
		return 3;
	}
	
	private String stringTest(String aString) {
		return aString + " some fluff";
	}
	
	private void doesNothing() {
		int x = 10;
		return;
	}
}

// Test class
public class PrivateValsTest {
	public static void main(String[] args) {
		try {
			PrivateVals myPrivate = new PrivateVals();
			Class cls = Class.forName("PrivateVals");
			
			System.out.println("Class name is " + cls.getName());
		   System.out.println("-----");
			
			// Iterate through fields, capturing value and type of each
			Field fieldlist[]  = cls.getDeclaredFields();
         for (int i = 0; i < fieldlist.length; i++) {
            Field fld = fieldlist[i];
				fld.setAccessible(true);
				System.out.println("Field " + fld.getName() + " has type '" + fld.getType() + "' and value '" + fld.get(myPrivate) + "'");
            System.out.println("-----");
         }
			
			// Iterate through methods, outputting return type, return value, and parameter types
			Method methlist[] = cls.getDeclaredMethods();
         for (int i = 0; i < methlist.length; i++) {  
            Method m = methlist[i];
				m.setAccessible(true);
            System.out.println("Method " + m.getName() + " has return type '" + m.getReturnType() + "'");
            Class perams[] = m.getParameterTypes();
				// Getting the return value requires calling the method.
				// Here, if there are no parameters we call the method without any arguments
				if(perams.length == 0) {
					System.out.println("Method has a return value of '" + m.invoke(myPrivate) + "'");
				} else {
					// In this case, there is only one method that takes arguments, and it only takes one
					System.out.println("Method " + m.getName() + " parameter has type '" + perams[0] + "'");
					// for this class, the only method with an argument takes a single string, so I call it this way
					System.out.println("Method has a return value of '" + m.invoke(myPrivate, "some stuff and") + "'");
				}
	         System.out.println("-----");
			}
		}
		catch(Exception e) {
			System.err.println(e);
		}
	}
}