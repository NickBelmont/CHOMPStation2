#define TECHNOMANCER_INSTABILITY_DECAY				0.97	// Multipler for how much instability is lost per Life() tick.
// Numbers closer to 1.0 make instability decay slower.  Instability will never decay if it's at 1.0.
// When set to 0.98, it has a half life of roughly 35 Life() ticks, or 1.1 minutes.
// For 0.97, it has a half life of about 23 ticks, or 46 seconds.
// For 0.96, it is 17 ticks, or 34 seconds.
// 0.95 is 14 ticks.
#define TECHNOMANCER_INSTABILITY_MIN_DECAY			0.1 	// Minimum removed every Life() tick, always.
#define TECHNOMANCER_INSTABILITY_PRECISION			0.1 	// Instability is rounded to this.


/mob/living
	var/instability = 0
	var/last_instability = 0 // Used to calculate instability delta.
	var/last_instability_event = null // most recent world.time that something bad happened due to instability.

// Proc: adjust_instability()
// Parameters: 0
// Description: Does nothing, because inheritence.
/mob/living/proc/adjust_instability(var/amount)
	instability = between(0, round(instability + amount, TECHNOMANCER_INSTABILITY_PRECISION), 200)

// Proc: adjust_instability()
// Parameters: 1 (amount - how much instability to give)
// Description: Adds or subtracks instability to the mob, then updates the hud.
/mob/living/carbon/human/adjust_instability(var/amount)
	..()
	instability_update_hud()

// Proc: instability_update_hud()
// Parameters: 0
// Description: Sets the HUD icon to the correct state.
/mob/living/carbon/human/proc/instability_update_hud()
	if(client && hud_used)
		switch(instability)
			if(0 to 10)
				wiz_instability_display.icon_state = "instability-1"
			if(10 to 30)
				wiz_instability_display.icon_state = "instability0"
			if(30 to 50)
				wiz_instability_display.icon_state = "instability1"
			if(50 to 100)
				wiz_instability_display.icon_state = "instability2"
			if(100 to 200)
				wiz_instability_display.icon_state = "instability3"

// Proc: Life()
// Parameters: 0
// Description: Makes instability tick along with Life().
/mob/living/Life()
	. = ..()
	handle_instability()

// Proc: handle_instability()
// Parameters: 0
// Description: Makes instability decay.  instability_effects() handles the bad effects for having instability.  It will also hold back
// from causing bad effects more than one every ten seconds, to prevent sudden death from angry RNG.
/mob/living/proc/handle_instability()
	instability = between(0, round(instability, TECHNOMANCER_INSTABILITY_PRECISION), 200)
	last_instability = instability

	//This should cushon against really bad luck.
	if(instability && last_instability_event < (world.time - 5 SECONDS) && prob(50))
		instability_effects()

	var/instability_decayed = abs( round(instability * TECHNOMANCER_INSTABILITY_DECAY, TECHNOMANCER_INSTABILITY_PRECISION) - instability )
	instability_decayed = max(instability_decayed, TECHNOMANCER_INSTABILITY_MIN_DECAY)

	adjust_instability(-instability_decayed)
	radiate_instability(instability_decayed)

/mob/living/carbon/human/handle_instability()
	..()
	instability_update_hud()

/*
[16:18:08] <PsiOmegaDelta> Sparks
[16:18:10] <PsiOmegaDelta> Wormholes
[16:18:16] <PsiOmegaDelta> Random spells firing off on their own
[16:18:22] <PsiOmegaDelta> The possibilities are endless
[16:19:00] <PsiOmegaDelta> Random objects phasing into reality, only to disappear again
[16:19:05] <PsiOmegaDelta> Things briefly duplicating
[16:20:56] <PsiOmegaDelta> Glass cracking, eventually breaking
*/
// Proc: instability_effects()
// Parameters: 0
// Description: Does a variety of bad effects to the entity holding onto the instability, with more severe effects occuring if they have
// a lot of instability.
/mob/living/proc/instability_effects()
	last_instability_event = world.time
	spawn(1)
		var/image/instability_flash = image('icons/obj/spells.dmi',"instability")
		add_overlay(instability_flash)
		sleep(4)
		cut_overlay(instability_flash)
		qdel(instability_flash)

