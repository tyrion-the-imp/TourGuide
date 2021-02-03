//experimental cartography code
RegisterResourceGenerationFunction("IOTMCartographyMapsGenerateResource");
void IOTMCartographyMapsGenerateResource(ChecklistEntry [int] resource_entries)
{
		if	( !is_unrestricted($skill[Comprehensive Cartography]) || !have_skill($skill[Comprehensive Cartography]) ) { return; }
		
		int maps_left = clampi(3 - get_property_int("_monstersMapped"), 0, 3);
    	string [int] description;
        description.listAppend("<a href='https://kol.coldfront.net/thekolwiki/index.php/Comprehensive_Cartography#Notes' target='_blank'><span style='color:blue; font-size:100%; font-weight:normal;'>Comprehensive Cartography</span></a><br /><a href='https://kol.coldfront.net/thekolwiki/index.php/Map_the_Monsters' target='_blank'><span style='color:blue; font-size:100%; font-weight:normal;'>Map the Monsters</span></a><br />Map the monsters you want to fight!");
		string [int] options;
		if (__misc_state["in run"] && my_path_id() != PATH_COMMUNITY_SERVICE)
		{
			//description.listAppend("This IotM also gives you a special noncom in the following zones:");
			
			//START SHOWING 1 LEVEL EARLY? (instead of until they expire)
			
			if (get_property("questM20Necklace") != "finished")
				{
					options.listAppend("<span style='color:coral; font-size:100%; font-weight:bold;'>The Haunted Billiards Room</span> - That's your cue, Welcome To Our ool Table or fight a chalkdust wraith");
				}
			if (my_level() > 2 && get_property("questL04Bat") != "finished")
				{
					options.listAppend(HTMLGenerateSpanOfClass("First adv", "r_bold") + " <span style='color:coral; font-size:100%; font-weight:bold;'>Guano Junction</span> - 350 meat or fight screambat.");
				}
			if (my_level() > 4 && get_property("questL06Friar") != "finished")
				{
					options.listAppend("<span style='color:coral; font-size:100%; font-weight:bold;'>The Dark Neck of the Woods</span> - Skip to the second quest noncombat (and gain 1,000 Meat) or skip to the third quest noncombat");
				}
			if (my_level() > 5 && get_property_int("cyrptNookEvilness") > 25)
				{
					options.listAppend("<span style='color:coral; font-size:100%; font-weight:bold;'>The Defiled Nook</span> - 2 evil eyes or fight a party skelteon");
				}
			if (my_level() > 7 && get_property_int("twinPeakProgress") != 15)
				{
					options.listAppend(HTMLGenerateSpanOfClass("First adv", "r_bold") + " <span style='color:coral; font-size:100%; font-weight:bold;'>A-Boo Peak</span> - The Horror..., Lost in the Great Overlook Lodge or fight an oil baron");
				}
			//InternalStepNumber is +1 to mafia step value (want below step10 so 11) see QuestState.ash
			if (my_level() > 8 && !questPropertyPastInternalStepNumber("questL10Garbage",10))
					{
						options.listAppend("<span style='color:coral; font-size:100%; font-weight:bold;'>Castle Top Floor</span> - Copper Feel, Melon Collie and the Infinite Lameness, Yeah, You're for Me, Punk Rock Giant, or Flavor of a Raver");
					}
			if (my_level() > 9 && get_property_int("zeppelinProtestors") < 80)
				{
					options.listAppend("<span style='color:coral; font-size:100%; font-weight:bold;'>A Mob of Zeppelin Protesters</span> - Bench Warrant, Fire Up Above or This Looks Like a Good Bush for an Ambush");
				}
			//if (!__quest_state["warProgress"].started)
			if ( my_level() > 10 && get_property("questL12War").index_of("started") > -1 )
					{
						options.listAppend("<span style='color:coral; font-size:100%; font-weight:bold;'>The Hippy Camp (Verge of War)</span> - Bait and Switch, The Thin Tie-Dyed Line or Blockin' Out the Scenery (start war)");
					}			
			//if (!__quest_state["warProgress"].started)
			if ( my_level() > 10 && get_property("questL12War").index_of("started") > -1 )
					{
						options.listAppend("<span style='color:coral; font-size:100%; font-weight:bold;'>Orcish Frat House (Verge of War)</span> - Catching Some Zetas (war pledge), Fratacombs (start war) or One Less Room Than In That Movie (Frat Warrior drill sergeant)");
					}			
		string [int] monsterMaps;
		if	( maps_left > 0 ) {
			if (get_property("questM20Necklace") != "finished") {
				monsterMaps.listAppend("banshee, YR for killing jar?");
			}
			if (get_property("questM21Dance") != "finished")
			{
				monsterMaps.listAppend("ornate / elegant nightstands");
            }
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
			if ($item[star chart].available_amount() < 1 && $item[richard's star key].available_amount() < 1)
            {
                monsterMaps.listAppend("Astronomer");
            }
			if (!get_property_boolean("pyramidBombUsed") && ($item[crumbling wooden wheel].available_amount() + $item[tomb ratchet].available_amount() < 10))
            {
                monsterMaps.listAppend("tomb rat. Tangles = "+$item[tangle of rat tails].available_amount());
            }
			if (!__quest_state["Level 12"].state_boolean["Lighthouse Finished"] && $item[barrel of gunpowder].available_amount() < 5)
            {
                monsterMaps.listAppend("Lobsterfrogman. Combine with Use the Force?");
            }
			if ($location[The Battlefield (Frat Uniform)].turns_spent > 20)
            {
                monsterMaps.listAppend("Green Ops Soldier. Combine with Olfaction/Use the Force and Spit and Explodinal pills.");
            }
		}
		
		if (options.count() > 0)
            description.listAppend("Noncoms of interest:|*-" + options.listJoinComponents("|*-"));
		if (monsterMaps.count() > 0)
            description.listAppend("Monsters to map (<b>"+maps_left+"</b> left):|*-" + monsterMaps.listJoinComponents("|*-"));
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
