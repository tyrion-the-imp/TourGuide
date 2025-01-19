void SOlfactionGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	//2025.01.19		use 'trackedMonsters' property?
	
	// I am keeping the recommender logic here because I like (most) of these suggestions. However, 
    //   taking out the actual creating-the-tile shit until we refactor to the new olfaction limit 
    //   and turn this into a resource thing rather than a highlighted task.
	string [int] description;
	item MCLP = $item[McHugeLarge left pole];
	
    if (!$skill[Transcendent Olfaction].skill_is_usable()) {
        //return;
		description.listAppend("No olfaction skill??");
	}

    //Add in some basic reminders to remove olfaction if adventuring in certain areas.
    monster olfacted_monster = get_property_monster("olfactedMonster");
    if (olfacted_monster == $monster[none] || __last_adventure_location == $location[none]) {
        //return;
		description.listAppend("Olfaction not used???");
	}
	
	int totalsniffs = 0;
	
	//+3 copies to queue
	totalsniffs += (3 - get_property_int("_olfactionsUsed"));
	if	( (3 - get_property_int("_olfactionsUsed")) > 0 ) {
		description.listAppend("<span style='color:red; font-weight:bold;'>"+(3 - get_property_int("_olfactionsUsed")).to_string()+"</span> Olfaction uses available.");
		description.listAppend("|*Currently tracking: "+get_property("olfactedMonster"));
	}
	//+3 copies to queue
	//$item[McHugeLarge left pole];
	if	( __iotms_usable[lookupItem(MCLP)] ) {
		description.listAppend("<span style='color:red; font-weight:bold;'>"+(3 - get_property_int("_mcHugeLargeSlashUses")).to_string()+"</span> MHL left pole slash uses available.");
		string indicatorMCLP = "green";
		indicatorMCLP = (have_equipped(MCLP)) ? "<span style='color:green; font-weight:bold;'>YES</span>":"<span style='color:red; font-weight:bold;'>NO</span>";
		description.listAppend("|*Equipped? "+indicatorMCLP);
		totalsniffs += (3 - get_property_int("_mcHugeLargeSlashUses"));
	}
    
    monster [location] location_wanted_monster;
    
    if (__misc_state["in run"])
    {
        //if ($item[talisman o' namsilat].available_amount() == 0 && !__quest_state["Level 11 Palindome"].finished)
            //location_wanted_monster[$location[belowdecks]] = $monster[gaudy pirate];
        if (!__quest_state["Level 8"].state_boolean["Past mine"])
            location_wanted_monster[$location[the goatlet]] = $monster[dairy goat];
        if (!__quest_state["Level 7"].state_boolean["niche finished"])
            location_wanted_monster[$location[the defiled niche]] = $monster[dirty old lihc];
        

        //Deliberately ignored - the quiet healer. (she's used to it) It's possible they may want to olfact the burly sidekick instead, and there's plenty of time in that area.
        
        if (!__quest_state["Level 11 Hidden City"].finished)
        {
            if (!__quest_state["Level 11 Hidden City"].state_boolean["Apartment finished"] && $effect[thrice-cursed].have_effect() == 0)
                location_wanted_monster[$location[the hidden apartment building]] = $monster[pygmy shaman];
                
            if (!__quest_state["Level 11 Hidden City"].state_boolean["Hospital finished"] && $items[surgical apron,bloodied surgical dungarees,surgical mask,head mirror,half-size scalpel].items_missing().count() > 0)
                location_wanted_monster[$location[the hidden hospital]] = $monster[pygmy witch surgeon];
                
                
            if (!__quest_state["Level 11 Hidden City"].state_boolean["Office finished"] && $item[McClusky file (page 5)].available_amount() == 0 && $item[McClusky file (complete)].available_amount() == 0)
                location_wanted_monster[$location[the hidden office building]] = $monster[pygmy witch accountant];
                
            if (!__quest_state["Level 11 Hidden City"].state_boolean["Bowling alley finished"])
                location_wanted_monster[$location[the hidden bowling alley]] = $monster[pygmy bowler];
        }
        if (!have_outfit_components("Knob Goblin Harem Girl Disguise"))
            location_wanted_monster[$location[cobb's knob harem]] = $monster[Knob Goblin Harem Girl];
        
		
		//location_wanted_monster[$location[fear man's level]] = $monster[morbid skull];

        // RIP to my boy, the blooper
        // if ($item[digital key].available_amount() == 0 && !__quest_state["Level 13"].state_boolean["digital key used"] && $item[white pixel].available_amount() + $item[white pixel].creatable_amount() < 27)
        //     location_wanted_monster[$location[8-bit realm]] = $monster[Blooper];
		if (!__quest_state["Level 11 Pyramid"].finished && olfacted_monster != $monster[tomb servant])
				location_wanted_monster[$location[the middle chamber]] = $monster[tomb rat];
    } else { //end in run
		
		//aftercore
		if (!($monsters[ferocious roc,giant man-eating shark,Bristled Man-O-War,The Cray-Kin,Deadly Hydra] contains olfacted_monster))
			location_wanted_monster[$location[the old man's bathtime adventures]] = $monster[none];
		if (!__quest_state["Azazel"].finished) {
            location_wanted_monster[$location[infernal rackets backstage]] = $monster[serialbus];
            location_wanted_monster[$location[the laugh floor]] = $monster[CH Imp];
        }
        //if (in_hardcore())
            //location_wanted_monster[$location[The Dark Neck of the Woods]] = $monster[Hellion];
        
		if ($skill[summon smithsness].skill_is_usable() && $item[dirty hobo gloves].available_amount() == 0 && $item[hand in glove].available_amount() == 0 && __misc_state["need to level"])
        {
            location_wanted_monster[$location[The Sleazy Back Alley]] = $monster[drunken half-orc hobo];
            location_wanted_monster[$location[The Haunted Pantry]] = $monster[drunken half-orc hobo];
        }
    }
	
	
    
    foreach l in location_wanted_monster
    {
        monster m = location_wanted_monster[l];
        if (l == $location[none])
            continue;
        if (__last_adventure_location != l)
            //continue;
        if (m == olfacted_monster)
            continue;
        
        boolean all_other_monsters_banished = true;
        foreach key, m2 in l.get_monsters()
        {
            if (m == m2)
                continue;
            if (!m2.is_banished())
            {
                all_other_monsters_banished = false;
                break;
            }
        }
        if (all_other_monsters_banished)
            continue;
        
        
        string line;
        
        if (m != $monster[none])
            line += "To olfact " + m.HTMLEscapeString() + " instead of " + olfacted_monster.HTMLEscapeString() + ".|";
        else
            line += "To olfact in " + l + ".|";
            
        if (in_ronin())
            //line += $item[soft green echo eyedrop antidote].pluralise() + " available.";
        
        description.listAppend(line);
        
        
        // Old suggestion recommendation; removing this bit because it isn't needed or necessary. We need to factor this
        //   as a "top" recommendation thing, with the relevant idea from your most recent zone and a few other ideas
        //   alongside the # of olfactions remaining. 

        task_entries.listAppend(ChecklistEntryMake("__item " + $item[soft green echo eyedrop antidote], "inventory.php?ftext=soft+green+echo+eyedrop+antidote", ChecklistSubentryMake(totalsniffs+" total Sniffs available.", "", description), -10).ChecklistEntrySetIDTag("Olfaction better suggestion")); //TODO could differentiate by suggestion
        
        break;
    }
    
}
