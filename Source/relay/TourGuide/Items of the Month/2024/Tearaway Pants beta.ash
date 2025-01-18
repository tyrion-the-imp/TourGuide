// Tearaway Pants
RegisterResourceGenerationFunction("IOTMTearawayPantsGenerateTaskBeta");
void IOTMTearawayPantsGenerateTaskBeta(ChecklistEntry [int] resource_entries)
{
    // Don't show the tile if you don't have the pants.
	if (!__iotms_usable[lookupItem("tearaway pants")]) return;

    // Don't show the tile if you aren't a moxie class.
    //if (!($classes[disco bandit,accordion thief] contains my_class())) return;

    // I can't believe I'm doing this. I have truly lost control of my life.
    QuestState base_quest_state = __quest_state["Guild"];
	//if (base_quest_state.finished || !base_quest_state.startable || base_quest_state.mafia_internal_step == 2) return;

    // Do you have the stupid pants equipped?
    boolean havePantsEquipped = $slot[pants].equipped_item() == $item[tearaway pants];

	string [int] description;

    // If equipped, send user to the guild. If not, send them to the inventory.
	string url = havePantsEquipped ? "guild.php" : "inventory.php?ftext=tearaway+pants";
	string header = "Tear away your tearaway pants! BETA";

	if	( my_primestat() == $stat[Moxie] ) {
		if (havePantsEquipped) description.listAppend(`Visit the Department of Shadowy Arts and Crafts to unlock the guild!`);
		if (!havePantsEquipped) description.listAppend(`Visit the Department of Shadowy Arts and Crafts with your pants equipped to unlock the guild!`);
	}

	buffer tooltip;
	tooltip.append("Beasts, Bugs, Penguins = 3-round stun.");
	tooltip.append("<br><br>Constellations, Elementals = Delevels enemy.");
	tooltip.append("<br><br>Constructs, Slimes = No effect.");
	tooltip.append("<br><br>Demons, Horrors, Undead, Weird = Physical damage to enemy");
	tooltip.append("<br><br>Dudes, Elves, Goblins, Hippies, Hobos, Humanoids, Orcs, Pirates = If monster drops pickpockettable pants, acquires pants. Otherwise, +15% to Item drop bonus for current combat.");
	tooltip.append("<br><br>Fish, Mer-kin = Small substat gain; range unknown.");
	tooltip.append("<br><br>Plants = Gain 1 adventure or no effect. Likelihood of Adventure gain is 1/(2+x) where x is the number of adventures gained today.");
	string tooltipEnumerated = HTMLGenerateSpanOfClass(HTMLGenerateSpanOfClass(tooltip, "r_tooltip_inner_class r_tooltip_inner_class_margin") + "Hover for Tear Awaay pants skill info", "r_tooltip_outer_class");
	description.listAppend(tooltipEnumerated);

	resource_entries.listAppend(ChecklistEntryMake("__item tearaway pants", url, ChecklistSubentryMake(header, "", description), -40));

}

/* 
tear away pants skill:
Beasts, Bugs, Penguins	3-round stun.
Constellations, Elementals	Delevels enemy.
Constructs, Slimes	No effect.
Demons, Horrors, Undead, Weird	Physical damage to enemy
Dudes, Elves, Goblins, Hippies, Hobos, Humanoids, Orcs, Pirates	If monster drops pickpockettable pants, acquires pants. Otherwise, +15% to Item drop bonus for current combat.
Fish, Mer-kin	Small substat gain; range unknown. Seen +27-+39 on scaling monsters for level 59 adventurer.
Plants	Gain 1 adventure or no effect. Likelihood of Adventure gain is 1/(2+x) where x is the number of adventures gained today. 
 */