
/* monkestation removal: reimplemented in [monkestation\code\modules\mob\living\basic\space_fauna\revenant\revenant_effects.dm]
/datum/disease/revblight
	name = "Unnatural Wasting"
	max_stages = 5
	stage_prob = 5
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	cure_text = "Holy water or extensive rest."
	spread_text = "A burst of unholy energy"
	cures = list(/datum/reagent/water/holywater)
	cure_chance = 30 //higher chance to cure, because revenants are assholes
	agent = "Unholy Forces"
	viable_mobtypes = list(/mob/living/carbon/human)
	disease_flags = CURABLE
	spreading_modifier = 1
	severity = DISEASE_SEVERITY_HARMFUL
	var/stagedamage = 0 //Highest stage reached.
	var/finalstage = 0 //Because we're spawning off the cure in the final stage, we need to check if we've done the final stage's effects.

/datum/disease/revblight/cure(add_resistance = TRUE, mob/living/carbon/target)
	if(affected_mob)
		affected_mob.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, "#1d2953")
		if(ishuman(affected_mob))
			var/mob/living/carbon/human/human = affected_mob
			if(human.dna && human.dna.species)
				human.dna.species.handle_mutant_bodyparts(human)
				human.set_haircolor(null, override = TRUE)
			to_chat(affected_mob, span_notice("You feel better."))
	..()


/datum/disease/revblight/stage_act(seconds_per_tick, times_fired)
	. = ..()
	if(!.)
		return

	if(!finalstage)
		if(affected_mob.body_position == LYING_DOWN && SPT_PROB(3 * stage, seconds_per_tick))
			cure()
			return FALSE
		if(SPT_PROB(1.5 * stage, seconds_per_tick))
			to_chat(affected_mob, span_revennotice("You suddenly feel [pick("sick and tired", "disoriented", "tired and confused", "nauseated", "faint", "dizzy")]..."))
			affected_mob.adjust_confusion(8 SECONDS)
			affected_mob.stamina.adjust(-20, FALSE)
			new /obj/effect/temp_visual/revenant(affected_mob.loc)
		if(stagedamage < stage)
			stagedamage++
			affected_mob.adjustToxLoss(1 * stage * seconds_per_tick, FALSE) //should, normally, do about 30 toxin damage.
			new /obj/effect/temp_visual/revenant(affected_mob.loc)
		if(SPT_PROB(25, seconds_per_tick))
			affected_mob.stamina.adjust(-stage, FALSE)

	switch(stage)
		if(2)
			if(SPT_PROB(2.5, seconds_per_tick))
				affected_mob.emote("pale")
		if(3)
			if(SPT_PROB(5, seconds_per_tick))
				affected_mob.emote(pick("pale","shiver"))
		if(4)
			if(SPT_PROB(7.5, seconds_per_tick))
				affected_mob.emote(pick("pale","shiver","cries"))
		if(5)
			if(!finalstage)
				finalstage = TRUE
				to_chat(affected_mob, span_revenbignotice("You feel like [pick("nothing's worth it anymore", "nobody ever needed your help", "nothing you did mattered", "everything you tried to do was worthless")]."))
				affected_mob.stamina.adjust(-22.5 * seconds_per_tick, FALSE)
				new /obj/effect/temp_visual/revenant(affected_mob.loc)
				if(ishuman(affected_mob))
					var/mob/living/carbon/human/human = affected_mob
					if(human.dna && human.dna.species)
						human.dna.species.handle_mutant_bodyparts(human,"#1d2953")
						affected_mob.set_haircolor("#1d2953", override = TRUE)
				affected_mob.visible_message(span_warning("[affected_mob] looks terrifyingly gaunt..."), span_revennotice("You suddenly feel like your skin is <i>wrong</i>..."))
				affected_mob.add_atom_colour("#1d2953", TEMPORARY_COLOUR_PRIORITY)
				addtimer(CALLBACK(src, PROC_REF(cure)), 10 SECONDS)
*/
