/**
 * # Generic restraints
 *
 * Parent class for handcuffs and handcuff accessories
 *
 * Functionality:
 * 1. A special suicide
 * 2. If a restraint is handcuffing/legcuffing a carbon while being deleted, it will remove the handcuff/legcuff status.
*/
/obj/item/restraints
	breakouttime = 1 MINUTES
	dye_color = DYE_PRISONER
	icon = 'icons/obj/restraints.dmi'

/obj/item/restraints/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] is strangling [user.p_them()]self with [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return OXYLOSS

/**
 * # Handcuffs
 *
 * Stuff that makes humans unable to use hands
 *
 * Clicking people with those will cause an attempt at handcuffing them to occur
*/
/obj/item/restraints/handcuffs
	name = "handcuffs"
	desc = "Use this to keep prisoners in line."
	gender = PLURAL
	icon_state = "handcuff"
	worn_icon_state = "handcuff"
	inhand_icon_state = "handcuff"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_HANDCUFFED
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 5
	custom_materials = list(/datum/material/iron= SMALL_MATERIAL_AMOUNT * 5)
	breakouttime = 1 MINUTES
	var/handcuff_time = 3 SECONDS
	///Multiplier for handcuff time
	var/handcuff_time_mod = 1
	armor_type = /datum/armor/restraints_handcuffs
	custom_price = PAYCHECK_COMMAND * 0.35
	///Sound that plays when starting to put handcuffs on someone
	var/cuffsound = 'sound/weapons/handcuffs.ogg'
	///If set, handcuffs will be destroyed on application and leave behind whatever this is set to.
	var/trashtype = null
	/// How strong the cuffs are. Weak cuffs can be broken with wirecutters or boxcutters.
	var/restraint_strength = HANDCUFFS_TYPE_STRONG

/obj/item/restraints/handcuffs/apply_fantasy_bonuses(bonus)
	. = ..()
	handcuff_time = modify_fantasy_variable("handcuff_time", handcuff_time, -bonus * 2, minimum = 0.3 SECONDS)

/obj/item/restraints/handcuffs/remove_fantasy_bonuses(bonus)
	handcuff_time = reset_fantasy_variable("handcuff_time", handcuff_time)
	return ..()

/datum/armor/restraints_handcuffs
	fire = 50
	acid = 50

/obj/item/restraints/handcuffs/attack(mob/living/carbon/C, mob/living/user)
	if(!istype(C))
		return

	if(SEND_SIGNAL(C, COMSIG_CARBON_CUFF_ATTEMPTED, user) & COMSIG_CARBON_CUFF_PREVENT)
		return

	if(iscarbon(user) && (HAS_TRAIT(user, TRAIT_CLUMSY) && prob(50))) //Clumsy people have a 50% chance to handcuff themselves instead of their target.
		to_chat(user, span_warning("Uh... how do those things work?!"))
		apply_cuffs(user,user)
		return

	if(!C.handcuffed)
		if(C.canBeHandcuffed())
			C.visible_message(span_danger("[user] is trying to put [src] on [C]!"), \
								span_userdanger("[user] is trying to put [src] on you!"))
			if(C.is_blind())
				to_chat(C, span_userdanger("As you feel someone grab your wrists, [src] start digging into your skin!"))

			playsound(loc, cuffsound, 30, TRUE, -2)
			log_combat(user, C, "attempted to handcuff")

			if(HAS_TRAIT(user, TRAIT_FAST_CUFFING))
				handcuff_time_mod = 0.75
			else
				handcuff_time_mod = 1

			if(do_after(user, handcuff_time * handcuff_time_mod, C, timed_action_flags = IGNORE_SLOWDOWNS) && C.canBeHandcuffed())
				if(iscyborg(user))
					apply_cuffs(C, user, TRUE)
				else
					apply_cuffs(C, user)
				C.visible_message(span_notice("[user] handcuffs [C]."), \
									span_userdanger("[user] handcuffs you."))
				SSblackbox.record_feedback("tally", "handcuffs", 1, type)

				log_combat(user, C, "handcuffed")
			else
				to_chat(user, span_warning("You fail to handcuff [C]!"))
				log_combat(user, C, "failed to handcuff")
		else
			to_chat(user, span_warning("[C] doesn't have two hands..."))

/**
 * This handles handcuffing people
 *
 * When called, this instantly puts handcuffs on someone (if possible)
 * Arguments:
 * * mob/living/carbon/target - Who is being handcuffed
 * * mob/user - Who or what is doing the handcuffing
 * * dispense - True if the cuffing should create a new item instead of using putting src on the mob, false otherwise. False by default.
*/
/obj/item/restraints/handcuffs/proc/apply_cuffs(mob/living/carbon/target, mob/user, dispense = FALSE)
	if(target.handcuffed)
		return

	if(!user.temporarilyRemoveItemFromInventory(src) && !dispense)
		return

	var/obj/item/restraints/handcuffs/cuffs = src
	if(trashtype)
		cuffs = new trashtype()
	else if(dispense)
		cuffs = new type()

	target.equip_to_slot(cuffs, ITEM_SLOT_HANDCUFFED)

	if(trashtype && !dispense)
		qdel(src)
	return

/**
 * # Alien handcuffs
 *
 * Abductor reskin of the handcuffs.
*/
/obj/item/restraints/handcuffs/alien
	icon_state = "handcuffAlien"

/**
 *
 * # Fake handcuffs
 *
 * Fake handcuffs that can be removed near-instantly.
*/
/obj/item/restraints/handcuffs/fake
	name = "fake handcuffs"
	desc = "Fake handcuffs meant for gag purposes."
	breakouttime = 1 SECONDS

/**
 * # Cable restraints
 *
 * Ghetto handcuffs. Removing those is faster.
*/
/obj/item/restraints/handcuffs/cable
	name = "cable restraints"
	desc = "Looks like some cables tied together. Could be used to tie something up."
	icon_state = "cuff"
	inhand_icon_state = "coil_red"
	color = CABLE_HEX_COLOR_RED
	///for generating the correct icons based off the original cable's color.
	var/cable_color = CABLE_COLOR_RED
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	custom_materials = list(/datum/material/iron= SMALL_MATERIAL_AMOUNT * 1.5, /datum/material/glass= SMALL_MATERIAL_AMOUNT * 0.75)
	breakouttime = 30 SECONDS
	cuffsound = 'sound/weapons/cablecuff.ogg'

/obj/item/restraints/handcuffs/cable/Initialize(mapload, new_color)
	. = ..()

	var/static/list/hovering_item_typechecks = list(
		/obj/item/stack/rods = list(
			SCREENTIP_CONTEXT_LMB = "Craft wired rod",
		),

		/obj/item/stack/sheet/iron = list(
			SCREENTIP_CONTEXT_LMB = "Craft bola",
		),
	)

	AddElement(/datum/element/contextual_screentip_item_typechecks, hovering_item_typechecks)
	AddElement(/datum/element/update_icon_updates_onmob, (slot_flags|ITEM_SLOT_HANDCUFFED))

	if(new_color)
		set_cable_color(new_color)

/obj/item/restraints/handcuffs/cable/proc/set_cable_color(new_color)
	color = GLOB.cable_colors[new_color]
	cable_color = new_color
	update_appearance(UPDATE_ICON)

/obj/item/restraints/handcuffs/cable/vv_edit_var(vname, vval)
	if(vname == NAMEOF(src, cable_color))
		set_cable_color(vval)
		datum_flags |= DF_VAR_EDITED
		return TRUE
	return ..()

/obj/item/restraints/handcuffs/cable/update_icon_state()
	. = ..()
	if(cable_color)
		var/new_inhand_icon = "coil_[cable_color]"
		if(new_inhand_icon != inhand_icon_state)
			inhand_icon_state = new_inhand_icon //small memory optimization.

/**
 * # Sinew restraints
 *
 * Primal ghetto handcuffs
 *
 * Just cable restraints that look differently and can't be recycled.
*/
/obj/item/restraints/handcuffs/cable/sinew
	name = "sinew restraints"
	desc = "A pair of restraints fashioned from long strands of flesh."
	icon_state = "sinewcuff"
	inhand_icon_state = null
	cable_color = null
	custom_materials = null
	color = null

/**
 * Red cable restraints
*/
/obj/item/restraints/handcuffs/cable/red
	color = CABLE_HEX_COLOR_RED
	cable_color = CABLE_COLOR_RED
	inhand_icon_state = "coil_red"

/**
 * Yellow cable restraints
*/
/obj/item/restraints/handcuffs/cable/yellow
	color = CABLE_HEX_COLOR_YELLOW
	cable_color = CABLE_COLOR_YELLOW
	inhand_icon_state = "coil_yellow"

/**
 * Blue cable restraints
*/
/obj/item/restraints/handcuffs/cable/blue
	color =CABLE_HEX_COLOR_BLUE
	cable_color = CABLE_COLOR_BLUE
	inhand_icon_state = "coil_blue"

/**
 * Green cable restraints
*/
/obj/item/restraints/handcuffs/cable/green
	color = CABLE_HEX_COLOR_GREEN
	cable_color = CABLE_COLOR_GREEN
	inhand_icon_state = "coil_green"

/**
 * Pink cable restraints
*/
/obj/item/restraints/handcuffs/cable/pink
	color = CABLE_HEX_COLOR_PINK
	cable_color = CABLE_COLOR_PINK
	inhand_icon_state = "coil_pink"

/**
 * Orange (the color) cable restraints
*/
/obj/item/restraints/handcuffs/cable/orange
	color = CABLE_HEX_COLOR_ORANGE
	cable_color = CABLE_COLOR_ORANGE
	inhand_icon_state = "coil_orange"

/**
 * Cyan cable restraints
*/
/obj/item/restraints/handcuffs/cable/cyan
	color = CABLE_HEX_COLOR_CYAN
	cable_color = CABLE_COLOR_CYAN
	inhand_icon_state = "coil_cyan"

/**
 * White cable restraints
*/
/obj/item/restraints/handcuffs/cable/white
	color = CABLE_HEX_COLOR_WHITE
	cable_color = CABLE_COLOR_WHITE
	inhand_icon_state = "coil_white"

/obj/item/restraints/handcuffs/cable/attackby(obj/item/I, mob/user, params) //Slapcrafting
	if(istype(I, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = I
		if (R.use(1))
			var/obj/item/wirerod/W = new /obj/item/wirerod
			remove_item_from_storage(user)
			user.put_in_hands(W)
			to_chat(user, span_notice("You wrap [src] around the top of [I]."))
			qdel(src)
		else
			to_chat(user, span_warning("You need one rod to make a wired rod!"))
			return
	else if(istype(I, /obj/item/stack/sheet/iron))
		var/obj/item/stack/sheet/iron/M = I
		if(M.get_amount() < 6)
			to_chat(user, span_warning("You need at least six iron sheets to make good enough weights!"))
			return
		to_chat(user, span_notice("You begin to apply [I] to [src]..."))
		if(do_after(user, 35, target = src))
			if(M.get_amount() < 6 || !M)
				return
			var/obj/item/restraints/legcuffs/bola/S = new /obj/item/restraints/legcuffs/bola
			M.use(6)
			user.put_in_hands(S)
			to_chat(user, span_notice("You make some weights out of [I] and tie them to [src]."))
			remove_item_from_storage(user)
			qdel(src)
	else
		return ..()

/**
 * # Zipties
 *
 * One-use handcuffs that take 45 seconds to resist out of instead of one minute. This turns into the used version when applied.
*/
/obj/item/restraints/handcuffs/cable/zipties
	name = "zipties"
	desc = "Plastic, disposable zipties that can be used to restrain temporarily but are destroyed after use."
	icon_state = "cuff"
	inhand_icon_state = "cuff_white"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	custom_materials = null
	breakouttime = 45 SECONDS
	trashtype = /obj/item/restraints/handcuffs/cable/zipties/used
	color = null
	cable_color = null

/**
 * # Used zipties
 *
 * What zipties turn into when applied. These can't be used to cuff people.
*/
/obj/item/restraints/handcuffs/cable/zipties/used
	desc = "A pair of broken zipties."
	icon_state = "cuff_used"

/obj/item/restraints/handcuffs/cable/zipties/used/attack()
	return

/**
 * # Fake Zipties
 *
 * One-use handcuffs that is very easy to break out of, meant as a one-use alternative to regular fake handcuffs.
 */
/obj/item/restraints/handcuffs/cable/zipties/fake
	name = "fake zipties"
	desc = "Fake zipties meant for gag purposes."
	breakouttime = 1 SECONDS

/obj/item/restraints/handcuffs/cable/zipties/fake/used
	desc = "A pair of broken fake zipties."
	icon_state = "cuff_used"

/**
 * # Generic leg cuffs
 *
 * Parent class for everything that can legcuff carbons. Can't legcuff anything itself.
*/
/obj/item/restraints/legcuffs
	name = "leg cuffs"
	desc = "Use this to keep prisoners in line."
	gender = PLURAL
	icon_state = "handcuff"
	inhand_icon_state = "handcuff"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	flags_1 = CONDUCT_1
	throwforce = 0
	w_class = WEIGHT_CLASS_NORMAL
	slowdown = 7
	breakouttime = 30 SECONDS
	slot_flags = ITEM_SLOT_LEGCUFFED

/**
 * # Bear trap
 *
 * This opens, closes, and bites people's legs.
 */
/obj/item/restraints/legcuffs/beartrap
	name = "bear trap"
	throw_speed = 1
	throw_range = 1
	icon_state = "beartrap"
	desc = "A trap used to catch bears and other legged creatures."
	///If true, the trap is "open" and can trigger.
	var/armed = FALSE
	///How much damage the trap deals when triggered.
	var/trap_damage = 20

/obj/item/restraints/legcuffs/beartrap/prearmed
	armed = TRUE

/obj/item/restraints/legcuffs/beartrap/Initialize(mapload)
	. = ..()
	update_appearance()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(spring_trap),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/item/restraints/legcuffs/beartrap/update_icon_state()
	icon_state = "[initial(icon_state)][armed]"
	return ..()

/obj/item/restraints/legcuffs/beartrap/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] is sticking [user.p_their()] head in the [src.name]! It looks like [user.p_theyre()] trying to commit suicide!"))
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, TRUE, -1)
	return BRUTELOSS

/obj/item/restraints/legcuffs/beartrap/attack_self(mob/user)
	. = ..()
	if(!ishuman(user) || user.stat != CONSCIOUS || HAS_TRAIT(user, TRAIT_HANDS_BLOCKED))
		return
	armed = !armed
	update_appearance()
	to_chat(user, span_notice("[src] is now [armed ? "armed" : "disarmed"]"))

/**
 * Closes a bear trap
 *
 * Closes a bear trap.
 * Arguments:
 */
/obj/item/restraints/legcuffs/beartrap/proc/close_trap()
	armed = FALSE
	update_appearance()
	playsound(src, 'sound/effects/snap.ogg', 50, TRUE)

/obj/item/restraints/legcuffs/beartrap/proc/spring_trap(datum/source, atom/movable/target, thrown_at = FALSE)
	SIGNAL_HANDLER
	if(!armed || !isturf(loc) || !isliving(target))
		return
	var/mob/living/victim = target
	if(istype(victim.buckled, /obj/vehicle))
		var/obj/vehicle/ridden_vehicle = victim.buckled
		if(!ridden_vehicle.are_legs_exposed) //close the trap without injuring/trapping the rider if their legs are inside the vehicle at all times.
			close_trap()
			ridden_vehicle.visible_message(span_danger("[ridden_vehicle] triggers \the [src]."))
			return

	//don't close the trap if they're as small as a mouse, or not touching the ground
	if(victim.mob_size <= MOB_SIZE_TINY || (!thrown_at && victim.movement_type & (FLYING|FLOATING)))
		return

	close_trap()
	if(thrown_at)
		victim.visible_message(span_danger("\The [src] ensnares [victim]!"), \
				span_userdanger("\The [src] ensnares you!"))
	else
		victim.visible_message(span_danger("[victim] triggers \the [src]."), \
				span_userdanger("You trigger \the [src]!"))
	var/def_zone = BODY_ZONE_CHEST
	if(iscarbon(victim) && victim.body_position == STANDING_UP)
		var/mob/living/carbon/carbon_victim = victim
		def_zone = pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
		if(!carbon_victim.legcuffed && carbon_victim.num_legs >= 2) //beartrap can't cuff your leg if there's already a beartrap or legcuffs, or you don't have two legs.
			INVOKE_ASYNC(carbon_victim, TYPE_PROC_REF(/mob/living/carbon, equip_to_slot), src, ITEM_SLOT_LEGCUFFED)
			SSblackbox.record_feedback("tally", "handcuffs", 1, type)

	victim.apply_damage(trap_damage, BRUTE, def_zone)

/**
 * # Energy snare
 *
 * This closes on people's legs.
 *
 * A weaker version of the bear trap that can be resisted out of faster and disappears
 */
/obj/item/restraints/legcuffs/beartrap/energy
	name = "energy snare"
	armed = 1
	icon_state = "e_snare"
	trap_damage = 0
	breakouttime = 3 SECONDS
	item_flags = DROPDEL
	flags_1 = NONE

/obj/item/restraints/legcuffs/beartrap/energy/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(dissipate)), 100)

