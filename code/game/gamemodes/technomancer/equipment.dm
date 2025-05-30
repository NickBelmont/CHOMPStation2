/datum/technomancer/equipment/default_core
	name = "Manipulation Core"
	desc = "The default core that you most likely already have.  This is here in-case you change your mind after buying \
	another core, don't forget to refund the old core.<br>\
	Capacity: 10k<br>\
	Recharge: 50/s<br>\
	Instability Modifier: 80%<br>\
	Energy Cost Modifier: 100%<br>\
	Spell Power: 100%"
	cost = 100
	obj_path = /obj/item/technomancer_core

/datum/technomancer/equipment/rapid_core
	name = "Rapid Core"
	desc = "A core optimized for passive regeneration, however at the cost of capacity.  Has a capacity of 7,000 units of energy, and \
	recharges at a rate of 70 units.  Complex gravatics and force manipulation allows the wearer to also run slightly faster.<br>\
	" + span_red("Capacity: 7k") + "<br>\
	" + span_green(span_bold("Recharge: 70/s")) + "<br>\
	" + span_red("Instability Modifier: 90%") + "<br>\
	Energy Cost Modifier: 100%<br>\
	Spell Power: 100%"
	cost = 100
	obj_path = /obj/item/technomancer_core/rapid

/datum/technomancer/equipment/bulky_core
	name = "Bulky Core"
	desc = "This core has very large capacitors, however it also has a subpar fractal reactor.  The user is recommended to \
	purchase one or more energy-generating Functions as well if using this core.  The intense weight of the core unfortunately can \
	cause the wear to move slightly slower, and the closeness of the capacitors causes a slight increase in incoming instability.<br>\
	" + span_green(span_bold("Capacity: 20k")) + "<br>\
	" + span_red("Recharge: 25/s") + "<br>\
	" + span_red("Instability Modifier: 100%") + "<br>\
	Energy Cost Modifier: 100%<br>\
	" + span_green("Spell Power: 140%") + ""
	cost = 100
	obj_path = /obj/item/technomancer_core/bulky

/datum/technomancer/equipment/unstable
	name = "Unstable Core"
	desc = "This core feeds off unstable energies around the user in addition to a fractal reactor.  This means that it performs \
	better as the user has more instability, which could prove dangerous to the inexperienced or unprepared.  The rate of recharging \
	increases as the user accumulates more instability, eventually exceeding even the rapid core in regen speed, at a huge risk.<br>\
	" + span_green("Capacity: 13k") + "<br>\
	" + span_green("Recharge: 35/s to 110/s+") + "<br>\
	" + span_red(span_bold("Instability Modifier: 130%")) + "<br>\
	" + span_green("Energy Cost Modifier: 70%") + "<br>\
	" + span_green("Spell Power: 110%") + ""
	cost = 100
	obj_path = /obj/item/technomancer_core/unstable

/datum/technomancer/equipment/recycling
	name = "Recycling Core"
	desc = "This core is optimized for energy efficency, being able to sometimes recover energy that would have been lost with other \
	cores.  Each time energy is spent, there is a 30% chance of recovering half of what was spent.<br>\
	" + span_green("Capacity: 12k") + "<br>\
	" + span_red("Recharge: 40/s") + "<br>\
	" + span_green("Instability Modifier: 60%") + "<br>\
	" + span_green("Energy Cost Modifier: 80%") + "<br>\
	Spell Power: 100%"
	cost = 100
	obj_path = /obj/item/technomancer_core/recycling

/datum/technomancer/equipment/summoning
	name = "Summoning Core"
	desc = "A unique type of core, this one sacrifices other characteristics in order to optimize it for the purposes teleporting \
	entities from vast distances, and keeping them there.  Wearers of this core can maintain up to 40 summons at once, and the energy \
	demand for maintaining summons is severely reduced.<br>\
	" + span_red("Capacity: 8k") + "<br>\
	" + span_red("Recharge: 35/s") + "<br>\
	" + span_red("Instability Modifier: 120%") + "<br>\
	Energy Cost Modifier: 100%<br>\
	" + span_green("Spell Power: 120%") + ""
	cost = 100
	obj_path = /obj/item/technomancer_core/summoner

/datum/technomancer/equipment/safety
	name = "Safety Core"
	desc = "This core is designed so that the wearer suffers almost no instability.  It unfortunately comes at a cost of subpar \
	ratings for everything else.<br>\
	" + span_red("Capacity: 7k") + "<br>\
	" + span_red("Recharge: 30/s") + "<br>\
	" + span_green(span_bold("Instability Modifier: 30%")) + "<br>\
	Energy Cost Modifier: 100%<br>\
	" + span_red(span_bold("Spell Power: 70%")) + ""
	cost = 100
	obj_path = /obj/item/technomancer_core/safety

/datum/technomancer/equipment/overcharged
	name = "Overcharged Core"
	desc = "A core that was created in order to get the most power out of functions.  It does this by shoving the most power into \
	those functions, so it is the opposite of energy efficent, however the enhancement of functions is second to none for other \
	cores.<br>\
	" + span_red("Capacity: 15k (effectively 7.5k)") + "<br>\
	" + span_red("Recharge: 40/s") + "<br>\
	" + span_red("Instability Modifier: 110%") + "<br>\
	" + span_red(span_bold("Energy Cost Modifier: 200%")) + "<br>\
	" + span_green(span_bold("Spell Power: 175%")) + ""
	cost = 100
	obj_path = /obj/item/technomancer_core/overcharged

