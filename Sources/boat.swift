public class Boat
{
	//Symbol represenation
	//Reeeeally wishing abstract classes were a thing
	class var symbol: String {return " "}
	class var length: Int {return 0} //Hardcoded because the arrays need to be non-static, but our generic populate call wants it to be static

	//Should boats know their location, as well as if they've been hit or not?
	// We should also be able to write a function so the boat knows how many times
	//it can be hit, based on its length
}

public class Sub : Boat
{
	override class var symbol: String { return "Ө" }
	override class var length: Int {return 3}

	var hits = [false, false, false] //Yet to be used
}

public class Carrier : Boat
{
	override class var symbol: String { return "Ш" }
	override class var length: Int {return 5}

	var hits = [false, false, false, false]
}

public class Tug : Boat
{
	override class var symbol: String { return "Ӝ" }
	override class var length: Int {return 2}

	var hits = [false, false]
}
