extends Node

enum MonsterTypeEnum { SLIME, PIRATE, MEDUSA }

var ShakyHands: bool = true
var InvertedControls: bool = false

var DynamicSensitivity: bool = false

var BrushContainer: Node2D
var DrawArea: Polygon2D
var DrawValidityMatrix: TileMap

var DialogueTimeStamps = {}
var CurrentMonster: MonsterTypeEnum
var MonsterSfxDirectory: Array[String] = ["slime", "pirate", "medusa"]

var CurrentGameState

var quick_references = {}

var DateCounter = 1
