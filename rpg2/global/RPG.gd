
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
const TECH_COST_STANDARD = 0
const TECH_COST_CHARGE = 1
const TECH_COST_SACRIFICE = 2
const TECH_COST_SACRIFICE_B = 3

# Battle Actions
const BATTLEACTION_NULL = -1
const BATTLEACTION_FIGHT = 0
const BATTLEACTION_TECH = 1
const BATTLEACTION_ITEM = 2
const BATTLEACTION_BLOCK = 3
const BATTLEACTION_RUN = 4
const BATTLEACTION_SPECIAL = 5
const BATTLEACTION_OTHER = 6

const BATTLEACTION_HOSTILE = 0
const BATTLEACTION_FRIENDLY = 1

var command_skill_names = [
	"Capture",
	"Coin Toss",
	"Chakra",
	"Clone",
	"Deathblow",
	"Dice",
	"Draw Out",
	"Health",
	"Jump",
	"Kick",
	"Manipulate",
	"Mimic",
	"Mix",
	"Morph",
	"Peep",
	"Peril",
	"Rage",
	"Runic",
	"Slots",
	"Steal",
	"Throw",
	"Wish",
	"X-Magic"
	]

var support_skill_names = [
	"Attack Up",
	"Chemist",
	"Concentrate",
	"Counter",
	"Cover",
	"Flight",
	"Lucky",
	"Magic Up",
	"Mental Strength",
	"Natural Resistance",
	"Quickness",
	"Secret Hunt",
	"Toughness",
	"Weapon Guard"
	]
# Hero Command/Support Skills
const COMMAND_SKILL_CAPTURE = 0
const COMMAND_SKILL_COINTOSS = 1
const COMMAND_SKILL_CHAKRA = 2
const COMMAND_SKILL_CLONE = 3
const COMMAND_SKILL_DEATHBLOW = 4
const COMMAND_SKILL_DICE = 5
const COMMAND_SKILL_DRAWOUT = 6
const COMMAND_SKILL_HEALTH = 7
const COMMAND_SKILL_JUMP = 8
const COMMAND_SKILL_KICK = 9
const COMMAND_SKILL_MANIPULATE = 10
const COMMAND_SKILL_MIMIC = 11
const COMMAND_SKILL_MIX = 12
const COMMAND_SKILL_MORPH = 13
const COMMAND_SKILL_PEEP = 14
const COMMAND_SKILL_PERIL = 15
const COMMAND_SKILL_RAGE = 16
const COMMAND_SKILL_RUNIC = 17
const COMMAND_SKILL_SLOTS = 18
const COMMAND_SKILL_STEAL = 19
const COMMAND_SKILL_THROW = 20
const COMMAND_SKILL_WISH = 21
const COMMAND_SKILL_XMAGIC = 22

const SUPPORT_SKILL_ATTACKUP = 0
const SUPPORT_SKILL_CHEMIST = 1
const SUPPORT_SKILL_CONCENTRATE = 2
const SUPPORT_SKILL_COUNTER = 3
const SUPPORT_SKILL_COVER = 4
const SUPPORT_SKILL_FLIGHT = 5
const SUPPORT_SKILL_LUCKY = 6
const SUPPORT_SKILL_MAGICUP = 7
const SUPPORT_SKILL_MENTALSTRENGTH = 8
const SUPPORT_SKILL_NATURALRESISTANCE = 9
const SUPPORT_SKILL_QUICKNESS = 10
const SUPPORT_SKILL_SECRETHUNT = 11
const SUPPORT_SKILL_TOUGHNESS = 12
const SUPPORT_SKILL_WEAPONGUARD = 13