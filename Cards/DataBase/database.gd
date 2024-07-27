#Warrior - Common
const AxeAttack = "res://Cards/WarriorCards/AxeAttack.tscn"
const CoverAlly = "res://Cards/WarriorCards/CoverAlly.tscn"
const StunningStrike = "res://Cards/WarriorCards/StunningStrike.tscn"
#Warrior - Uncommon
const FuriousAttack = "res://Cards/WarriorCards/Uncommon/FuriousAttack.tscn"
#Warrior - Rare
const DiewithGlory = "res://Cards/WarriorCards/Rare/DieWithGlory.tscn"

#Mage - Common
const BoltStrike = "res://Cards/MageCards/BoltStrike.tscn"
const ThunderStorm = "res://Cards/MageCards/ThunderStorm.tscn"
const Curse = "res://Cards/MageCards/Curse.tscn"
#Mage - Uncommon
const IceKnife = "res://Cards/MageCards/Uncommon/IceKnife.tscn"
#Mage - Rare
const ConeOfFire = "res://Cards/MageCards/Rare/ConeOfFire.tscn"


#Archer - Common
const PreciseShot = "res://Cards/ArcherCards/PreciseShot.tscn"
const ArrowRain = "res://Cards/ArcherCards/ArrowRain.tscn"
const Burns = "res://Cards/ArcherCards/Burns.tscn"
#Archer - Uncommon
const HeavyArrow = "res://Cards/ArcherCards/Uncommon/HeavyArrow.tscn"
#Archer - Rare
const DestructionRain = "res://Cards/ArcherCards/Rare/DestructionRain.tscn"


#Healer - Common
const Clarity = "res://Cards/HealerCards/Clarity.tscn"
const HealingWord = "res://Cards/HealerCards/HealingWord.tscn"
const StickAttack = "res://Cards/HealerCards/StickAttack.tscn"
#Healer - Uncommon
const MassHealing = "res://Cards/HealerCards/Uncommon/MassHealingWord.tscn"
#Healer - Rare
const PrayersOfPain = "res://Cards/HealerCards/Rare/PrayersOfPain.tscn"

const CARDS_SET = {
	0 : [AxeAttack],
	1 : [CoverAlly],
	2 : [StunningStrike],
	
	3: [HealingWord],
	4: [Clarity],
	5: [StickAttack],
	
	6: [BoltStrike],
	7: [ThunderStorm],
	8: [Curse],
	
	9: [PreciseShot],
	10: [ArrowRain],
	11: [Burns],
	
	#Uncommon
	12: [FuriousAttack],
	13: [IceKnife],
	14: [HeavyArrow],
	15: [MassHealing],
	
	#Rare
	16: [DiewithGlory],
	17: [DestructionRain],
	18: [ConeOfFire],
	19: [PrayersOfPain]
}
