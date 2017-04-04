public class Boat
{
	//Symbol represenation
	//Reeeeally wishing abstract classes were a thing
	class var symbol: String {return " "}
	class var length: Int {return 0}
	class var name: String {return "noname"}	//should know what to call itself

	//Should boats know their location, as well as if they've been hit or not?
	// We should also be able to write a function so the boat knows how many times
	//it can be hit, based on its length
}

public class Sub : Boat
{
	override class var symbol: String { return "Ө" }
	override class var length: Int {return 3} //TODO Why don't I just return the length of the array?
	override class var name: String {return "Submarine"}
	var hits = [false, false, false] //Yet to be used
}

public class Carrier : Boat
{
	override class var symbol: String { return "Ш" }
	override class var length: Int {return 4}
	override class var name: String {return "Carrier"}

	var hits = [false, false, false, false]
}

public class Tug : Boat
{
	override class var symbol: String { return "Ӝ" }
	override class var length: Int {return 2}
	override class var name: String {return "Tugboat"}
	var hits = [false, false]
}