/**
 * Handles energy snares disappearing
 *
 * If the snare isn't closed on anyone, it will disappear in a shower of sparks.
 * Arguments:
 */
/obj/item/restraints/legcuffs/beartrap/energy/proc/dissipate()
	if(!ismob(loc))
		do_sparks(1, TRUE, src)
		qdel(src)

/obj/item/restraints/legcuffs/beartrap/energy/attack_hand(mob/user, list/modifiers)
	spring_trap(null, user)
	return ..()

/obj/item/restraints/legcuffs/beartrap/energy/cyborg
	breakouttime = 2 SECONDS // Cyborgs shouldn't have a strong restraint

/obj/item/restraints/legcuffs/bola
	name = "bola"
	desc = "A restraining device designed to be thrown at the target. Upon connecting with said target, it will wrap around their legs, making it difficult for them to move quickly."
	icon_state = "bola"
	icon_state_preview = "bola_preview"
	inhand_icon_state = "bola"
	lefthand_file = 'icons/mob/inhands/weapons/thrown_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/thrown_righthand.dmi'
	breakouttime = 3.5 SECONDS//easy to apply, easy to break out of
	gender = NEUTER
	///Amount of time to knock the target down for once it's hit in deciseconds.
	var/knockdown = 0

/obj/item/restraints/legcuffs/bola/throw_at(atom/target, range, speed, mob/thrower, spin=1, diagonals_first = 0, datum/callback/callback, gentle = FALSE, quickstart = TRUE)
	if(!..())
		return
	playsound(src.loc,'sound/weapons/bolathrow.ogg', 75, TRUE)

