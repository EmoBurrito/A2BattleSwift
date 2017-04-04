public class Boat
{
	//Symbol represenation
	//Reeeeally wishing abstract classes were a thing
	class var symbol: String {return " "}
<<<<<<< HEAD
	class var length: Int {return 0}
	class var name: String {return "noname"}	//should know what to call itself
=======
	class var length: Int {return 0} //Hardcoded because the arrays need to be non-static, but our generic populate call wants it to be static
>>>>>>> master

	//Should boats know their location, as well as if they've been hit or not?
	// We should also be able to write a function so the boat knows how many times
	//it can be hit, based on its length
}

public class Sub : Boat
{
	override class var symbol: String { return "Ө" }
<<<<<<< HEAD
	override class var length: Int {return 3} //TODO Why don't I just return the length of the array?
	override class var name: String {return "Submarine"}
=======
	override class var length: Int {return 3}

>>>>>>> master
	var hits = [false, false, false] //Yet to be used
}

public class Carrier : Boat
{
	override class var symbol: String { return "Ш" }
<<<<<<< HEAD
	override class var length: Int {return 4}
	override class var name: String {return "Carrier"}
=======
	override class var length: Int {return 5}

>>>>>>> master
	var hits = [false, false, false, false]
}

public class Tug : Boat
{
	override class var symbol: String { return "Ӝ" }
	override class var length: Int {return 2}
	override class var name: String {return "Tugboat"}
	var hits = [false, false]
}
