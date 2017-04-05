import Foundation

/// A board to play on. Contains ships for the players to shoot at.
public class Board
{
	/// The number of boats to have on the board
	// generate a random sub, carrier, or tug, to a max of 5 boats
	var SUBS = 0 // between 1-5 subs, but we can have none as well (go go random)
	var CARRIERS = 0 // between 1-5 carriers
	var TUGS = 0 // between 1-5 tugboats
	///The width of the board, minus 1 since arrays are 0 based
	let XAXIS = 9
	///The height of the board, minus 1 since arrays are 0 based
	let YAXIS = 9

	//The difference between "unfired" and "fired". Doesn't like static?
	let FIRE_DIFFERENCE = 10

	///Unfired empty, Sub, carrier, and tug
	static let UE = 10
	static let US = 11
	static let UC = 12
	static let UT = 13
	///Fired empty, Sub, carrier, and tug
	let FE = 20
	let FS = 21
	let FC = 22
	let FT = 23

	///A two dimensional area containing the board area
	// TODO: Generate this
	var area = [
		[UE, UE, UE, UE, UE, UE, UE, UE, UE, UE],
		[UE, UE, UE, UE, UE, UE, UE, UE, UE, UE],
		[UE, UE, UE, UE, UE, UE, UE, UE, UE, UE],
		[UE, UE, UE, UE, UE, UE, UE, UE, UE, UE],
		[UE, UE, UE, UE, UE, UE, UE, UE, UE, UE],
		[UE, UE, UE, UE, UE, UE, UE, UE, UE, UE],
		[UE, UE, UE, UE, UE, UE, UE, UE, UE, UE],
		[UE, UE, UE, UE, UE, UE, UE, UE, UE, UE],
		[UE, UE, UE, UE, UE, UE, UE, UE, UE, UE],
		[UE, UE, UE, UE, UE, UE, UE, UE, UE, UE]
]
	// var area = []

	// for i in 1...YAXIS
	// {
	// 	self.area.append([UE, UE, UE, UE, UE, UE, UE, UE, UE, UE])
	// }

	//An array to hold boats that we can shoot at
	var targets = [Boat]()

	/**
	 * Generate boats and add them to the board.
	 * I mean it's not really a harbour. We're at war here, Stephanie!
	 * Besides, we're a commonwealth, spell it right
	 */
	func fill_harbor()
	{
		srand( UInt32( time( nil ) ) )
		//Make five boats!
		for _ in 0...4
		{

			let rand = Int(random() % 3 + 1) //random number between 1 and 3
			switch rand
			{//based on the random we generated, add to our boat counters
				case 1: SUBS += 1
				case 2: CARRIERS += 1
				case 3: TUGS += 1
				default: break //should never hit this case
			}
		}
		//now, let's instantiate those boats!
		build_boats(subs:SUBS, cars:CARRIERS, tugs:TUGS)
	}
	/*
		Once we've made our random boats, instantiate them and fill the harbor
		//TODO knock this down to one method called three times
	*/
	func build_boats(subs:Int, cars:Int, tugs:Int)
	{
		if subs > 0
		{
			for _ in 1...subs
			{
				let s = Sub()
				add(boat:s)
			}
		}
		if cars > 0
		{
			for _ in 1...cars
			{
				let c = Carrier()
				add(boat:c)
			}
		}
		if tugs > 0
		{
			for _ in 1...tugs
			{
				let t = Tug()
				add(boat:t)
			}
		}
	}

	 /**
	 	Prints the board out to the terminal.
	  */
	func display()
	{
		//Print the header row
		var headerRow = " "
		for i in 0...XAXIS
		{
			headerRow += " " + String(i)
		}
		print (headerRow)

		//Print each other row
		for i in 0...YAXIS
		{
			var rowText:String = ""
			rowText += String(Character(UnicodeScalar(65+i)!))
			for j in 0...XAXIS
			{
				//If area has not been fired at, display fog of war
				if area[i][j] < 20
				{
					rowText += " *"
				}
				//Else, display what is there.
				else
				{
					switch area[i][j]
					{
						case FE: rowText += "  "
						case FS: rowText += " " + Sub.symbol
						case FC: rowText += " " + Carrier.symbol
						case FT: rowText += " " + Tug.symbol
						default: rowText += " ?" //Should never happen
					}
				}
			}
			print(rowText)
		}
	}

	//Used to prompt the player where they want to shoot
	func prompt()
	{
		var letterTarget:String
		//Get input
		print("Choose a letter ('?' for help):")
		//Make sure we can assign the input to a string, else display error
		if let letterIn = String(readLine()!)
		{
			//Parses the input for only the first character, then casts to uppercase
			letterTarget = String(letterIn[letterIn.index(
			letterIn.startIndex, offsetBy: 0)]).uppercased()
			//Now that it's been uppercased, ensure it's a valid entry
			//if small, check for ?
			if letterTarget < "A"
			{
				if letterTarget == "?"
				{
					showHelp()
				}
				else
				{
					print("Your selection was invalid. Please try again.\n\n")
				}
			}
			else if letterTarget > "J"
			{
				if letterTarget == "Z"
				{
					//
				}
				else
				{
					print("Your selection was invalid. Please try again.\n\n")
				}
			}
			else
			{
				print("Choose a number:")
				if let numberTarget : Int = Int(readLine()!)
				{
					shoot(letter : letterTarget, number : numberTarget)
				}
				else
				{
					print("Your selection was invalid. Please try again.\n\n")
				}
			}
		}
		else
		{
			print("Your selection was invalid. Please try again.\n\n")
		}
		//Parses the input for only the first character, then casts to uppercase

		// if letterTarget == "?" 	//display helpful things.
		// {
		// 	showHelp()
		// }

	}