/mob/living/silicon/instability_effects()
	if(instability)
		var/rng = 0
		..()
		switch(instability)
			if(1 to 10) //Harmless
				return
			if(11 to 30) //Minor
				rng = rand(0,1)
				switch(rng)
					if(0)
						var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
						sparks.set_up(5, 0, src)
						sparks.attach(loc)
						sparks.start()
						visible_message(span_warning("Electrical sparks manifest from nowhere around \the [src]!"))
						qdel(sparks)
					if(1)
						return

			if(31 to 50) //Moderate
				rng = rand(0,4)
				switch(rng)
					if(0)
						electrocute_act(instability * 0.3, "unstable energies", 0.75)
					if(1)
						adjustFireLoss(instability * 0.15) //7.5 burn @ 50 instability
						to_chat(src, span_danger("Your chassis alerts you to overheating from an unknown external force!"))
					if(2)
						adjustBruteLoss(instability * 0.15) //7.5 brute @ 50 instability
						to_chat(src, span_danger("Your chassis makes the sound of metal groaning!"))
					if(3)
						safe_blink(src, range = 6)
						to_chat(src, span_warning("You're teleported against your will!"))
					if(4)
						emp_act(3)

			if(51 to 100) //Severe
				rng = rand(0,3)
				switch(rng)
					if(0)
						electrocute_act(instability * 0.5, "extremely unstable energies", 0.75)
					if(1)
						emp_act(2)
					if(2)
						adjustFireLoss(instability * 0.3) //30 burn @ 100 instability
						to_chat(src, span_danger("Your chassis alerts you to extreme overheating from an unknown external force!"))
					if(3)
						adjustBruteLoss(instability * 0.3) //30 brute @ 100 instability
						to_chat(src, span_danger("Your chassis makes the sound of metal groaning and tearing!"))

			if(101 to 200) //Lethal
				rng = rand(0,4)
				switch(rng)
					if(0)
						electrocute_act(instability, "extremely unstable energies", 0.75)
					if(1)
						emp_act(1)
					if(2)
						adjustFireLoss(instability * 0.4) //40 burn @ 100 instability
						to_chat(src, span_danger("Your chassis alerts you to extreme overheating from an unknown external force!"))
					if(3)
						adjustBruteLoss(instability * 0.4) //40 brute @ 100 instability
						to_chat(src, span_danger("Your chassis makes the sound of metal groaning and tearing!"))