/obj/item/restraints/legcuffs/bola/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(..() || !iscarbon(hit_atom))//if it gets caught or the target can't be cuffed,
		return//abort
	ensnare(hit_atom)

/**
 * Attempts to legcuff someone with the bola
 *
 * Arguments:
 * * C - the carbon that we will try to ensnare
 */
/obj/item/restraints/legcuffs/bola/proc/ensnare(mob/living/carbon/C)
	if(!C.legcuffed && C.num_legs >= 2)
		visible_message(span_danger("\The [src] ensnares [C]!"), span_userdanger("\The [src] ensnares you!"))
		C.equip_to_slot(src, ITEM_SLOT_LEGCUFFED)
		SSblackbox.record_feedback("tally", "handcuffs", 1, type)
		C.Knockdown(knockdown)
		playsound(src, 'sound/effects/snap.ogg', 50, TRUE)

/**
 * A traitor variant of the bola.
 *
 * It knocks people down and is harder to remove.
 */
/obj/item/restraints/legcuffs/bola/tactical
	name = "reinforced bola"
	desc = "A strong bola, made with a long steel chain. It looks heavy, enough so that it could trip somebody."
	icon_state = "bola_r"
	inhand_icon_state = "bola_r"
	breakouttime = 7 SECONDS
	knockdown = 3.5 SECONDS

