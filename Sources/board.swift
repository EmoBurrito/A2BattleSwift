import Foundation

/// A board to play on. Contains ships for the players to shoot at.
public class Board
{
	/// The number of boats to have on the board
	// generate a random sub, carrier, or tug, to a max of 5 boats
	var SUBS = 0 // between 1-5 subs
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

	//Generate five boats: a random grouping of subs, carriers, and tugboats.
	func generate_boats()
	{
		for _ in 1...5
		{
			let rand = Int(random() % 3 + 1) //random number between 1 and 3
			switch rand
			{
			case 1: SUBS += 1
			case 2: CARRIERS += 1
			case 3: TUGS += 1
			default: break //should never hit this case
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
			headerRow += String(i)
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
					rowText += "*"
				}
				//Else, display what is there.
				else
				{
					switch area[i][j]
					{
						case FE: rowText += " "
						case FS: rowText += Sub.symbol
						case FC: rowText += "?"
						case FT: rowText += "?"
						default: rowText += "?" //Should never happen
					}
				}
			}
			print(rowText)
		}
	}

	//Used to prompt the player where they want to shoot
	func prompt()
	{
		//Get input
		print("Choose a letter:")
		var letterTarget : String = String(readLine()!)!
		//Parses the input for only the first character, then casts to uppercase
		letterTarget = String(letterTarget[letterTarget.index(letterTarget.startIndex, offsetBy: 0)]).uppercased()

		print("Choose a number:")
		let numberTarget : Int = Int(readLine()!)!

		//TODO Check if input is valid
		if true
		{
			//Shoot
			shoot(letter : letterTarget, number : numberTarget)
		}
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
					area[i][j] += FIRE_DIFFERENCE;
				}
			}
		}
		else
		{
			//area[number][letter]

			//Get the Unicode value of the letter, starting with A=0, B=1, C=2, etc.
			var yAxis = 0
			for code in String(letter).utf8 { yAxis=(Int(code)-65) }

			print("Shooting at [\(number)][\(yAxis)]")

			area[yAxis][number] += FIRE_DIFFERENCE;
		}

		//Display the updated board
		display()
	}

	//TODO Make this part of an initializer
	func populate()
	{
		//Create a sub
		var mySub = Sub()

		//Pick a spot on the board.
		//TODO: Check if already occupied

		//Add subs
		for _ in 1...SUBS
		{
			//TODO make a function pointer out of all of this
			let x = random() % XAXIS
			let y = random() % YAXIS

			if random() % 2 == 0 //Randomly pick if will be horizontal or vertical
			{
				for i in 1...Sub.length
				{
					if x+Sub.length < XAXIS //Place the ship here if there is room
					{
						area[y-1][x+i-1] = Board.US //Turns UE into US
						print("Putting at \(y-1),\(x+i-1)")
					}
					else
					{
						area[y-1][x-i-1] = Board.US //Turns UE into US
						print("Putting at \(y-1),\(x-i-1)")
					}
				}
			}
			else
			{
				for i in 1...Sub.length
				{
					if y+Sub.length < YAXIS //Place the ship here if there is room
					{
						area[y+i-1][x-1] = Board.US //Turns UE into US
						print("Putting at \(y+i-1),\(x+i-1)")
					}
					else
					{
						area[y-i-1][x-1] = Board.US //Turns UE into US
						print("Putting at \(y-i-1),\(x-i-1)")
					}
				}
			}
		}
		//Add Carriers
		for _ in 1...CARRIERS
		{
			let x = random() % XAXIS
			let y = random() % YAXIS

			do //Attempt to put the boat anywhere, but may out of bounds
			{
				if random() % 2 == 0 //Randomly pick if will be horizontal or vertical
				{
					for i in 1...Sub.length
					{
						area[y-1][x+i-1] = Board.US //Turns UE into US
						print("Putting at \(y-1),\(x+i-1)")
					}
				}
				else
				{
					for i in 1...Sub.length
					{
						area[y+i-1][x-1] = Board.US
						print("Putting at \(y-1),\(x+i-1)")
					}
				}
			}
			catch
			{

			}
		}
		//Add tugboats
		for _ in 1...TUGS
		{

		}
	}
}
