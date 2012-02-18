/*	Author: Clayton Thomas
	Date: 5/5/11
	Description: This program parses through the provided XML file, using the DOM parser,
	and prints the value of the id attribute for each Module element.
	
	For simplicity, the program has the file name hard-coded, rather than accepting a command-line value.
*/

import org.w3c.dom.*;
import javax.xml.parsers.*;
import java.io.*;

public class XMLParser {
	public static void main(String[] args) {
		try {
			File file = new File("toc1.xml");
			if (file.exists()) {
				// enables the parsing of an XML file into a DOM tree
        		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
				// parse entire file into memory
				Document doc = factory.newDocumentBuilder().parse(file);
				// retrieve a list of all nodes
				NodeList list = doc.getElementsByTagName("*");
				System.out.println("Module nodes' id attribute values:");
				System.out.println("------------------");
				// loop through all elements
				for (int i=0; i<list.getLength(); i++) {
		         Element element = (Element) list.item(i);
		         String name = element.getNodeName();
					// if node is a Module node, retrieve its id value
					if(name == "module") {
						System.out.println("id = " + element.getAttribute("id"));
					}
	         }
			} else {
				System.out.println("File not found!");
			}
		} catch (Exception ex) {
			System.err.println(ex);
		}
	}
}