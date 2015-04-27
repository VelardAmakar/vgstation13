/obj/item/clock_component
	name = "Clockwork Component"
	desc = "lol this item shouldn't exist"
	icon = 'icons/obj/clockwork/components.dmi'
	throwforce = 0
	w_class = 1.0
	throw_speed = 7
	throw_range = 15
	var/list/godtext = list("This item really shouldn't exist, y'know.")
	var/godbanter = "Your shit sucks and this item shouldn't exist."

/obj/item/clock_component/examine(mob/user)
	..()
	//add a check to see if the revenant in question isn't summoned, if false, no response
	if(prob(15) && isclockcult(user))
		user << "<span class='sinister'>[pick(godtext)]</span>"
	if(iscultist(user) || user.mind.assigned_role == "Chaplain")
		if(prob(45))
			user << "<span class='danger'>[godbanter]</span>"

/obj/item/clock_component/belligerent
	name = "belligerent eye"
	desc = "<span class='danger'>It's as if it's looking for something to hurt.</span>"
	icon_state = "eye"
	godtext = list("\"...\"", \
	"For a brief moment, your mind is flooded with with extremely violent thoughts.")
	godbanter = "The eye gives you an intensely hateful glare."

/obj/item/clock_component/vanguard
	name = "vanguard cogwheel"
	desc = "<span class='info'>It's as if it's trying to comfort you with its glow.</span>"
	icon_state = "cogwheel"
	godtext = list("\"Be safe, child.\"", \
	"You feel comforted, inexplicably.", \
	"\"Never hesitate to make sacrifices for your brothers and sisters.\"", \
	"\"Never forget; pain is temporary, His glory is eternal.\"")
	godbanter = "\"Pray to your god that we never meet.\""

/obj/item/clock_component/replicant
	name = "replicant alloy"
	desc = "<b>It's as if it's calling to be moulded into something greater.</b>"
	icon_state = "alloy"
	godtext = list("\"There's always something to be done. Get to it.\"", \
	"\"Spend more time making these and less time gazing into them.\"", \
	"\"Idle hands are worse than broken hands. Get to work.\"", \
	"A detailed image of Ratvar appears in the alloy for a split second.")
	godbanter = "The alloy takes an ugly, grotesque shape for a moment."

/obj/item/clock_component/hierophant
	name = "hierophant ansible"
	desc = "<span style='color:#ffc000'><b>It's as if it's trying to say something...</b></span>"
	icon_state = "ansible"
	godtext = list("\"NYEHEHEHEHEH!\"", \
	"\"Rkvyr vf fhpu n'ober. Gurer'f abguvat v'pna uhag va urer.\"", \
	"\"Jung'f xrrcvat lbh? V'jnag gb tb xvyy fbzrguvat.\"", \
	"\"V'zvff gur fzryy bs oheavat syrfu fb onqyl...\"")
	godbanter = "\"Fbba, jr funyy erghea, naq lbh funyy crevfu. Hahahaha...\""

/obj/item/clock_component/geis
	name = "geis capacitor"
	desc = "<span style='color:magenta'><i>It's as if it really doesn't doesn't appreciate being held.</i></span>"
	icon_state = "capacitor"
	godtext = list("\"Disgusting.\"", \
	"\"Well, aren't you an inquisitive fellow?\"", \
	"A foul presence pervades your mind, and suddenly vanishes.", \
	"\"The fact that Ratvar has to depend on simpletons like you is appalling.\"")
	godbanter = "\"You know what they say; curiosity lobotomized the cat.\""

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

/obj/item/clothing/glasses/wraithspecs/equipped(var/mob/M, glasses)
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

/obj/item/clothing/glasses/judicialvisor/ranged_weapon(var/atom/A, mob/living/carbon/human/wearer)
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

	if(!isclockcult(wearer))
		wearer << "<span class='warning'>You can't quite figure out how to use this...</span>"
		return

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
		if(isclockcult(L))
			continue
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
				if(isclockcult(L))
					add_logs(creator, L, "used a judgement blast on their ally, ", object="judicial visor")
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

/obj/item/weapon/spear/clockspear
	icon_state = "spearclock0"
	name = "ancient spear"
	desc = "A deadly, bronze weapon of ancient design."
	force = 5
	w_class = 4.0
	slot_flags = SLOT_BACK
	throwforce = 5
	flags = TWOHANDABLE
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("stabbed", "poked", "jabbed", "torn", "gored")
	inhand_states = list("left_hand" = 'icons/mob/in-hand/left/swords_axes.dmi', "right_hand" = 'icons/mob/in-hand/right/swords_axes.dmi')
	var/summontime = 85 //when that ends, no spear