/mob/living/carbon/human/instability_effects()
	if(instability)
		var/rng = 0
		..()
		switch(instability)
			if(1 to 10) //Harmless
				return
			if(10 to 30) //Minor
				rng = rand(0,1)
				switch(rng)
					if(0)
						var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
						sparks.set_up(5, 0, src)
						sparks.attach(loc)
						sparks.start()
						visible_message(span_warning("Electrical sparks manifest from nowhere around \the [src]!"))
						qdel(sparks)
					if(1)
						return

			if(30 to 50) //Moderate
				rng = rand(0,8)
				switch(rng)
					if(0)
						apply_effect(instability * 0.3, IRRADIATE)
					if(1)
						return
					if(2)
						if(can_feel_pain())
							apply_effect(instability * 0.3, AGONY)
							to_chat(src, span_danger("You feel a sharp pain!"))
					if(3)
						apply_effect(instability * 0.3, EYE_BLUR)
						to_chat(src, span_danger("Your eyes start to get cloudy!"))
					if(4)
						electrocute_act(instability * 0.3, "unstable energies")
					if(5)
						adjustFireLoss(instability * 0.15) //7.5 burn @ 50 instability
						to_chat(src, span_danger("You feel your skin burn!"))
					if(6)
						adjustBruteLoss(instability * 0.15) //7.5 brute @ 50 instability
						to_chat(src, span_danger("You feel a sharp pain as an unseen force harms your body!"))
					if(7)
						adjustToxLoss(instability * 0.15) //7.5 tox @ 50 instability
					if(8)
						safe_blink(src, range = 6)
						to_chat(src, span_warning("You're teleported against your will!"))

			if(50 to 100) //Severe
				rng = rand(0,8)
				switch(rng)
					if(0)
						apply_effect(instability * 0.7, IRRADIATE)
					if(1)
						return
					if(2)
						if(can_feel_pain())
							apply_effect(instability * 0.7, AGONY)
							to_chat(src, span_danger("You feel an extremly angonizing pain from all over your body!"))
					if(3)
						apply_effect(instability * 0.5, EYE_BLUR)
						to_chat(src, span_danger("Your eyes start to get cloudy!"))
					if(4)
						electrocute_act(instability * 0.5, "extremely unstable energies")
					if(5)
						fire_act()
						to_chat(src, span_danger("You spontaneously combust!"))
					if(6)
						adjustCloneLoss(instability * 0.05) //5 cloneloss @ 100 instability
						to_chat(src, span_danger("You feel your body slowly degenerate."))
					if(7)
						adjustToxLoss(instability * 0.25) //25 tox @ 100 instability

			if(100 to 200) //Lethal
				rng = rand(0,8)
				switch(rng)
					if(0)
						apply_effect(instability, IRRADIATE)
					if(1)
						visible_message(span_warning("\The [src] suddenly collapses!"),
						span_danger("You suddenly feel very light-headed, and faint!"))
						Paralyse(instability * 0.1)
					if(2)
						if(can_feel_pain())
							apply_effect(instability, AGONY)
							to_chat(src, span_danger("You feel an extremly angonizing pain from all over your body!"))
					if(3)
						apply_effect(instability, EYE_BLUR)
						to_chat(src, span_danger("Your eyes start to get cloudy!"))
					if(4)
						electrocute_act(instability, "extremely unstable energies")
					if(5)
						fire_act()
						to_chat(src, span_danger("You spontaneously combust!"))
					if(6)
						adjustCloneLoss(instability * 0.10) //5 cloneloss @ 100 instability
						to_chat(src, span_danger("You feel your body slowly degenerate."))
					if(7)
						adjustToxLoss(instability * 0.40) //40 tox @ 100 instability

/mob/living/proc/radiate_instability(amount)
	var/distance = round(sqrt(instability / 2))
	if(instability < TECHNOMANCER_INSTABILITY_MIN_GLOW)
		distance = 0
	if(distance)
		for(var/mob/living/L in range(src, distance) )
			if(L == src) // This instability is radiating away from them, so don't include them.
				continue
			var/radius = max(get_dist(L, src), 1)
			// People next to the source take all of the radiated amount.  Further distance decreases the amount absorbed.
			var/outgoing_instability = (amount) * ( 1 / (radius**2) )

			L.receive_radiated_instability(outgoing_instability)
			src.adjust_instability(-outgoing_instability) //This should prevent feedback loops

// This should only be used for EXTERNAL sources of instability, such as from someone or something glowing.
/mob/living/proc/receive_radiated_instability(amount)
	// Energy armor like from the AMI RIG can protect from this.
	var/armor = getarmor(null, "energy")
	var/armor_factor = abs( (armor - 100) / 100)
	amount = amount * armor_factor
	if(amount && prob(10))
		if(isSynthetic())
			to_chat(src, span_cult(span_huge("Warning: Anomalous field detected.")))
		else
			to_chat(src, span_cult(span_huge("The purple glow makes you feel strange...")))
	adjust_instability(amount)

#undef TECHNOMANCER_INSTABILITY_DECAY
#undef TECHNOMANCER_INSTABILITY_MIN_DECAY
#undef TECHNOMANCER_INSTABILITY_PRECISION
