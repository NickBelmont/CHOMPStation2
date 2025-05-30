/obj/item/inflatable
	name = "inflatable wall"
	desc = "A folded membrane which rapidly expands into a large cubical shape on activation."
	icon = 'icons/obj/inflatable.dmi'
	icon_state = "folded_wall"
	drop_sound = 'sound/items/drop/rubber.ogg'
	w_class = ITEMSIZE_NORMAL
	var/deploy_path = /obj/structure/inflatable

/obj/item/inflatable/attack_self(mob/user)
	inflate(user,user.loc)

/obj/item/inflatable/afterattack(var/atom/A, var/mob/user)
	..(A, user)
	if(!user)
		return
	if(!user.Adjacent(A))
		to_chat(user, "You can't reach!")
		return
	if(istype(A, /turf))
		inflate(user,A)

/obj/structure/inflatable
	name = "inflatable wall"
	desc = "An inflated membrane. Do not puncture."
	density = TRUE
	anchored = TRUE
	opacity = 0
	can_atmos_pass = ATMOS_PASS_DENSITY

	icon = 'icons/obj/inflatable.dmi'
	icon_state = "wall"

	var/health = 50.0


/obj/structure/inflatable/Initialize(mapload)
	. = ..()
	update_nearby_tiles(need_rebuild=1)

/obj/structure/inflatable/Destroy()
	update_nearby_tiles()
	return ..()

/obj/structure/inflatable/bullet_act(var/obj/item/projectile/Proj)
	var/proj_damage = Proj.get_structure_damage()
	if(!proj_damage) return

	health -= proj_damage
	..()
	if(health <= 0)
		puncture()
	return

/obj/structure/inflatable/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			puncture()
			return
		if(3.0)
			if(prob(50))
				puncture()
				return

/obj/structure/inflatable/blob_act()
	puncture()

/obj/structure/inflatable/attack_hand(mob/user as mob)
		add_fingerprint(user)
		return

/obj/structure/inflatable/attackby(obj/item/W as obj, mob/user as mob)
	if(!istype(W)) return

	if (can_puncture(W))
		visible_message(span_danger("[user] pierces [src] with [W]!"))
		puncture()
	if(W.damtype == BRUTE || W.damtype == BURN)
		hit(W.force)
		..()
	return

/obj/structure/inflatable/proc/hit(var/damage, var/sound_effect = 1)
	health = max(0, health - damage)
	if(sound_effect)
		playsound(src, 'sound/effects/Glasshit.ogg', 75, 1)
	if(health <= 0)
		puncture()

/obj/structure/inflatable/CtrlClick()
	hand_deflate()

/obj/item/inflatable/proc/inflate(var/mob/user,var/location)
	playsound(location, 'sound/items/zip.ogg', 75, 1)
	to_chat(user, span_notice("You inflate [src]."))
	var/obj/structure/inflatable/R = new deploy_path(location)
	src.transfer_fingerprints_to(R)
	R.add_fingerprint(user)
	qdel(src)

/obj/structure/inflatable/proc/deflate()
	playsound(src, 'sound/machines/hiss.ogg', 75, 1)
	//to_chat(user, span_notice("You slowly deflate the inflatable wall."))
	visible_message("[src] slowly deflates.")
	spawn(50)
		var/obj/item/inflatable/R = new /obj/item/inflatable(loc)
		src.transfer_fingerprints_to(R)
		qdel(src)

/obj/structure/inflatable/proc/puncture()
	playsound(src, 'sound/machines/hiss.ogg', 75, 1)
	visible_message("[src] rapidly deflates!")
	var/obj/item/inflatable/torn/R = new /obj/item/inflatable/torn(loc)
	src.transfer_fingerprints_to(R)
	qdel(src)

/obj/structure/inflatable/verb/hand_deflate()
	set name = "Deflate"
	set category = "Object"
	set src in oview(1)

	if(isobserver(usr) || usr.restrained() || !usr.Adjacent(src))
		return

	verbs -= /obj/structure/inflatable/verb/hand_deflate
	deflate()

/obj/structure/inflatable/attack_generic(var/mob/user, var/damage, var/attack_verb)
	health -= damage
	user.do_attack_animation(src)
	if(health <= 0)
		user.visible_message(span_danger("[user] [attack_verb] open the [src]!"))
		spawn(1) puncture()
	else
		user.visible_message(span_danger("[user] [attack_verb] at [src]!"))
	return 1

