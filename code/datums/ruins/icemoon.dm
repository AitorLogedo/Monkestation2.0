// Hey! Listen! Update \config\iceruinblacklist.txt with your new ruins!

/datum/map_template/ruin/icemoon
	prefix = "_maps/RandomRuins/IceRuins/"
	allow_duplicates = FALSE
	cost = 5
	ruin_type = ZTRAIT_ICE_RUINS
	default_area = /area/icemoon/surface/outdoors/unexplored
	has_ceiling = TRUE
	ceiling_turf = /turf/closed/mineral/random/snow/do_not_chasm
	ceiling_baseturfs = list(/turf/open/misc/asteroid/snow/icemoon/do_not_chasm)

// above ground only

/datum/map_template/ruin/icemoon/lust
	name = "Ruin of Lust"
	id = "lust"
	description = "Not exactly what you expected."
	suffix = "icemoon_surface_lust.dmm"

/datum/map_template/ruin/icemoon/asteroid
	name = "Asteroid Site"
	id = "asteroidsite"
	description = "Surprised to see us here?"
	suffix = "icemoon_surface_asteroid.dmm"

/datum/map_template/ruin/icemoon/engioutpost
	name = "Engineer Outpost"
	id = "engioutpost"
	description = "Blown up by an unfortunate accident."
	suffix = "icemoon_surface_engioutpost.dmm"

/datum/map_template/ruin/icemoon/fountain
	name = "Fountain Hall"
	id = "ice_fountain"
	description = "The fountain has a warning on the side. DANGER: May have undeclared side effects that only become obvious when implemented."
	prefix = "_maps/RandomRuins/AnywhereRuins/"
	suffix = "fountain_hall.dmm"

/datum/map_template/ruin/icemoon/abandoned_homestead
	name = "Abandoned Homestead"
	id = "abandoned_homestead"
	description = "This homestead was once host to a happy homesteading family. It's now host to hungry bears."
	suffix = "icemoon_underground_abandoned_homestead.dmm"

/datum/map_template/ruin/icemoon/entemology
	name = "Insect Research Station"
	id = "bug_habitat"
	description = "An independently funded research outpost, long abandoned. Their mission, to boldly go where no insect life would ever live, ever, and look for bugs."
	suffix = "icemoon_surface_bughabitat.dmm"

/datum/map_template/ruin/icemoon/pizza
	name = "Moffuchi's Pizzeria"
	id = "pizzeria"
	description = "Moffuchi's Family Pizzeria chain has a reputation for providing affordable artisanal meals of questionable edibility. This particular pizzeria seems to have been abandoned for some time."
	suffix = "icemoon_surface_pizza.dmm"

/datum/map_template/ruin/icemoon/smoking_room
	name = "Smoking Room"
	id = "smoking_room"
	description = "Here lies Charles Morlbaro. He died the way he lived."
	suffix = "icemoon_surface_smoking_room.dmm"

// above and below ground together

/datum/map_template/ruin/icemoon/mining_site
	name = "Mining Site"
	id = "miningsite"
	description = "Ruins of a site where people once mined with primitive tools for ore."
	suffix = "icemoon_surface_mining_site.dmm"
	always_place = TRUE
	always_spawn_with = list(/datum/map_template/ruin/icemoon/underground/mining_site_below = PLACE_BELOW)

/datum/map_template/ruin/icemoon/underground/mining_site_below
	name = "Mining Site Underground"
	id = "miningsite-underground"
	description = "Who knew ladders could be so useful?"
	suffix = "icemoon_underground_mining_site.dmm"
	has_ceiling = FALSE
	unpickable = TRUE

// below ground only

/datum/map_template/ruin/icemoon/underground
	name = "underground ruin"
	ruin_type = ZTRAIT_ICE_RUINS_UNDERGROUND
	default_area = /area/icemoon/underground/unexplored

/datum/map_template/ruin/icemoon/underground/abandonedvillage
	name = "Abandoned Village"
	id = "abandonedvillage"
	description = "Who knows what lies within?"
	suffix = "icemoon_underground_abandoned_village.dmm"

