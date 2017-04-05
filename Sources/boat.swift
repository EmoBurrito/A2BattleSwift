public class Boat
{
	//Reeeeally wishing abstract classes were a thing
	class var symbol: String {return " "} //Symbol represenation
	class var length: Int {return 0}
	class var name: String {return "noone"}
	class var num: Int {return 10} //we convert this to the symbol later!
	public var description: String //The equivilent of a toString
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

	public init ()
	{
		self.hits = []
	}

	/**
	 * Used to build the array of "hits". X and Y are coordinates, false is whether it is hit or not
	 * Only used during construction.
	 */
	public func append(x : Int, y : Int)
	{
		self.hits.append((x, y, false))
	}

	/**
	 * Checks to see if this boat is occupying the tile shot at.
	 * If so, marks coordinate as hit
	 */
	public func check(x : Int, y : Int)
	{
		for i in 0...(type(of: self).length)-1 //Iterate through spots to hit
		{
			//If the spot matches the one we are shooting at
			if hits[i].0 == x && hits[i].1 == y //TODO name the tuple attributes
			{
				hits[i].2 = true
				justSunk() //Check to see if we just sunk this beast
			}
		}
	}

	/**
	 * Similar to isSunk but simply displays the message.
	 * Called when a ship is sunk that turn.
	 */
	public func justSunk()
	{
		//TODO Make this bigger
		if isSunk(){print("You sunk " + type(of: self).name)}
	}

	/**
	 * Checks to see if the ship is infact entirely sunken
	 */
	public func isSunk() -> Bool
	{
		var toReturn = true

		for hit in hits //Iterate through spots to hit
		{
			if hit.2 == false //if any of points on the ship haven't been hit yet, it has not sunk
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
