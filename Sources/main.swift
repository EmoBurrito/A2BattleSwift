print("######################################")
print("# Welcome to Command Line Battleship #")
print("######################################")

var victory = false
var playGame = true

while playGame
{
	var myBoard = Board(length : 9,width : 9)
	while !victory
	{
		myBoard.display()
		myBoard.prompt()

		//Check to see if all ships are destroyed
		victory = myBoard.victoryCheck()
	}
	//Ask if they want to play again
	print("Would you like to play again? (Y/N)")
	var letterIn = readLine()!
		if letterIn.characters.count == 0
		{
			print("Empty line? Try again, bub")
		}
		else
		{
			letterIn = String(letterIn).uppercased()
			if letterIn == "Y"
			{
				victory = false
			}
			else
			{
				playGame = false
			}
		}	
}

print ("Thanks for playing Command Line Battleship!")
