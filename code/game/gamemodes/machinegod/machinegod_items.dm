/obj/item/clothing/glasses/wraithspecs
	name = "antique spectacles"
	desc = "Bizarre spectacles with yellow lenses. They radiate a discomforting energy."
	icon_state = "wraith_specs"
	item_state = "wraith_specs"
	vision_flags = SEE_MOBS | SEE_TURFS | SEE_OBJS
	invisa_view = 2
	darkness_view = 3

/obj/item/clothing/glasses/wraithspecs/OnMobLife(var/mob/living/carbon/human/wearer)
	var/datum/organ/internal/eyes/E = wearer.internal_organs["eyes"]
	if(E && wearer.glasses == src)
		E.damage += 0.75
		if(E.damage >= E.min_broken_damage && !(wearer.sdisabilities & BLIND))
			wearer << "<span class='danger'>You go blind!</span>"
			wearer.sdisabilities |= BLIND
		else if (E.damage >= E.min_bruised_damage && !(wearer.disabilities & NEARSIGHTED))
			wearer << "<span class='danger'>You're going blind!</span>"
			wearer.eye_blurry = 5
			wearer.disabilities |= NEARSIGHTED
		if(prob(15))
			wearer << "<span class='danger'>Your eyes burn as you look through the spectacles.</span>"

/obj/item/clothing/glasses/wraithspecs/equipped(M as mob, glasses)
	var/mob/living/carbon/human/H = M
	if(!H) return
	if(H.glasses == src)
		var/datum/organ/internal/eyes/E = H.internal_organs["eyes"]
		if(!(H.sdisabilities & BLIND))
			if(iscultist(H))
				H << "<span class='sinister'>\"Looks like Nar'sie's dogs really don't value their eyes.\"</span>"
				E.damage += E.min_broken_damage
				H << "<span class='danger'>You go blind!</span>"
				H.sdisabilities |= BLIND
				return

			H << "<span class='sinister'>Your vision expands, but your eyes begin to burn.</span>"
			E.damage += 4

			if(E.damage >= E.min_broken_damage && !(H.sdisabilities & BLIND))
				H << "<span class='danger'>You go blind!</span>"
				H.sdisabilities |= BLIND
			else if (E.damage >= E.min_bruised_damage && !(H.disabilities & NEARSIGHTED))
				H << "<span class='danger'>You're going blind!</span>"
				H.eye_blurry = 5
				H.disabilities |= NEARSIGHTED
		else
			H << "<span class='sinister'>\"You're already blind, fool. Stop embarassing yourself.\"</span>"
			return

/obj/item/clothing/glasses/judicialvisor
	name = "winged visor"
	desc = "A winged visor with a strange purple lens. Looking at these makes you feel guilty for some reason."
	icon_state = "judicial_visor"
	item_state = "judicial_visor"
	eyeprot = 2
	rangedattack = 1
	action_button_name = "Toggle winged visor"
	var/on = 0
	var/cooldown = 0

/obj/item/clothing/glasses/judicialvisor/attack_self()
	toggle()

/obj/item/clothing/glasses/judicialvisor/verb/toggle()
	set category = "Object"
	set name = "Toggle winged visor"
	set src in usr

	if(!usr.stat && !cooldown)
		var/mob/living/carbon/human/H = src.loc
		if(!H) return

		if(on)
			on = 0
			icon_state = "judicial_visor"
			item_state = "judicial_visor"
			H << "The lens darkens."
			eyeprot = 2
			if(H.client)
				H.client.mouse_pointer_icon = initial(H.client.mouse_pointer_icon)
		else
			on = 1
			icon_state = "judicial_visor-on"
			item_state = "judicial_visor-on"
			H << 'sound/items/healthanalyzer.ogg'
			H << "The lens lights up."
			eyeprot = -1
			if(H.client)
				H.client.mouse_pointer_icon = file("icons/effects/visor_reticule.dmi")
		H.update_inv_glasses()

/obj/item/clothing/glasses/judicialvisor/ranged_weapon(var/atom/A, mob/living/carbon/human/wearer as mob)
	if(cooldown)
		wearer << "<span class='sinister'>\"Have patience. It's not ready yet.\"</span>"
		return

	if(!on)
		wearer << "Nothing happens."
		return

	if(iscultist(wearer))
		wearer << "<span class='sinister'>\"The stench of blood is all over you. Does Nar'sie not teach his subjects common sense?\"</span>"
		wearer.take_organ_damage(0, 20)
		var/datum/organ/external/affecting = wearer.get_organ("eyes")
		wearer.pain(affecting, 50, 1, 1)
		return

	/*if(!isclockcult(wearer)) NOT IMPLEMENTED YET -velardamakar
		wearer << "Nothing happens."
		return*/

	if(!cooldown)
		var/turf/target = get_turf(A)
		var/obj/effect/judgeblast/J = getFromPool(/obj/effect/judgeblast, get_turf(target))
		J.creator = wearer
		wearer.say("Xarry, urn'guraf!")
		toggle()
		cooldown = 1
		spawn(120)
			cooldown = 0
			toggle()

/obj/effect/judgeblast
	name = "judgement sigil"
	desc = "I feel like I shouldn't be standing here."
	icon = 'icons/effects/96x96.dmi'
	icon_state = null
	layer = 4.1
	mouse_opacity = 0
	pixel_x = -32
	pixel_y = -32
	var/blast_damage = 20
	var/creator = null

/obj/effect/judgeblast/New(loc)
	..()
	playsound(src,'sound/effects/EMPulse.ogg',80,1)
	for(var/turf/T in range(1, src))
		if(findNullRod(T))
			creator << "<span class='sinister'>The visor's power has been negated!</span>"
			returnToPool(src)
	flick("judgemarker", src)
	for(var/mob/living/L in range(1,src))
		//if(isclockcult(L)) continue  NOT IMPLEMENTED YET -velardamakar
		L << "<span class='danger'>A strange force weighs down on you!</span>"
		L.adjustBruteLoss(blast_damage + (iscultist(L)*10))
		if(iscultist(L))
			L.Stun(3)
			L << "<span class='sinister'>\"I SEE YOU!\"</span>"
		else
			L.Stun(2)

	spawn(21)
		playsound(src,'sound/weapons/emp.ogg',80,1)
		var/judgetotal = 0
		icon_state = null
		flick("judgeblast", src)

		spawn(15)
			for(var/turf/T in range(1, src))
				if(findNullRod(T))
					creator << "<span class='sinister'>The visor's power has been negated!</span>"
					returnToPool(src)

			for(var/mob/living/L in range(1,src))
				/*if(isclockcult(L))  NOT IMPLEMENTED YET -velardamakar
					add_logs(creator, L, "used a judgement blast on their ally, ", object="judicial visor")*/
				L << "<span class='danger'>You are struck by a mighty force!</span>"
				L.adjustBruteLoss(blast_damage + (iscultist(L)*5))
				if(iscultist(L))
					L.adjust_fire_stacks(5)
					L.IgniteMob()
					L << "<span class='sinister'>\"There is nowhere the disciples of Nar'sie may hide from me! Burn!\"</span>"
				judgetotal += 1

			if(creator)
				creator << "<span class='sinister'>[judgetotal] target\s judged.</span>"
			returnToPool(src)