/// A board to play on. Contains ships for the players to shoot at.
public class Board
{
	/// The number of boats to have on the board
	let BOATS = 5
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

	/**
		Ships: 

		- Submarine: Ө
		- Aircraft Carrier: Ш
		- Tugboat: Ӝ
	 */
	enum Boats
	{
		case sub, carrier, tug
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
}