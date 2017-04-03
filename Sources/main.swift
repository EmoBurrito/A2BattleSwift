import boat.swift
import board.swift

print("######################################")
print("# Welcome to Command Line Battleship #")
print("######################################")

var myBoard = Board()
myBoard.display()

myBoard.populate()
myBoard.prompt()