/obj/item/weapon/spear/clockspear/New()
	..()
	processing_objects += src

/obj/item/weapon/spear/clockspear/process()
	if(summontime <= 0)
		var/mob/living/M = loc
		if(istype(M))
			M.visible_message("<span class='warning'>The spear vanishes from [M]'s hand.</span>", \
			"<span class='sinister'>The spear vanishes from your hand.</span>")
		qdel(src)
	else
		summontime--

/obj/item/weapon/spear/clockspear/update_wield(mob/user)
	icon_state = "spearclock[wielded ? 1 : 0]"
	item_state = "spearclock[wielded ? 1 : 0]"
	force = wielded ? 12 : 5
	if(user)
		user.update_inv_l_hand()
		user.update_inv_r_hand()
	return

/obj/item/weapon/spear/clockspear/attack(var/mob/target, mob/living/user )
	if(!isclockcult(user))
		return
	..()
	var/mob/living/M = target
	if(!istype(M))
		return
	if(iscultist(target))
		M.take_organ_damage(wielded ? 38 : 25)
	if(issilicon(target))
		M.take_organ_damage(wielded ? 28 : 15)
	/*else
		user.Paralyse(5)
		user << "<span class='warning'>An unexplicable force powerfully repels the spear from [target]!</span>"
		var/organ = ((user.hand ? "l_":"r_") + "arm")
		var/datum/organ/external/affecting = user:get_organ(organ)
		if(affecting.take_damage(rand(force/2, force))) //random amount of damage between half of the spear's force and the full force of the spear.
			if(iscultist(user))
				user << "<span class='sinister'>\"You're liable to put your eye out like that.\"</span>"
				var/organ = ((user.arm ? "l_":"r_") + "arm")
				var/datum/organ/external/affecting = user:get_organ(organ)
				user:pain(affecting, 100, force, 1)
			user.UpdateDamageIcon()*/

/obj/item/weapon/spear/clockspear/pickup(mob/living/user)
	if(!isclockcult(user))
		user << "<span class='danger'>An overwhelming feeling of dread comes over you as you pick up the cultist's spear. It would be wise to be rid of this weapon quickly.</span>"
		user.Dizzy(120)
	else if(iscultist(user))
		user << "<span class='sinister'>\"Does a savage like you even know how to use that thing?\"</span>"
		var/organ = ((user.hand ? "l_":"r_") + "hand")
		var/datum/organ/external/affecting = user:get_organ(organ)
		user:pain(affecting, 10, 1, 1)

/obj/item/weapon/spear/clockspear/throw_impact(atom/A, mob/user)
	..()
	var/turf/T = get_turf(A)
	T.turf_animation('icons/obj/clockwork/structures.dmi',"energyoverlay[pick(1,2)]",0,0,MOB_LAYER+1,'sound/weapons/bladeslice.ogg')
	var/mob/living/M = A
	if(!istype(M)) return
	if(iscultist(M))
		M.take_organ_damage(15)
		M.Stun(1)
	if(issilicon(M))
		M.take_organ_damage(8)
		M.Stun(2)
	qdel(src)

/spell/clockspear
	name = "Conjure Spear"
	desc = "Conjure a brass spear that serves as a viable weapon against heathens and silicons. Lasts for 3 minutes."

	spell_flags = 0
	range = 0
	charge_max = 2000
	invocation = "Rar'zl orjner!"
	invocation_type = SpI_SHOUT
	still_recharging_msg = "<span class='sinister'>\"Patience is a virtue.\"</span>"

	override_base = "clock"
	cast_sound = 'sound/effects/teleport.ogg'
	hud_state = "clock_spear"

/spell/clockspear/choose_targets(mob/user = usr)
	return list(user)

/spell/clockspear/cast(null, mob/user = usr)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.put_in_any_hand_if_possible(new/obj/item/weapon/spear/clockspear))
			user << "<span class='danger'>You conjure a dangerous-looking brass spear.</span>"
		else
			user << "<span class='sinister'>\"I honestly don't know what you were expecting.\"</span>"
	playsound(user,'sound/effects/evolve.ogg',100,1)
	for(var/turf/T in get_area(user))
		for(var/obj/machinery/light/L in T.contents)
			if(L && prob(20)) L.flicker()


//DEBUG ITEM
/obj/item/weapon/clockcheat
	name = "ZOOP"
	desc = "ZOP"
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "posibrain-occupied"

/obj/item/weapon/clockcheat/pickup(mob/living/user as mob)
	user << "<span class='sinister'>Ratvar: \"It's lit.\"</span>"
	user.add_spell(new/spell/clockspear)