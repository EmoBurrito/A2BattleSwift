public class Boat
{
	//Symbol represenation
	//Reeeeally wishing abstract classes were a thing
	class var symbol: String {return " "}
	class var length: Int {return 0}
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
	override class var length: Int {return 4}

	var hits = [false, false, false, false]
}

public class Tug : Boat
{
	override class var symbol: String { return "Ӝ" }
	override class var length: Int {return 2}

	var hits = [false, false]
}