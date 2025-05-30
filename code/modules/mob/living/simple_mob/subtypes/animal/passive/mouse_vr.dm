/mob/living/simple_mob/animal/passive/mouse
	nutrition = 20	//To prevent draining maint mice for infinite food. Low nutrition has no mechanical effect on simplemobs, so wont hurt mice themselves.
	vore_taste = "cheese"

	restrict_vore_ventcrawl = TRUE

	can_pull_size = ITEMSIZE_TINY // Rykka - Uncommented these. Not sure why they were commented out in the original Polaris files, maybe a mob rework mistake?
	can_pull_mobs = MOB_PULL_NONE // Rykka - Uncommented these. Not sure why they were commented out in the original Polaris files, maybe a mob rework mistake?

	desc = "A small rodent, often seen hiding in maintenance areas and making a nuisance of itself. And stealing cheese, or annoying the chef. SQUEAK! <3"

	movement_cooldown = 5
	universal_understand = 1

/obj/item/holder/mouse/attack_self(var/mob/U)
	for(var/mob/living/simple_mob/M in contents)
		if((I_HELP) && U.checkClickCooldown()) //a little snowflakey, but makes it use the same cooldown as interacting with non-inventory objects
			U.setClickCooldown(U.get_attack_speed()) //if there's a cleaner way in baycode, I'll change this
			U.visible_message(span_notice("[U] [M.response_help] \the [M]."))

//Jank grabber that uses the 'attack_hand' insead of 'MouseDrop'
/mob/living/simple_mob/animal/passive/mouse/attack_hand(mob/user)
	var/mob/living/carbon/human/H = user
	if(holder_type && issmall(src) && istype(H) && !H.lying && Adjacent(H) && (a_intent == I_HELP && H.a_intent == I_HELP))
		if(!issmall(H) || !ishuman(src))
			get_scooped(H, (H == src))
		return
	return ..()

/mob/living/proc/mouse_scooped(var/mob/living/carbon/grabber, var/self_grab)

	if(!holder_type || buckled || pinned.len)
		return

	if(self_grab)
		if(incapacitated()) return
	else
		if(grabber.incapacitated()) return

	var/obj/item/holder/H = new holder_type(get_turf(src), src)
	grabber.put_in_hands(H)

	if(self_grab)
		to_chat(grabber, span_notice("\The [src] clambers onto you!"))
		to_chat(src, span_notice("You climb up onto \the [grabber]!"))
		grabber.equip_to_slot_if_possible(H, slot_back, 0, 1)
	else
		to_chat(grabber, span_notice("You scoop up \the [src]!"))
		to_chat(src, span_notice("\The [grabber] scoops you up!"))

	add_attack_logs(grabber, H.held_mob, "Scooped up", FALSE) // Not important enough to notify admins, but still helpful.
	return H

/mob/living/simple_mob/animal/passive/mouse/white/apple
	name = "Apple"
	desc = "Dainty, well groomed and cared for, her eyes glitter with untold knowledge..."
	gender = FEMALE

/mob/living/simple_mob/animal/passive/mouse/white/apple/Initialize(mapload, keep_parent_data)
	. = ..(mapload, TRUE)


/obj/item/holder/mouse/attack_self(mob/living/carbon/user)
	user.setClickCooldown(user.get_attack_speed())
	for(var/L in contents)
		if(isanimal(L))
			var/mob/living/simple_mob/S = L
			user.visible_message(span_notice("[user] [S.response_help] \the [S]."))
