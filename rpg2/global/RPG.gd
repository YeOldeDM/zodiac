
extends Node

#	RPG mothernode	#


# Global Game members
var party
var inventory
var money


# elements
const ELEMENT_FIRE = 0
const ELEMENT_ICE = 1
const ELEMENT_LIGHTNING = 2
const ELEMENT_EARTH = 3
const ELEMENT_WATER = 4
const ELEMENT_WIND = 5
const ELEMENT_HOLY = 6
const ELEMENT_DARKNESS = 7

# elemental affinities
const ELEMENT_WEAKNESS = 0
const ELEMENT_STANDARD = 1
const ELEMENT_RESIST = 2
const ELEMENT_IMMUNE = 3
const ELEMENT_ABSORB = 4
const ELEMENT_GREAT_ABSORB = 5

# status effects
const STATUS_BERZERK = 0
const STATUS_BLIND = 1
const STATUS_CHARM = 2
const STATUS_CONFUSION = 3
const STATUS_CURSE = 4
const STATUS_DSENTENCE = 5
const STATUS_FROG = 6
const STATUS_MINI = 7
const STATUS_POISON = 8
const STATUS_SEAL = 9
const STATUS_SLEEP = 10
const STATUS_SLOW = 11
const STATUS_STONE = 12
const STATUS_STUN = 13
const STATUS_DEATH = 14
const STATUS_VENOM = 15
const STATUS_ZOMBIE = 16
# (positive status effects)
const STATUS_BARRIER = 17
const STATUS_HASTE = 18
const STATUS_MBARRIER = 19
const STATUS_REGEN = 20
const STATUS_RERAISE = 21
const STATUS_WALL = 22

# tech cost methods
const TECH_STANDARD = 0
const TECH_CHARGE = 1
const TECH_SACRIFICE = 2
const TECH_SACRIFICE_B = 3

# Battle Actions
const BATTLE_FIGHT = 0

