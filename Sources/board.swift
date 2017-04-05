import Foundation
//Override of Array.contains found here:
//http://stackoverflow.com/questions/24102024/how-to-check-if-an-element-is-in-an-array
@available(iOS, deprecated:11.0)
extension Array {
    func contains<T where T : Equatable>(obj: T) -> Bool{
        return self.filter({$0 as? T == obj}).count > 0
    }
}
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
	//An array to hold boats that we can shoot at
	var targets = [Boat]()

	/**
	 * Generate boats and add them to the board.
	 * I mean it's not really a harbour. We're at war here, Stephanie!
	 */
	func fill_harbour()
	{
		//Seed the random() function, so random is random.
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
		//build_boats(subs:SUBS, cars:CARRIERS, tugs:TUGS)
		build(type:Sub(), num:SUBS)
		build(type:Carrier(), num:CARRIERS)
		build(type:Tug(), num:TUGS)
	}
	/*
		Once we've made our random boats, instantiate them and fill the harbour
	*/
	func build(type:Boat, num:Int)
	{
		if num > 0
		{
			for _ in 1...num
			{
				let b = type
				add(boat:b)
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

	/*
	Used to prompt the player where they want to shoot
	*/
	func prompt()
	{
		let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "!", "?"]
		let numbers = [0,1,2,3,4,5,6,7,8,9]
		var letterTarget:String
		var numberTarget:Int
		//Get input
		print("Choose a letter ('?' for help):")
		//Make sure we can assign the input to a string, else display error
		if let letterIn = String(readLine()!)
		{
			//While we're technically handling this by only parsing the first characters
			//in the string as the entry, we really don't want them to enter words
			if letterIn.characters.count > 1
			{
				print("Your selection was invalid: Please enter a single character only.\n\n")
			}
			else
			{
				if letterIn == letters[11]	// check for '?', show help menu
				{
					showHelp()
				}
				else if letterIn == letters[10]	//check for '!', cheat code
				{
					cheat()
				}
				else	//else its a character, and so we'll uppercase it
				{
					//Parses the input for only the first character, then casts to uppercase
					letterTarget = String(letterIn[letterIn.index(
					letterIn.startIndex, offsetBy: 0)]).uppercased()
					//Now that it's been uppercased, ensure it's a valid entry
					if letters.contains(letterTarget)
					{
						//letterTarget is valid, so prompt for a number selection
						print("Choose a number:")
						//Ensure we can parse to an Int, else display error
						if let numberIn : Int = Int(readLine()!)
						{
							//Only allow numbers 0-9, nothing else.
							if numbers.contains(numberIn)
							{
								numberTarget = numberIn
								//If valid, use the coordinates to shoot at target.
								shoot(letter : letterTarget, number : numberTarget)
							}
							else	//Helpful error for invalid number selection.
							{
								print("Your selection was invalid: must be numbers 0-9.\n\n")
							}
						}
						else	//Helpful error for invalid number selection.
						{
							print("Your selection was invalid: must be numbers 0-9.\n\n")
						}
					}
					else	//Helpful error for invalid character selection.
					{
						print("Your selection was invalid: must be letters A-J, or '?' for help.\n\n")
					}
				}
			}
		}
		else	//Helpful error for "you entered a string, we don't want strings"
		{
			print("Your selection was invalid: Please enter a single character only.\n\n")
		}
	}

	/*
	*	Displays for the user how many of each kind of boat, exists in the current
	* iteration of the game; then re-displays the board and prompts them again.
	*/
	func showHelp()
	{
		print("There are \(SUBS) subs, \(CARRIERS) carriers, and \(TUGS) tugboats in this game.\n")
		display()
		prompt()
	}

	/*
	* Cheaters never prosper ... so if you cheat, the game ends. Reveals all boat
	* locations in the game, at the expense of the game ending.
	*/
	func cheat()
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
		//Display the updated board
		display()
	}

	/*
	* Shoot at target
	*/
	func shoot(letter : String, number : Int)
	{
		var yAxis = 0
		//Get the Unicode value of the letter, starting with A=0, B=1, C=2, etc.
		for code in String(letter).utf8 { yAxis=(Int(code)-65) }
		//If location's value is less than "fired", or has not been shot at
		if area[yAxis][number] < FE
		{
			//Set the value at location to indicate it's been shot at
			area[yAxis][number] += FIRE_DIFFERENCE;
			//Change the appropriate ship's "hits" to reflect this
			checkTargets(x : number, y : yAxis)
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
