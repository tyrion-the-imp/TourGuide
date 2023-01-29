//Industrial fire extinguisher
RegisterTaskGenerationFunction("IOTMFireExtinguisherGenerateTasks");
void IOTMFireExtinguisherGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (!__iotms_usable[lookupItem("industrial fire extinguisher")]) return;
		// Title
	string [int] description;
	string [int] options;
	string url = "inventory.php?ftext=industrial+fire+extinguisher";

	// Entries
	int extinguisher_charge = get_property_int("_fireExtinguisherCharge");
	int extinguisher_importance = CHECKLIST_DEFAULT_IMPORTANCE;
	
	if (!lookupItem("industrial fire extinguisher").equipped())
		description.listAppend(HTMLGenerateSpanFont("Equip the fire extinguisher first.", "red"));

	if (__misc_state["in run"] && my_path().id != 25 && extinguisher_charge >= 20) // Path 25 is Community Service.
	{
		if ( !get_property_boolean("fireExtinguisherBatHoleUsed") && !__quest_state["Level 4"].finished && qprop("questL04Bat > -1") )
		{
			options.listAppend(HTMLGenerateSpanOfClass("BatHole:", "r_bold") + " Unlock next zone for free. (can't be used vs screambat)");
		}
		if (!get_property_boolean("fireExtinguisherHaremUsed") && !__quest_state["Level 5"].finished && qprop("questL05Goblin > 0") )
		{
			options.listAppend(HTMLGenerateSpanOfClass("Cobb's Knob Harem:", "r_bold") + " Get harem outfit for free.");
		}
		if (!get_property_boolean("fireExtinguisherCyrptUsed") && !__quest_state["Level 7"].finished && qprop("questL07Cyrptic > -1") )
		{
			options.listAppend(HTMLGenerateSpanOfClass("Cyrpt:", "r_bold") + " -10 Evilness in one zone.");
		}
		if (!get_property_boolean("fireExtinguisherChasmUsed") && !__quest_state["Level 9"].finished && qprop("questL09Topping > -1") )
		{
			options.listAppend(HTMLGenerateSpanOfClass("Smut Orc Logging Camp:", "r_bold") + " +66% Blech House progress.");
		}
		if (!get_property_boolean("fireExtinguisherDesertUsed") && !locationAvailable($location[The Upper Chamber]) == true && qprop("questL11Desert > -1") )
		{
			options.listAppend(HTMLGenerateSpanOfClass("Arid, Extra-Dry Desert:", "r_bold") + " Ultrahydrated (15 advs).");
		}
		
		string z = my_location().zone;
		if	( 
				( my_location() == $location[The Smut Orc Logging Camp] && !get_property_boolean("fireExtinguisherChasmUsed") )
				|| ( my_location() == $location[The Arid, Extra-Dry Desert] && !get_property_boolean("fireExtinguisherDesertUsed") )
				|| ( z == "BatHole" && !get_property_boolean("fireExtinguisherBatHoleUsed") )
				|| ( my_location() == $location[Cobb's Knob Harem] && !get_property_boolean("fireExtinguisherHaremUsed") )
				|| ( z == "Cyrpt" && !get_property_boolean("fireExtinguisherCyrptUsed") )
			) { extinguisher_importance = -11; }
		
		if (options.count() > 0)
			description.listAppend(HTMLGenerateSpanFont("<span style='font-size:120%; font-weight:bold;'>Zone-specific skills (20% charge):</span>", "red") + " 1/ascension special options in the following zones:|*-" + options.listJoinComponents("|*-"));
	}
	if (extinguisher_charge >= 5 && extinguisher_importance != CHECKLIST_DEFAULT_IMPORTANCE) {
		task_entries.listAppend(ChecklistEntryMake("__item industrial fire extinguisher", url, ChecklistSubentryMake(extinguisher_charge + "% fire extinguisher available", "", description),extinguisher_importance).ChecklistEntrySetIDTag("industrial fire extinguisher skills resource"));
	}
}

RegisterResourceGenerationFunction("IOTMFireExtinguisherGenerateResource");
void IOTMFireExtinguisherGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (!__iotms_usable[lookupItem("industrial fire extinguisher")]) return;
		// Title
	string [int] description;
	string [int] options;

	// Entries
	int extinguisher_charge = get_property_int("_fireExtinguisherCharge");
	int extinguisher_importance = CHECKLIST_DEFAULT_IMPORTANCE;
	boolean extinguisher_refill = get_property_boolean("_fireExtinguisherRefilled");
	boolean is_on_fire = my_path().id == 43; // Path 43 is Wildfire.

	string url = "inventory.php?ftext=industrial+fire+extinguisher";
	description.listAppend("Extinguish the fires in your life!");
	if (extinguisher_charge >= 5) 
	{
		description.listAppend(HTMLGenerateSpanOfClass("Blast the Area (5% charge):", "r_bold") + " 1 turn of passive damage.");
		description.listAppend(HTMLGenerateSpanOfClass("Foam 'em Up (5% charge):", "r_bold") + " Stun!");
	if (extinguisher_charge >= 10)
		description.listAppend(HTMLGenerateSpanOfClass("Foam Yourself (10% charge):", "r_bold") + " 1 turn of +30 Hot Resist.");
		description.listAppend(HTMLGenerateSpanOfClass("Polar Vortex (10% charge):", "r_bold") + " Hugpocket duplicator, usable more than once per fight.");
	} 

	
	if (__misc_state["in run"] && is_on_fire && !get_property_boolean("_fireExtinguisherRefilled") )
	{
		string description = "Tank refill available";
		resource_entries.listAppend(ChecklistEntryMake("__item fireman's helmet", "place.php?whichplace=wildfire_camp&action=wildfire_captain", ChecklistSubentryMake("Tank refill available", "", description)).ChecklistEntrySetIDTag("Tank refill resource"));
	}   

	if (!lookupItem("industrial fire extinguisher").equipped())
		description.listAppend(HTMLGenerateSpanFont("Equip the fire extinguisher first.", "red"));

	if (__misc_state["in run"] && my_path().id != 25 && extinguisher_charge >= 20) // Path 25 is Community Service.
	{
		if (!get_property_boolean("fireExtinguisherBatHoleUsed") && !__quest_state["Level 4"].finished)
		{
			options.listAppend(HTMLGenerateSpanOfClass("BatHole:", "r_bold") + " Unlock next zone for free. (can't be used vs sreambat)");
		}
		if (!get_property_boolean("fireExtinguisherHaremUsed") && !__quest_state["Level 5"].finished)
		{
			options.listAppend(HTMLGenerateSpanOfClass("Cobb's Knob Harem:", "r_bold") + " Get harem outfit for free.");
		}
		if (!get_property_boolean("fireExtinguisherCyrptUsed") && !__quest_state["Level 7"].finished)
		{
			options.listAppend(HTMLGenerateSpanOfClass("Cyrpt:", "r_bold") + " -10 Evilness in one zone.");
		}
		if (!get_property_boolean("fireExtinguisherChasmUsed") && !__quest_state["Level 9"].finished)
		{
			options.listAppend(HTMLGenerateSpanOfClass("Smut Orc Logging Camp:", "r_bold") + " +66% Blech House progress.");
		}
		if (!get_property_boolean("fireExtinguisherDesertUsed") && !locationAvailable($location[The Upper Chamber]) == true)
		{
			options.listAppend(HTMLGenerateSpanOfClass("Arid, Extra-Dry Desert:", "r_bold") + " Ultrahydrated (15 advs).");
		}
		
		if (options.count() > 0)
			description.listAppend(HTMLGenerateSpanOfClass("Zone-specific skills (20% charge):", "r_bold") + " 1/ascension special options in the following zones:|*-" + options.listJoinComponents("|*-"));
	}
	if ((is_on_fire && !get_property_boolean("_fireExtinguisherRefilled") || extinguisher_charge >= 5)) {
		resource_entries.listAppend(ChecklistEntryMake("__item industrial fire extinguisher", url, ChecklistSubentryMake(extinguisher_charge + "% fire extinguisher available", "", description),extinguisher_importance).ChecklistEntrySetIDTag("industrial fire extinguisher skills resource"));
	}
}
