/// A board to play on. Contains ships for the players to shoot at.
public class Board
{
	/// The number of boats to have on the board
	let BOATS = 5
	///The width of the board, minus 1 since arrays are 0 based
	let XAXIS = 9
	///The height of the board, minus 1 since arrays are 0 based
	let YAXIS = 9
	///Unfired empty, sub, carrier, and tug
	static let UE = 10
	static let US = 11
	static let UC = 12
	static let UT = 13
	///Fired empty, sub, carrier, and tug
	static let FE = 20
	static let FS = 21
	static let FC = 22
	static let FT = 23

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
						case FS: rowText += sub.symbol
						case FC: rowText += "?"
						case FT: rowText += "?"
						default: rowText += "?" //Should never happen
					}
				}
			}
			print(rowText)
		}
	}
}