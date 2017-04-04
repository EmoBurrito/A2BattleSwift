public class Boat
{
	//Symbol represenation
	//Reeeeally wishing abstract classes were a thing
	class var symbol: String {return " "}
	class var length: Int {return 0}
	class var name: String {return "noone"}
	class var num: Int {return 10} //we convert this to the symbol later!
}

public class Sub : Boat
{
	override class var symbol: String { return "Ө" }
	override class var length: Int {return 3}
	override class var name: String {return "Submarine"}
	override class var num: Int {return 11} //we convert this to the symbol later!
	var hits = [false, false, false] //Yet to be used
}

public class Carrier : Boat
{
	override class var symbol: String { return "Ш" }
	override class var length: Int {return 4}
	override class var name: String {return "Carrier"}
	override class var num: Int {return 12} //we convert this to the symbol later!
	var hits = [false, false, false, false]
}

public class Tug : Boat
{
	override class var symbol: String { return "Ӝ" }
	override class var length: Int {return 2}
	override class var name: String {return "Tug Boat"}
	override class var num: Int {return 13} //we convert this to the symbol later!
	var hits = [false, false]
}
