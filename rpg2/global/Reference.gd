
extends Node

# Singleton for holding references to various subjects.
# Mostly, descriptions of different aspects for Maker purposes.

const COMMAND_SKILLS = [
# Capture
"You can capture and train monsters to assist you in battle. The Capture command will only work if the target is below 50% of its maximum HP. Once Captured, you may Release the monster at any time during a future battle. It will use any ability it knows on the target of your choice. Once Released, the monster is gone permanently. Only one monster may be Captured at a time.",

#Coin Toss
"Hurls a quantity of gold coins at extremely high velocity, dealing heavy damage to the enemy. For every 1 G thrown, 1 damage is dealt. The damage may target a single enemy, or be divided equally among all enemies. A maximum of 10 + (Level * 10) G may be thrown in a single turn.",

# Chakra
"Chakra restores the HP and MP of one person by an amount equal to 25% and 10% of the user's maximums, respectively.",

# Clone
"This trick, often used by artists, creates an exact duplicate of a single monster to fight on his side. Make a magical attack roll at –40; if successful, the clone fights to the best of its ability on the side of its master. The cloner does not control the clone, and still acts normally in combat. The clone vanishes when killed or when the battle ends. Clone does not work on boss monsters.",

# Deathblow

"You attempt to strike an opponent in a vital spot to deal extra damage. Make an attack roll with a penalty of -40. Note that a natural 90 or higher does NOT automatically hit when using Deathblow. If your attack hits, it is automatically critical, dealing double damage. At the Master’s option, a successful natural roll that exceeds the attacker's Critical may deal triple damage instead of double.",

# Dice
"Dice is an unpredictable ability that deals a random amount of damage. At character creation, choose either Strength or Magic to affect your Dice damage. The damage dealt is done to all enemies.",

# Draw Out
"Draw Out is the ability to release the spirit or latent mystical power within a weapon. When a weapon is Drawn Out, it releases this power, causing a variety of different effects. However, there is a 20% chance each time a weapon is Drawn Out that the power within will escape or consume itself. When this happens, the weapon will remain serviceable in combat, but can never again be Drawn Out. Artifact-level weapons will never lose their power, but if the die roll indicates a \"break,\" that weapon cannot be Drawn Out for the rest of the battle.",

# Health
"The Health ability restores the HP of all allies by 20% of their maximums.",

# Jump
"You jump high into the air, putting you out of reach of weapons and other effects. On your next turn, you come down on a single enemy, dealing double damage with a normal attack.",

# Kick
"You can deliver a flying kick or other area attack, dealing 1 / 3 normal damage to all enemies. Other possible uses of this power include Leo’s Shock and Cecil’s Dark Wave. If the Master allows it, you may attach an elemental to your attack.",

# Manipulate
"You attempt to control one opponent's body and mind. To Manipulate a target, you must make a successful magic attack roll at -40. You no longer take any actions in combat instead, you control the Manipulated target. Manipulation ends when the victim takes damage from a spell or attack, or when you choose to release the monster. Releasing a Manipulated monster is a Free Action, and is executed on the monster’s turn.",

# Mimic
"You copy the last attack or special ability used by the target. The effect of the power is the same, but uses your Strength and Magic dice and bonuses. You choose the target of the power, but you must pay any costs associated with the power. You may Mimic any target, friend or foe.",

# Mix
"You combine two items into a more powerful effect. This effect is largely dependent on the ingredients and may do anything from harming your enemies to healing your allies to more",

# Morph
"You are able to morph into a more powerful form. Doing so requires one action. While transformed, your Strength and Magic are doubled. In addition, your Hit Points are maxed out upon transformation. If you so desire, and the Master allows it, your alternate form may have a different set of Techs and a different Minor Ability than you normally do. At the end of each of your turns - not counting the turn in which you activate Morph you lose 15% of your maximum MP. If this loss reduces you to 0 MP, you immediately revert to your original shape. You may also choose to revert as your action for the round. Doing so negates the loss of MP for that round. In either case, your HP - but not your MP - is restored to what it was before your transformation. If you are reduced to 0 HP while transformed, you immediately revert with 1 HP remaining. You may Morph only once per battle.",

# Peep
"You can examine a monster and discern its strengths and weaknesses. You discover the monster's Current / Maximum HP, Current / Maximum MP, Weaknesses, Resistances, and Absorbencies. You can also spot any items the monster may be carrying.",

# Peril
"A powerful attack that leaves the user more vulnerable to attack, Peril deals twice the damage of a normal attack, but all damage dealt to the character until his next turn is increased by 50%.",

# Rage
"When you enter a Rage, you go berserk. Until the end of the battle, you can take no actions other than normal attacks. While berserk, you gain a +25% bonus to the damage you deal with weapons. During the round in which you activate Rage, you also immediately make a normal attack. However, because you can feel no pain, the Master will keep track of your HP- you will not know how much damage you take or how close you are to dying!",

# Runic
"You can use your weapon to attract the energy of magical attacks. Generally, this means an attack that deals magical damage and uses Magic as its relevant stat (if any), but the Master may make exceptions. Any such attack that is directed against you or your allies between the time you use Runic and your next turn has no effect. Instead, you gain an amount of HP equal to 1 / 10 of what the damage would have been, and an amount of MP equal to 1 / 5 the amount of HP gained. Runic cannot absorb attacks that automatically target an area.",

# Slots
"Slots is the ultimate gamble for those who like a little excitement. When invoked, Slots produces a random effect that may be helpful or harmful to the user and his allies.",

# Steal
"You attempt to steal from your target in the heat of combat. Make an attack roll at -25; if, successful, you steal one of the target’s Steal Items. The item may be the one of lowest G value, or may be chosen randomly, at the Master’s option. Steal can only capture Steal Items, not Drop Items.",

# Throw
"You can throw a single weapon with devastating force. Roll damage as for a normal attack with the chosen weapon, but double the resultant damage. The weapon is destroyed in the process.",

# Wish
"You may sacrifice any number of HP you wish to restore one ally's HP by three times that amount. For example, if you chose to give up 100 HP, your ally would regain 300 HP. You may not target yourself with Wish, and may not sacrifice more HP than you currently have. If Wish reduces you to 0 HP, you may either heal ALL allies instead of one, or choose one ally whose HP and MP are completely restored.",

# X-Magic
"X-Magic (or X-Tech, if you prefer) allows you to burn MP more rapidly in exchange for a much greater attack rate. You may use two Techs (and no more) in a single turn, one after the other, but you must pay an additional amount of MP equal to 50% of the total spent. For example, if you use X-Magic to cast Flare (26 MP) followed by Fire 3 (19 MP), which have a combined MP cost of 45 MP, you must spend an additional 23 MP for a grand total of 68 MP."
]


