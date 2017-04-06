print("######################################")
print("# Welcome to Command Line Battleship #")
print("######################################")

var victory = false
var playGame = true

while playGame
{
	var myBoard = Board()
	myBoard.display()
	myBoard.fill_harbour()
	while !victory
	{
		myBoard.prompt()

		//Check to see if all ships are destroyed
		victory = myBoard.victoryCheck()
	}
	//Ask if they want to play again
	print("Would you like to play again? (Y/N)")
	var answer : String = String(readLine()!)!
	answer = String(answer[answer.index(
	answer.startIndex, offsetBy: 0)]).uppercased()

	if answer == "Y"
	{
		victory = false
	}
	else
	{
		playGame = false
	}
}

print ("Thanks for playing Command Line Battleship!")
