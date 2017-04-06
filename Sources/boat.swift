public class Boat
{
	//Symbol represenation
	class var symbol: String{return " "}
	class var length: Int{return 0}
	class var name: String{return "noone"}
	//we convert this to the symbol later!
	class var num: Int{return 10}
	//The equivilent of a toString
	public var description: String
	{
		var toReturn = ""
		toReturn += type(of: self).name + " | Hits:"
		//Iterate through hits and append them
		for hit in self.hits
		{
			toReturn += String(hit.2) + ", "
		}
		return toReturn
	}
	var hits:[(Int, Int, Bool)]
	public init (){self.hits = []}

	/* FUNCTION: append
	 * PURPOSE: Used to build the array of "hits". X and Y are coordinates, false
	 is whether it is hit or not. Only used during construction.
	 * PARAMS: x-> horizontal coordinate
	 * 				 y-> vertical coordinate
	 */
	public func append(x : Int, y : Int)
	{
		self.hits.append((x, y, false))
	}

	/* FUNCTION: check
	 * PURPOSE: Checks to see if this boat is occupying the tile shot at.
	 * If so, marks coordinate as hit
	 * PARAMS: x-> horizontal coordinate
	 * 				 y-> vertical coordinate
	 */
	public func check(x : Int, y : Int)
	{
		//Iterate through spots to hit
		for i in 0...(type(of: self).length)-1
		{
			//If the spot matches the one we are shooting at
			if hits[i].0 == x && hits[i].1 == y
			{
				hits[i].2 = true
				//Check to see if we just sunk this boat
				justSunk()
			}
		}
	}

	/**FUNCTION: justSunk
	 * PURPOSE: Similar to isSunk but simply displays the message.
	 * Called when a ship is sunk that turn.
	 */
	public func justSunk()
	{
		if isSunk()
		{
			print("You sunk a " + type(of: self).name + "!!!!")
		}
	}

	/**FUNCTION: isSunk
	 * PURPOSE: Checks to see if the ship is infact entirely sunken
	 * RETURNS: Boolean. True if sunk, false otherwise.
	 */
	public func isSunk() -> Bool
	{
		var toReturn = true
		//Iterate through spots to hit
		for hit in hits
		{
			//if any of points on the ship haven't been hit yet, it has not sunk
			if hit.2 == false
			{
				toReturn = false
			}
		}
		return toReturn
	}
}

public class Sub : Boat
{
	override class var symbol: String { return "Ө" }
	override class var length: Int {return 3}
	override class var name: String {return "Submarine"}
	override class var num: Int {return 11}
}

public class Carrier : Boat
{
	override class var symbol: String { return "Ш" }
	override class var length: Int {return 4}
	override class var name: String {return "Carrier"}
	override class var num: Int {return 12}
}

public class Tug : Boat
{
	override class var symbol: String { return "Ӝ" }
	override class var length: Int {return 2}
	override class var name: String {return "Tug Boat"}
	override class var num: Int {return 13}
}