const SUPPORT_SKILLS = [
# AttackUP
"The character possesses great physical strength. His starting Attack Power is increased by 5. In addition, for every 5 points of Strength the character has, he gains an additional +1 bonus to his Attack Power. For example, a character with a Strength stat of 50 would have +10 AP added to his base AP.",

# Chemist
"You are able to use items to better effect. Whenever you use a potion or ether, you heal double the HP or MP that you normally would when using such items. When using a status dispel item, you remove that status from the entire party.",

# Concentrate
"The character has a sixth sense when it comes to attacking with weapons. His physical attacks ALWAYS hit their target, and his Critical drops by –2 per 15 Agility, rather than -1. In addition, a critical hit by a character with Concentrate deals TRIPLE its normal damage, rather than double. The effects of Concentrate do not apply to the Deathblow Command Skill.",

# Counter
"You have a chance to counter an enemy's attack with one of your own. At creation, you must choose whether you want to counter attacks made with weapons or special attacks. Weapon attacks include all attacks made with weapons, including unarmed attacks, Weapon Techs, and weapon-related Command Skills such as Jump or Deathblow. Special attacks include various other Command Skills and Techs, such as Slots, Stat Breaks, and Magic Attack Techs. Special attacks may also include other forms of attack as the master sees fit - for example, a rod that fires bolts of energy may be considered a special attack, rather than a weapon attack. ",

# Cover
"When any ally is at 25% or lower of his maximum HP, you will automatically take all damage that would otherwise have struck your wounded ally. It is possible to be Covering multiple allies at once. Cover does not protect the wounded ally against Area Effect powers.",

# Flight
"The gift of Flight is a rare ability usually possessed only by winged races or powerful psychics. The character is considered a Flying character, as per the rules for flight.",

# Lucky
"The character is blessed with unnatural luck. Once per battle, the character may choose to reroll any one die roll. The roll may be one that he makes himself, or one made by another combatant that targets him specifically. He may choose which of the two results to use.",

# MagicUp
"The character possesses great magical power. His starting Magic Attack Power is increased by 5. In addition, for every 5 points of Magic the character has, he gains an additional +1 bonus to his Magic Attack Power. For example, a character with a Magic stat of 50 would have +10 MAP added to his base MAP.",

# Mental Strength
"The character possesses great mental stamina. His starting MP is increased by 5. In addition, for every 5 points of Spirit the character has, he gains an additional +1 MP. For example, a character with a Spirit stat of 50 would have +10 MP added to his base MP.",

# Natural Resistance
"The character has developed a resistance to one of the eight natural Elements. He takes only half damage from attacks of that element.",

# Quickness
"The character is unusually fast and agile, granting him a +2 bonus to Speed.",

# Secret Hunt
"Characters with this skill are experienced at scavenging, and can sometimes fashion useful items from the remains of fallen monsters. Any monster defeated by a character with Secret Hunt has a 100% chance to yield any Drop Items they have, and a 30% chance to drop any Steal Items they still possess.",

# Toughness
"The character possesses great physical stamina. His starting HP is increased by 35. In addition, he gains +6 HP per point of Vitality, instead of the normal +5.",

# Weapon Guard
"The character has learned to parry attacks with his weapon, granting him +2 Evade per level of the weapon he is equipped with.",
]

