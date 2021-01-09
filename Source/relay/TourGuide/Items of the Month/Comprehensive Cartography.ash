//experimental cartography code
RegisterResourceGenerationFunction("IOTMCartographyMapsGenerateResource");
void IOTMCartographyMapsGenerateResource(ChecklistEntry [int] resource_entries)
{
		int maps_left = clampi(3 - get_property_int("_monstersMapped"), 0, 3);
    	string [int] description;
        description.listAppend("Map the monsters you want to fight!");
		string [int] options;
		if (__misc_state["in run"] && my_path_id() != PATH_COMMUNITY_SERVICE)
		{
			description.listAppend("This IotM also gives you a special noncom in the following zones:");
			if (!__quest_state["cc_spookyravennecklace"].finished)
				{
					options.listAppend("<span style='color:coral; font-size:100%; font-weight:bold;'>The Haunted Billiards Room</span> - That's your cue, Welcome To Our ool Table or fight a chalkdust wraith");
				}
			if (get_property("questL04Bat") != "finished")
				{
					options.listAppend("<span style='color:coral; font-size:100%; font-weight:bold;'>Guano Junction</span> - 350 meat or fight screambat.");
				}
			if (!__quest_state["cc_friars"].finished)
				{
					options.listAppend("<span style='color:coral; font-size:100%; font-weight:bold;'>The Dark Neck of the Woods</span> - Skip to the second quest noncombat (and gain 1,000 Meat) or skip to the third quest noncombat");
				}
			if (get_property_int("cyrptNookEvilness") > 25)
				{
					options.listAppend("<span style='color:coral; font-size:100%; font-weight:bold;'>The Defiled Nook</span> - 2 evil eyes or fight a party skelteon");
				}
			if (get_property_int("twinPeakProgress") != 15)
				{
					options.listAppend(HTMLGenerateSpanOfClass("First adv", "r_bold") + " <span style='color:coral; font-size:100%; font-weight:bold;'>A-Boo Peak</span> - The Horror..., Lost in the Great Overlook Lodge or fight an oil baron");
				}
			if (!__quest_state["cc_castletop"].finished)
					{
						options.listAppend("<span style='color:coral; font-size:100%; font-weight:bold;'>Castle Top Floor</span> - Copper Feel, Melon Collie and the Infinite Lameness, Yeah, You're for Me, Punk Rock Giant, or Flavor of a Raver");
					}
			if (get_property_int("zeppelinProtestors") < 80)
				{
					options.listAppend("<span style='color:coral; font-size:100%; font-weight:bold;'>A Mob of Zeppelin Protesters</span> - Bench Warrant, Fire Up Above or This Looks Like a Good Bush for an Ambush");
				}
			if (!__quest_state["warProgress"].started)
					{
						options.listAppend("<span style='color:coral; font-size:100%; font-weight:bold;'>The Hippy Camp (Verge of War)</span> - Bait and Switch, The Thin Tie-Dyed Line or Blockin' Out the Scenery (start war)");
					}			
			if (!__quest_state["warProgress"].started)
					{
						options.listAppend("<span style='color:coral; font-size:100%; font-weight:bold;'>Orcish Frat House (Verge of War)</span> - Catching Some Zetas (war pledge), Fratacombs (start war) or One Less Room Than In That Movie (Frat Warrior drill sergeant)");
					}			
		string [int] monsterMaps;
			if (!__quest_state["Level 11 Ron"].finished)
			{
				monsterMaps.listAppend("Red Butler, 30% free kill item and 15% fun drop item. Combine with Olfaction/Use the Force?");
            }
			if (get_property_int("twinPeakProgress") < 15 && $item[rusty hedge trimmers].available_amount() < 4)
            {
				monsterMaps.listAppend("hedge beast, 15% quest progress item. Possibly Spit.");
            }
			if (__quest_state["Level 9"].state_int["a-boo peak hauntedness"] > 0)
			{
			    monsterMaps.listAppend("Whatsian Commander Ghost, 15% free runaway item. Possibly Spit.");
            }
			if ($item[star chart].available_amount() < 1 || $item[richard's star key].available_amount() < 1)
            {
                monsterMaps.listAppend("Astronomer");
            }
			if (!__quest_state["Level 12"].state_boolean["Lighthouse Finished"] && $item[barrel of gunpowder].available_amount() < 5)
            {
                monsterMaps.listAppend("Lobsterfrogman, probably a weak option. Combine with Use the Force?");
            }
			if ($location[The Battlefield (Frat Uniform)].turns_spent > 20)
            {
                monsterMaps.listAppend("Green Ops Soldier. Combine with Olfaction/Use the Force and Spit and Explodinal pills.");
            }
		
		if (options.count() > 0)
            description.listAppend("Noncoms of interest:|*-" + options.listJoinComponents("|*-"));
		if (monsterMaps.count() > 0)
            description.listAppend("Monsters to map:|*-" + monsterMaps.listJoinComponents("|*-"));
        }
        resource_entries.listAppend(ChecklistEntryMake("__item Comprehensive Cartographic Compendium", "", ChecklistSubentryMake(pluralise(maps_left, "Cartography skill use", "Cartography skill uses"), "", description), 5).ChecklistEntrySetIDTag("Cartography skills resource"));
}

RegisterTaskGenerationFunction("IOTMCartographyMapsGenerateTasks");
void IOTMCartographyMapsGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
		{
		string [int] description;
		string title = "Your mapping senses are activated!";
			description.listAppend(HTMLGenerateSpanFont("Pick your monster!", "blue"));
		if (!get_property_boolean("mappingMonsters") == false) {
            task_entries.listAppend(ChecklistEntryMake("__item Comprehensive Cartographic Compendium", "url", ChecklistSubentryMake(title, description), -11));
			}
		}	
}