/**
 * A security variant of the bola.
 *
 * It's harder to remove, smaller and has a defined price.
 */
/obj/item/restraints/legcuffs/bola/energy
	name = "energy bola"
	desc = "A specialized hard-light bola designed to ensnare fleeing criminals and aid in arrests."
	icon_state = "ebola"
	inhand_icon_state = "ebola"
	hitsound = 'sound/weapons/taserhit.ogg'
	w_class = WEIGHT_CLASS_SMALL
	breakouttime = 6 SECONDS
	custom_price = PAYCHECK_COMMAND * 0.35

/obj/item/restraints/legcuffs/bola/energy/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_UNCATCHABLE, TRAIT_GENERIC) // People said energy bolas being uncatchable is a feature.

/obj/item/restraints/legcuffs/bola/energy/ensnare(atom/hit_atom)
	var/obj/item/restraints/legcuffs/beartrap/energy/cyborg/B = new (get_turf(hit_atom))
	B.spring_trap(null, hit_atom, TRUE)
	qdel(src)

/**
 * A pacifying variant of the bola.
 *
 * It's much harder to remove, doesn't cause a slowdown and gives people /datum/status_effect/gonbola_pacify.
 */
/obj/item/restraints/legcuffs/bola/gonbola
	name = "gonbola"
	desc = "Hey, if you have to be hugged in the legs by anything, it might as well be this little guy."
	icon_state = "gonbola"
	icon_state_preview = "gonbola_preview"
	inhand_icon_state = "bola_r"
	breakouttime = 30 SECONDS
	slowdown = 0
	var/datum/status_effect/gonbola_pacify/effectReference

/obj/item/restraints/legcuffs/bola/gonbola/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(iscarbon(hit_atom))
		var/mob/living/carbon/C = hit_atom
		effectReference = C.apply_status_effect(/datum/status_effect/gonbola_pacify)

/obj/item/restraints/legcuffs/bola/gonbola/dropped(mob/user)
	. = ..()
	if(effectReference)
		QDEL_NULL(effectReference)