/obj/structure/inflatable/take_damage(var/damage)
	health -= damage
	if(health <= 0)
		visible_message(span_danger("The [src] deflates!"))
		spawn(1) puncture()
	return 1

/obj/item/inflatable/door/
	name = "inflatable door"
	desc = "A folded membrane which rapidly expands into a simple door on activation."
	icon = 'icons/obj/inflatable.dmi'
	icon_state = "folded_door"
	deploy_path = /obj/structure/inflatable/door

/obj/structure/inflatable/door //Based on mineral door code
	name = "inflatable door"
	density = TRUE
	anchored = TRUE
	opacity = 0

	icon = 'icons/obj/inflatable.dmi'
	icon_state = "door_closed"

	var/state = 0 //closed, 1 == open
	var/isSwitchingStates = 0

/obj/structure/inflatable/door/attack_ai(mob/user as mob) //those aren't machinery, they're just big fucking slabs of a mineral
	if(isAI(user)) //so the AI can't open it
		return
	else if(isrobot(user)) //but cyborgs can
		if(get_dist(user,src) <= 1) //not remotely though
			return TryToSwitchState(user)

/obj/structure/inflatable/door/attack_hand(mob/user as mob)
	return TryToSwitchState(user)

/obj/structure/inflatable/door/CanPass(atom/movable/mover, turf/target)
	if(istype(mover, /obj/effect/beam))
		return !opacity
	return !density

/obj/structure/inflatable/door/proc/TryToSwitchState(atom/user)
	if(isSwitchingStates) return
	if(ismob(user))
		var/mob/M = user
		if(M.client)
			if(iscarbon(M))
				var/mob/living/carbon/C = M
				if(!C.handcuffed)
					SwitchState()
			else
				SwitchState()
	else if(istype(user, /obj/mecha))
		SwitchState()

/obj/structure/inflatable/door/proc/SwitchState()
	if(state)
		Close()
	else
		Open()
	update_nearby_tiles()

/obj/structure/inflatable/door/proc/Open()
	isSwitchingStates = 1
	flick("door_opening",src)
	sleep(10)
	density = FALSE
	opacity = 0
	state = 1
	update_icon()
	isSwitchingStates = 0

/obj/structure/inflatable/door/proc/Close()
	isSwitchingStates = 1
	flick("door_closing",src)
	sleep(10)
	density = TRUE
	opacity = 0
	state = 0
	update_icon()
	isSwitchingStates = 0

/obj/structure/inflatable/door/update_icon()
	if(state)
		icon_state = "door_open"
	else
		icon_state = "door_closed"

/obj/structure/inflatable/door/deflate()
	playsound(src, 'sound/machines/hiss.ogg', 75, 1)
	visible_message("[src] slowly deflates.")
	spawn(50)
		var/obj/item/inflatable/door/R = new /obj/item/inflatable/door(loc)
		src.transfer_fingerprints_to(R)
		qdel(src)

/obj/structure/inflatable/door/puncture()
	playsound(src, 'sound/machines/hiss.ogg', 75, 1)
	visible_message("[src] rapidly deflates!")
	var/obj/item/inflatable/door/torn/R = new /obj/item/inflatable/door/torn(loc)
	src.transfer_fingerprints_to(R)
	qdel(src)

/obj/item/inflatable/torn
	name = "torn inflatable wall"
	desc = "A folded membrane which rapidly expands into a large cubical shape on activation. It is too torn to be usable."
	icon = 'icons/obj/inflatable.dmi'
	icon_state = "folded_wall_torn"

/obj/item/inflatable/torn/attack_self(mob/user)
	to_chat(user, span_notice("The inflatable wall is too torn to be inflated!"))
	add_fingerprint(user)

/obj/item/inflatable/door/torn
	name = "torn inflatable door"
	desc = "A folded membrane which rapidly expands into a simple door on activation. It is too torn to be usable."
	icon = 'icons/obj/inflatable.dmi'
	icon_state = "folded_door_torn"

/obj/item/inflatable/door/torn/attack_self(mob/user)
	to_chat(user, span_notice("The inflatable door is too torn to be inflated!"))
	add_fingerprint(user)

/obj/item/storage/briefcase/inflatable
	name = "inflatable barrier box"
	desc = "Contains inflatable walls and doors."
	icon_state = "inf_box"
	w_class = ITEMSIZE_NORMAL
	max_storage_space = ITEMSIZE_COST_NORMAL * 7
	can_hold = list(/obj/item/inflatable)
	starts_with = list(/obj/item/inflatable/door = 3, /obj/item/inflatable = 4)