/datum/map_template/ruin/icemoon/underground/library
	name = "Buried Library"
	id = "buriedlibrary"
	description = "A once grand library, now lost to the confines of the Ice Moon."
	suffix = "icemoon_underground_library.dmm"

/datum/map_template/ruin/icemoon/underground/wrath
	name = "Ruin of Wrath"
	id = "wrath"
	description = "You'll fight and fight and just keep fighting."
	suffix = "icemoon_underground_wrath.dmm"

/datum/map_template/ruin/icemoon/underground/hermit
	name = "Frozen Shack"
	id = "hermitshack"
	description = "A place of shelter for a lone hermit, scraping by to live another day."
	suffix = "icemoon_underground_hermit.dmm"

/datum/map_template/ruin/icemoon/underground/lavaland
	name = "Lavaland Site"
	id = "lavalandsite"
	description = "I guess we never really left you huh?"
	suffix = "icemoon_underground_lavaland.dmm"

/datum/map_template/ruin/icemoon/underground/puzzle
	name = "Ancient Puzzle"
	id = "puzzle"
	description = "Mystery to be solved."
	suffix = "icemoon_underground_puzzle.dmm"

/datum/map_template/ruin/icemoon/underground/bathhouse
	name = "Bath House"
	id = "bathhouse"
	description = "A warm, safe place."
	suffix = "icemoon_underground_bathhouse.dmm"

/datum/map_template/ruin/icemoon/underground/wendigo_cave
	name = "Wendigo Cave"
	id = "wendigocave"
	description = "Into the jaws of the beast."
	suffix = "icemoon_underground_wendigo_cave.dmm"

/datum/map_template/ruin/icemoon/underground/free_golem
	name = "Free Golem Ship"
	id = "golem-ship"
	description = "Lumbering humanoids, made out of precious metals, move inside this ship. They frequently leave to mine more minerals, which they somehow turn into more of them. \
	Seem very intent on research and individual liberty, and also geology-based naming?"
	prefix = "_maps/RandomRuins/AnywhereRuins/"
	suffix = "golem_ship.dmm"

/datum/map_template/ruin/icemoon/underground/mailroom
	name = "Frozen-over Post Office"
	id = "mailroom"
	description = "This is where all of your paychecks went. Signed, the management."
	suffix = "icemoon_underground_mailroom.dmm"

/datum/map_template/ruin/icemoon/underground/frozen_comms
	name = "Frozen Communicatons Outpost"
	id = "frozen_comms"
	description = "3 Peaks Radio, where the 2000's live forever."
	suffix = "icemoon_underground_frozen_comms.dmm"

//TODO: Bottom-Level ONLY Spawns after Refactoring Related Code
/datum/map_template/ruin/icemoon/underground/plasma_facility
	name = "Abandoned Plasma Facility"
	id = "plasma_facility"
	description = "Rumors have developed over the many years of Freyja plasma mining. These rumors suggest that the ghosts of dead mistreated excavation staff have returned to \
	exact revenge on their (now former) employers. Coorperate reminds all staff that rumors are just that: Old Housewife tales meant to scare misbehaving kids to bed."
	suffix = "icemoon_underground_abandoned_plasma_facility.dmm"

/datum/map_template/ruin/icemoon/underground/hotsprings
	name = "Hot Springs"
	id = "hotsprings"
	description = "Just relax and take a dip, nothing will go wrong, I swear!"
	suffix = "icemoon_underground_hotsprings.dmm"

/datum/map_template/ruin/icemoon/underground/oldstation
	id = "ice_oldstation"
	suffix = "icemoon_underground_oldstation.dmm"
	name = "Ancient Ice Moon Outpost"
	description = "The crew of an outpost awaken one hundred years after a crisis. Awaking to a derelict outpost on the verge of collapse, and a hostile force of invading \
	xenomorphs. Can the surviving crew overcome the odds and survive and rebuild, or will the cold embrace of the stars become their new home?"