	func showHelp()
	{
		print("There are \(SUBS) subs, \(CARRIERS) carriers, and \(TUGS) tugboats in this game.\n")
		display()
		prompt()
	}

	//Shoot at target
	func shoot(letter : String, number : Int)
	{
		//Cheat code. Used to nuke entire board.
		if letter == "Z" && number == 9
		{
			for i in 0...YAXIS
			{
				for j in 0...XAXIS
				{
					if area[i][j] < FE //If location's value is less than "fired", or has not been shot at
					{
						area[i][j] += FIRE_DIFFERENCE; //Set the value at location to indicate it's been shot at
						checkTargets(x : j, y : i) //Change the appropriate ship's "hits" to reflect this
					}
				}
			}
		}
		else
		{
			var yAxis = 0
			//Get the Unicode value of the letter, starting with A=0, B=1, C=2, etc.
			for code in String(letter).utf8 { yAxis=(Int(code)-65) }

			if area[yAxis][number] < FE
			{
				area[yAxis][number] += FIRE_DIFFERENCE;
				checkTargets(x : number, y : yAxis)
			}
		}
		//Display the updated board
		display()
	}

	func add(boat : Boat)
	{
		//Pick random starting point
		var x = random() % XAXIS
		var y = random() % YAXIS
		var orientation = random() % 2 

		//First check to see if these variables will cause a collision. If so, reroll randoms
		while detectCollision(boat : boat, coords : (x,y), orientation : orientation)
		{
			x = random() % XAXIS
			y = random() % YAXIS
			orientation = random() % 2
		}

		if orientation == 0 //Randomly pick if will be horizontal or vertical
		{
			//Check to see if it'll even fit first. This will cause boats to avoid borders, unfortunately
			if x+type(of: boat).length < XAXIS
			{
				for i in 1...type(of: boat).length
				{
					area[y][x+i] = type(of: boat).num //Turns UE into US, UC, UT, etc.
					boat.append(x : x+i, y : y) //Append the potential target to the boat's possible hits array.
				}
			}
			else
			{
				for i in 1...type(of: boat).length
				{
					area[y][x-i] = type(of: boat).num
					boat.append(x : x-i, y : y)
				}
			}
		}
		else
		{
			if y+type(of: boat).length < YAXIS
			{
				for i in 1...type(of: boat).length
				{
					area[y+i][x] = type(of: boat).num
					boat.append(x : x, y : y+i)
				}
			}
			else
			{
				for i in 1...type(of: boat).length
				{
					area[y-i][x] = type(of: boat).num
					boat.append(x : x, y : y-i)
				}
			}
		}

		self.targets.append(boat) //Finally, add this boat to our list of targets
	}

	/**
	 * Checks to see if all the ships have been destroyed
	 * @return Bool Whether the player has won yet
	 */
	func victoryCheck() -> Bool
	{
		var toReturn = true

		//Check all possible targets and make sure they have all been sunk
		for target in targets
		{
			if !target.isSunk()
			{
				toReturn = false
			}
		}

		return toReturn
	}

	/**
	 * Checks to see if the boat can actually occupy where it wants to
	 *
	 * @param boat The boat we want to place
	 * @param coords A tuple of x,y representing where the boat wants to start
	 * @param orientation Either 0 or 1. If 0, increment x. If odd, increment y
	 * @return bool Whether or not a collision was detected
	 */
	func detectCollision(boat : Boat, coords : (Int, Int), orientation : Int) -> Bool
	{
		var collision = false
		
		if orientation == 0 //Horizontal
		{
			//Check if boat will fit in array
			if coords.0+type(of: boat).length < XAXIS //TODO -1 may not be necessary
			{
				for i in 0...type(of: boat).length
				{
					//Check for occupancy
					if area[coords.1][coords.0+i] != Board.UE{collision=true}
				}
			}
			else
			{
				for i in 0...type(of: boat).length
				{
					if area[coords.1][coords.0-i] != Board.UE{collision=true}
				}
			}
		}
		else //Vertical
		{
			if coords.1+type(of: boat).length < YAXIS
			{
				for i in 0...type(of: boat).length
				{
					if area[coords.1+i][coords.0] != Board.UE{collision=true}
				}
			}
			else
			{

				for i in 0...type(of: boat).length
				{
					if area[coords.1-i][coords.0] != Board.UE{collision=true}
				}
			}
		}
		return collision
	}

	/**
	 * Iterates through each target and checks to see if they were where where we shot.
	 *
	 * @param x Coordinate on the X axis
 	 * @param y Coordinate on the Y axis
	 */
	func checkTargets(x : Int, y : Int)
	{
		for target in targets //Change the appropriate ship's "hits" to reflect this
		{
			target.check(x : x, y : y)
		}
	}
}
