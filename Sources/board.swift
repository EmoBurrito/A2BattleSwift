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

	//Generate boats and add them to the board
	func fill_harbor()
	{
		//Make five boats!
		for _ in 0...4
		{
			srand( UInt32( time( nil ) ) )
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
	*/
	func build_boats(subs:Int, cars:Int, tugs:Int)
	{
		if subs != 0
		{
			for _ in 0...subs
			{
				let s = Sub()
				add(boat:s)
			}
		}
		if cars != 0
		{
			for _ in 0...cars
			{
				let c = Carrier()
				add(boat:c)
			}
		}
		if tugs != 0
		{
			for _ in 0...tugs
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
					rowText += " 🌊" //space, then Wave character
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
			//Get the Unicode value of the letter, starting with A=0, B=1, C=2, etc.
			var yAxis = 0
			for code in String(letter).utf8 { yAxis=(Int(code)-65) }

			//For debug
			print("Shooting at [\(number)][\(yAxis)]")

			area[yAxis][number] += FIRE_DIFFERENCE;
		}

		//Display the updated board
		display()
	}

	//TODO Make this part of the initializer
	func populate()
	{
		fill_harbor()
	}

	func add(boat : Boat)
	{
		//Pick random starting point
		let x = random() % XAXIS
		let y = random() % YAXIS
		// let sym = {
		// 	switch type(of:boat){
		// 	case is Sub: Sub.symbol;
		// 		break;
		// 	case is Carrier: Carrier.symbol;
		// 		break;
		// 	case is Tug: Tug.symbol;
		// 		break;
		// 	default : ":)";
		// 		break;
		// 	}
		// }
		if random() % 2 == 0 //Randomly pick if will be horizontal or vertical
			{
				//Check to see if it'll even fit first. This will cause boats to avoid
				//borders, unfortunately
				if x+type(of: boat).length < XAXIS-1
				{

					for i in 1...type(of: boat).length
					{
						//For Debug
						// print("X + sublength: \(x+type(of: boat).length)")
						// print("Putting at \(y-1),\(x+i-1)")
						area[y-1][x+i-1] = Board.US //Turns UE into US, UC, UT, etc.
					}
				}
				else
				{

					for i in 1...type(of: boat).length
					{
						// print("X + sublength: \(x+type(of: boat).length)")
						// print("Putting at \(y-1),\(x-i-1)")
						area[y-1][x-i-1] = Board.US
					}
				}
			}
			else
			{
				if y+type(of: boat).length < YAXIS-1
				{

					for i in 1...type(of: boat).length
					{
						// print("Y + sublength: \(y+type(of: boat).length)")
						// print("Putting at \(y+i-1),\(x-1)")
						area[y+i-1][x-1] = Board.US
					}
				}
				else
				{

					for i in 1...type(of: boat).length
					{
						// print("Y + sublength: \(y+type(of: boat).length)")
						// print("Putting at \(y-i-1),\(x-1)")
						area[y-i-1][x-1] = Board.US
					}
				}
			}
	}

	func victoryCheck() -> Bool
	{
		return false
	}
}
