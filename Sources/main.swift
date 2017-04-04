print("######################################")
print("# Welcome to Command Line Battleship #")
print("######################################")

var myBoard = Board()
myBoard.display()

var victory = false
var playGame = true

myBoard.populate()
//var mySub = Sub()
//myBoard.add(boat : mySub)

while playGame
{
	while !victory
	{
		myBoard.prompt()

		//Check to see if all ships are destroyed
		victory = myBoard.victoryCheck()
	}

	//Ask if they want to play again
	print("Play again?")
	var answer : String = String(readLine()!)!
	answer = String(answer[answer.index(answer.startIndex, offsetBy: 0)]).uppercased()
	if answer != "Y"
	{
		playGame = false
	}
}