/datum/technomancer/equipment/hypo_belt
	name = "Hypo Belt"
	desc = "A medical belt designed to carry autoinjectors and other medical equipment.  Comes with one of each hypo."
	cost = 50
	obj_path = /obj/item/storage/belt/medical/technomancer

/obj/item/storage/belt/medical/technomancer
	name = "hypo belt"
	desc = "A medical belt designed to carry autoinjectors and other medical equipment."

/obj/item/storage/belt/medical/technomancer/Initialize(mapload)
	new /obj/item/reagent_containers/hypospray/autoinjector/biginjector/brute(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/biginjector/burn(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/biginjector/toxin(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/biginjector/oxy(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/biginjector/purity(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/biginjector/pain(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/biginjector/organ(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/biginjector/combat(src)
	. = ..()

/datum/technomancer/equipment/belt_of_holding
	name = "Belt of Holding"
	desc = "A belt with a literal pocket which opens to a localized pocket of 'Blue-Space', allowing for more storage.  \
	The nature of the pocket allows for storage of larger objects than what is typical for other belts, and in larger quanities.  \
	It will also help keep your pants on."
	cost = 50
	obj_path = /obj/item/storage/belt/holding

/obj/item/storage/belt/holding
	name = "Belt of Holding"
	desc = "Can hold more than you'd expect."
	icon_state = "ems"
	max_w_class = ITEMSIZE_NORMAL // Can hold normal sized items.
	storage_slots = 14	// Twice the capacity of a typical belt.
	max_storage_space = ITEMSIZE_COST_NORMAL * 14

/datum/technomancer/equipment/thermals
	name = "Thermoncle"
	desc = "A fancy monocle with a thermal optics lens installed.  Allows you to see people across walls."
	cost = 150
	obj_path = /obj/item/clothing/glasses/thermal/plain/monocle

/datum/technomancer/equipment/night_vision
	name = "Night Vision Goggles"
	desc = "Strategical goggles which will allow the wearer to see in the dark.  Perfect for the sneaky type, just get rid of the \
	lights first."
	cost = 50
	obj_path = /obj/item/clothing/glasses/night

/datum/technomancer/equipment/omni_sight
	name = "Omnisight Scanner"
	desc = "A very rare scanner worn on the face, which allows the wearer to see nearly anything across walls."
	cost = 300
	obj_path = /obj/item/clothing/glasses/omni

/obj/item/clothing/glasses/omni
	name = "Omnisight Scanner"
	desc = "A pair of goggles which, while on the surface appear to be build very poorly, reveal to be very advanced in \
	capabilities.  The lens appear to be multiple optical matrices layered together, allowing the wearer to see almost anything \
	across physical barriers."
	icon_state = "uzenwa_sissra_1"
	actions_types = list(/datum/action/item_action/toggle_goggles)
	origin_tech = list(TECH_MAGNET = 6, TECH_ENGINEERING = 6)
	toggleable = 1
	vision_flags = SEE_TURFS|SEE_MOBS|SEE_OBJS
	prescription = 1 // So two versions of these aren't needed.

/datum/technomancer/equipment/med_hud
	name = "Medical HUD"
	desc = "A commonly available HUD for medical professionals, which displays how healthy an individual is.  \
	Recommended for support-based apprentices!"
	cost = 25
	obj_path = /obj/item/clothing/glasses/thermal/plain/monocle

/datum/technomancer/equipment/scepter
	name = "Scepter of Empowerment"
	desc = "A gem sometimes found in the depths of asteroids makes up the basis for this device.  Energy is channeled into it from \
	the Core and the user, causing many functions to be enhanced in various ways, so long as it is held in the off-hand.  \
	Be careful not to lose this!"
	cost = 200
	obj_path = /obj/item/scepter

/obj/item/scepter
	name = "scepter of empowerment"
	desc = "It's a purple gem, attached to a rod and a handle, along with small wires.  It looks like it would make a good club."
	icon = 'icons/obj/technomancer.dmi'
	icon_state = "scepter"
	force = 15
	slot_flags = SLOT_BELT
	attack_verb = list("beaten", "smashed", "struck", "whacked")

/obj/item/scepter/attack_self(mob/living/carbon/human/user)
	var/obj/item/item_to_test = user.get_other_hand(src)
	if(istype(item_to_test, /obj/item/spell))
		var/obj/item/spell/S = item_to_test
		S.on_scepter_use_cast(user)

/obj/item/scepter/afterattack(atom/target, mob/living/carbon/human/user, proximity_flag, click_parameters)
	if(proximity_flag)
		return ..()
	var/obj/item/item_to_test = user.get_other_hand(src)
	if(istype(item_to_test, /obj/item/spell))
		var/obj/item/spell/S = item_to_test
		S.on_scepter_ranged_cast(target, user)

/datum/technomancer/equipment/spyglass
	name = "Spyglass"
	desc = "A mundane spyglass, it may prove useful to those who wish to scout ahead, or fight from an extreme range."
	cost = 100
	obj_path = /obj/item/binoculars/spyglass

/obj/item/binoculars/spyglass
	name = "spyglass"
	desc = "It's a hand-held telescope, useful for star-gazing, peeping, and recon."
	icon_state = "spyglass"
	slot_flags = SLOT_BELT
