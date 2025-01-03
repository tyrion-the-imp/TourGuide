


string generateNinjaSafetyGuide(boolean show_colour)
{
	boolean can_survive = false;
	float init_needed = $monster[ninja snowman assassin].monster_initiative();
	init_needed = monster_initiative($monster[Ninja snowman assassin]);
	
	float damage_taken = calculateCurrentNinjaAssassinMaxDamage();
    float damage_taken_always = calculateCurrentNinjaAssassinMaxEnvironmentalDamage();
	
	string result;
	if (initiative_modifier() >= init_needed)
	{
        if (my_hp() >= ceil(damage_taken_always) + 2)
            can_survive = true;
		result += "Keep";
	}
	else
		result += "Need";
	result += " +" + ceil(init_needed) + "% init";
    
    if (damage_taken_always > my_hp())
        result += "/" + ceil(damage_taken_always) + " HP";
    
    result += " to survive ninja, or ";
    
    //FIXME warn about damage_taken_always WITH INIT
	
	int min_safe_damage = (ceil(damage_taken) + 2) + (ceil(damage_taken_always) + 2) ;
	if (my_hp() >= min_safe_damage)
	{
		result += "keep";
		can_survive = true;
	}
	else
		result += "need";
	result += " HP above " + min_safe_damage + ".";
    
    if (my_path().id == PATH_CLASS_ACT_2 && monster_level_adjustment() > 50)
    {
        result += " Reduce ML to +50 to prevent elemental damage.";
        can_survive = false;
    }
	
	if (!can_survive && show_colour)
		result = HTMLGenerateSpanFont(result, "red");
	return result;
}




void CopiedMonstersGenerateDescriptionForMonster(string monster_name, string [int] description, boolean show_details, boolean from_copy)
{
    if (!__misc_state["in run"])
        return;
    monster_name = monster_name.to_lower_case();
	
	if (monster_name == "ninja snowman assassin")
	{
		description.listAppend(generateNinjaSafetyGuide(show_details));
        int components_missing = $items[frayed ninja rope,loose ninja carabiner,dull ninja crampons].items_missing().count();
        if (components_missing > 0)
            description.listAppend("Need to fight " + components_missing.int_to_wordy() + " more.");
        else
            description.listAppend("Don't need to fight anymore.");
        
        if (from_copy && $familiar[obtuse angel].familiar_is_usable() && $familiar[reanimated reanimator].familiar_is_usable())
        {
            string line = "Make sure to copy with angel, not the reanimator.";
            if (my_familiar() == $familiar[reanimated reanimator])
                line = HTMLGenerateSpanFont(line, "red");
            description.listAppend(line);
        }
	}
	//mimic egg, is list of monsters which mafia is not aware of yet
	else if (monster_name == "dummy monster")
	{
		string line;
		boolean requirements_met = false;
		if ( available_amount($item[mimic egg]) > 0 ) {
			line += "<a href='inv_use.php?pwd="+my_hash()+"&which=99&whichitem=11542' target='mainpane'><span style='color:blue; font-size:100%; font-weight:normal;'>Click here:</span></a> to view the list of monsters the egg contains.";
			requirements_met = true;
		}
		else
		{
			line += "";
			requirements_met = false;
		}
		//line += "+150% item for large box";
		//if (show_details && !requirements_met)
			//line = HTMLGenerateSpanFont(line, "red");
		description.listAppend(line);
	}
	else if (monster_name == "quantum mechanic")
	{
		string line;
		boolean requirements_met = false;
		if (item_drop_modifier_ignoring_plants() < 150.0)
			line += "Need ";
		else
		{
			line += "Keep ";
			requirements_met = true;
		}
		line += "+150% item for large box";
		if (show_details && !requirements_met)
			line = HTMLGenerateSpanFont(line, "red");
		description.listAppend(line);
	}
    else if ($strings[bricko bat,bricko cathedral,bricko elephant,bricko gargantuchicken,bricko octopus,bricko ooze,bricko oyster,bricko python,bricko turtle,bricko vacuum cleaner] contains monster_name)
    {
        description.listAppend("Zero adventure cost, use to burn delay.");
    }
    else if (monster_name == "lobsterfrogman" && show_details)
    {
        string line;
    
        if (!__quest_state["Level 12"].state_boolean["Lighthouse Finished"] && $item[barrel of gunpowder].available_amount() < 5)
        {
            int number_to_fight = clampi(5 - $item[barrel of gunpowder].available_amount(), 0, 5);
            line += number_to_fight.int_to_wordy().capitaliseFirstLetter() + " more to defeat. ";
        }
        
        int lfm_attack = $monster[lobsterfrogman].base_attack + 5.0;
        string attack_text = lfm_attack + " attack.";
        
		if (my_buffedstat($stat[moxie]) < lfm_attack)
			attack_text = HTMLGenerateSpanFont(attack_text, "red");
        
        line += attack_text;
        description.listAppend(line);
    }
    else if (monster_name == "big swarm of ghuol whelps" || monster_name == "swarm of ghuol whelps" || monster_name == "giant swarm of ghuol whelps")
    {
        float monster_level = monster_level_adjustment_ignoring_plants();
    
        monster_level = MAX(monster_level, 0);
        
        float cranny_beep_beep_beep = MAX(3.0,sqrt(monster_level));
        description.listAppend("~" + cranny_beep_beep_beep.roundForOutput(1) + " cranny beeps.");
    }
    else if (monster_name == "writing desk")
    {
        /*if ($item[telegram from Lady Spookyraven].available_amount() > 0)
            description.listAppend(HTMLGenerateSpanFont("Read the telegram from Lady Spookyraven first.", "red"));
        int desks_remaining = clampi(5 - get_property_int("writingDesksDefeated"), 0, 5);
        if (desks_remaining > 0 && !get_property_ascension("lastSecondFloorUnlock") && $item[Lady Spookyraven's necklace].available_amount() == 0 && get_property("questM20Necklace") != "finished" && mafiaIsPastRevision(15244))
            description.listAppend(pluraliseWordy(desks_remaining, "desk", "desks").capitaliseFirstLetter() + " remaining.");*/
        description.listAppend("This doesn't work anymore.");

    }
    else if (monster_name == "skinflute" || monster_name == "camel's toe")
    {
        description.listAppend("Have " + pluralise($item[star]) + " and " + pluralise($item[line]) + ".");
		if (item_drop_modifier_ignoring_plants() < 234.0)
			description.listAppend(HTMLGenerateSpanFont("Need +234% item.", "red"));
    }
    else if (monster_name == "source agent")
    {
        if (monster_level_adjustment() > 0)
            description.listAppend("Possibly remove +ML.");
        string stat_description;
        
        if (get_property_int("sourceAgentsDefeated") > 0)
            stat_description += pluralise(get_property_int("sourceAgentsDefeated"), "agent", "agents") + " defeated so far. ";
        stat_description += $monster[Source Agent].base_attack + " attack.";
        float our_init = initiative_modifier();
        if ($skill[Overclocked].have_skill())
            our_init += 200;
        float agent_initiative = $monster[Source Agent].base_initiative;
        float chance_to_get_jump = clampf(100 - agent_initiative + our_init, 0.0, 100.0);
        boolean might_not_gain_init = false;
        boolean avoid_displaying_init_otherwise = false;
        if (my_thrall() == $thrall[spaghetti elemental] && my_thrall().level >= 5 && monster_level_adjustment() <= 150)
        {
            stat_description += "|Will effectively gain initiative on agent.";
            if (!__iotms_usable[$item[source terminal]] || get_property_int("_sourceTerminalPortscanUses") >= 3)
                avoid_displaying_init_otherwise = true;
        }
        if (avoid_displaying_init_otherwise)
        {
        }
        else if (chance_to_get_jump >= 100.0)
            stat_description += "|Will gain initiative on agent.";
        else if (chance_to_get_jump <= 0.0)
        {
            stat_description += "|Will not gain initiative on agent. Need " + round(agent_initiative - our_init) + "% more init.";
            might_not_gain_init = true;
        }
        else
        {
            stat_description += "|" + round(chance_to_get_jump) + "% chance to gain initiative on agent.";
            might_not_gain_init = true;
        }
        if (might_not_gain_init)
        {
            if (my_class() == $class[pastamancer] && $skill[bind spaghetti elemental].have_skill() && my_thrall() != $thrall[spaghetti elemental])
            {
                stat_description += " Or run ";
                if ($thrall[spaghetti elemental].level < 5)
                    stat_description += "and level up ";
                stat_description += "a spaghetti elemental to block the first attack.";
            }
        }
        description.listAppend(stat_description);
        if (__last_adventure_location == $location[the haunted bedroom])
            description.listAppend("Won't appear in the haunted bedroom, so may want to go somewhere else?");
        if ($skill[Humiliating Hack].have_skill())
        {
            string [int] delevelers;
            if ($skill[ruthless efficiency].have_skill() && $effect[ruthlessly efficient].have_effect() == 0)
            {
                delevelers.listAppend("cast ruthless efficiency");
            }
            if ($item[dark porquoise ring].available_amount() > 0 && $item[dark porquoise ring].equipped_amount() == 0 && $item[dark porquoise ring].can_equip())
            {
                delevelers.listAppend("equip dark porquoise ring");
            }
            if (delevelers.count() > 0)
            {
                description.listAppend("Possibly " + delevelers.listJoinComponents(", ", "or") + " for better deleveling.");
            }
        }
    }
    
    if (__misc_state["monsters can be nearly impossible to kill"] && monster_level_adjustment() > 0)
        description.listAppend(HTMLGenerateSpanFont("Possibly remove +ML to survive. (at +" + monster_level_adjustment() + " ML)", "red"));
}





void generateCopiedMonstersEntry(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, boolean from_task) //if from_task is false, assumed to be from resources
{
	//from_task		this call triggered from SCopiedMonstersGenerateTasks with task_entries & optional_task_entries
	//!from_task		this call triggered from SCopiedMonstersGenerateResource with resource_entries x2 (?? one is supposed to be 'dummy'??)
	
	string [int] description;
	boolean very_important = false;
	int show_up_in_tasks_turn_cutoff = 10;
	string title = "";
	int min_turns_until = -1;
	string url = "";
	int importance = 4;
	
	
	if	( from_task && get_property("spookyVHSTapeMonster") != "" ) {
		min_turns_until = (get_property_int("spookyVHSTapeMonsterTurn") + 8) - total_turns_played();
		title = "VHS Wanderer";
		string borderSize = "2px";
		if	( min_turns_until < 3 ) { borderSize = "5px"; importance = -21; }
		description.listAppend("<span style='border:"+borderSize+" solid red;'>"+get_property("spookyVHSTapeMonster")+" in "+min_turns_until+" turns.</span>");
		description.listAppend("<span style='color:black; background-color:yellow; font-size:90%; font-weight:bold;'>(free kill & YR), burn delay?</span>");
		show_up_in_tasks_turn_cutoff = -1;
		CopiedMonstersGenerateDescriptionForMonster(get_property("spookyVHSTapeMonster"), description, very_important, false);
		ChecklistEntry entry = ChecklistEntryMake("__monster "+get_property("spookyVHSTapeMonster"), url, ChecklistSubentryMake(title, "", description), importance);
		task_entries.listAppend(entry);
	}
	
	if (from_task && min_turns_until > show_up_in_tasks_turn_cutoff)
		return;
	if (!from_task && min_turns_until <= show_up_in_tasks_turn_cutoff)
		return;
}





void SCopiedMonstersGenerateResourceForCopyType(ChecklistEntry [int] resource_entries, item shaking_object, string shaking_shorthand_name, string monster_name_property_name)
{
	if	( shaking_object == $item[Spooky VHS Tape] ) {
		//not an actual monster holder...the copy comes as a wanderer 8 turns after this item is used
		//when the copy appears, it will be auto-killed and Yellow-Rayed (no ELY)
		if	( get_property("spookyVHSTapeMonster") == "" ) {
			return;
		}
	}
	else if (shaking_object.available_amount() == 0 && shaking_object != $item[none])
		return;
    
    string url = "inventory.php?ftext=" + shaking_object;
	
	string [int] monster_description;
	string monster_name = "dummy monster";
	if	( monster_name_property_name != "dummy monster" ) {
		//dummy monster b/c mimic egg can actually hold a list of monsters
		monster_name = get_property(monster_name_property_name).HTMLEscapeString();
	}
	
	CopiedMonstersGenerateDescriptionForMonster(monster_name, monster_description, true, true);

	
    
    if (get_auto_attack() != 0)
    {
        url = "account.php?tab=combat";
        monster_description.listAppend("Auto attack is on, disable it?");
    }
	
	//string line = monster_name.capitaliseFirstLetter() + HTMLGenerateIndentedText(monster_description);
	string line = "";
	if	( monster_name != "dummy monster" ) {
		line = HTMLGenerateSpanOfClass(monster_name.capitaliseFirstLetter(), "r_bold");
	}
	if (shaking_shorthand_name == "spooky vhs wanderer") {
		line += " <span style='color:black; background-color:yellow; font-size:90%; font-weight:bold;'>(free kill & YR), burn delay?</span>";
	}
	
    if (monster_description.count() > 0)
        line += "<hr>" + monster_description.listJoinComponents("|");
    
    string image_name = "__item " + shaking_object;
	string additional_info = " monster trapped!";
	if	( monster_name == "dummy monster" ) {
		additional_info = " monster(s) trapped!";
	}
    if (shaking_shorthand_name == "chateau painting")
    {
        image_name = "__item fancy oil painting";
        url = "place.php?whichplace=chateau";
    }
    if (shaking_shorthand_name == "spooky vhs wanderer")
    {
        //image_name = "__item fancy oil painting";
        url = "";
		additional_info = " in "+((get_property_int("spookyVHSTapeMonsterTurn") + 8) - total_turns_played())+" turns";
    }
	
	if (shaking_shorthand_name != "") {
		resource_entries.listAppend(ChecklistEntryMake(image_name, url, ChecklistSubentryMake(shaking_shorthand_name.capitaliseFirstLetter() + additional_info, "", line),-79).ChecklistEntrySetIDTag("Copy item " + shaking_shorthand_name));
	}
}





void SCopiedMonstersGenerateResource(ChecklistEntry [int] resource_entries)
{
    //Sources:
    
    boolean have_spooky_putty = $items[Spooky Putty ball,Spooky Putty leotard,Spooky Putty mitre,Spooky Putty sheet,Spooky Putty snake,Spooky Putty monster].available_amount() > 0;
    
	int copies_used = get_property_int("spookyPuttyCopiesMade") + get_property_int("_raindohCopiesMade");
	int copies_available = MIN(6,5*MIN($items[Spooky Putty ball,Spooky Putty leotard,Spooky Putty mitre,Spooky Putty sheet,Spooky Putty snake,Spooky Putty monster].available_amount(), 1) + 5*MIN($item[Rain-Doh black box].available_amount() + $item[rain-doh box full of monster].available_amount(), 1));
    int copies_left = copies_available - copies_used;
    
    string [int] potential_copies;
    if (!__misc_state["in CS aftercore"])
    {
        //√ghuol whelps, √modern zmobies, √wine racks, √lobsterfrogmen, √ninja assassin
        if (!__quest_state["Level 12"].state_boolean["Lighthouse Finished"] && $item[barrel of gunpowder].available_amount() < 5)
            potential_copies.listAppend("Lobsterfrogman.");
        if (__quest_state["Level 7"].state_boolean["cranny needs speed tricks"])
            potential_copies.listAppend("Swarm of ghuol whelps.");
        if (__quest_state["Level 7"].state_boolean["alcove needs speed tricks"])
            potential_copies.listAppend("Modern zmobies.");
        if (!__quest_state["Level 8"].state_boolean["Mountain climbed"] && $items[frayed ninja rope,loose ninja carabiner,dull ninja crampons].available_amount() == 0 && !have_outfit_components("eXtreme Cold-Weather Gear"))
            potential_copies.listAppend("Ninja assassin.");
		
        if	( $item[Richard's star key].available_amount() == 0 && __misc_state["in run"] ) {
			potential_copies.listAppend("Skinflute.");
			potential_copies.listAppend("Camel's toe.");
		}
        if	( !qprop("questL10Garbage") ) {
			potential_copies.listAppend("Goth giant (candles).");
		}
        if	( !qprop("questL11Pyramid") ) {
			potential_copies.listAppend("Tomb rat.");
		}
        if	( !qprop("questL11Spare") ) {
			potential_copies.listAppend("Pygmy bowler.");
		}
        if	( !qprop("questL11Curses") ) {
			potential_copies.listAppend("Pygmy shaman.");
		}
        if	( !qprop("questL11Business") ) {
			potential_copies.listAppend("Pygmy accountant.");
		}
        if	( !qprop("questL11Doctor") ) {
			potential_copies.listAppend("Pygmy surgeon.");
		}
        if	( !qprop("questL11Manor") ) {
			potential_copies.listAppend("Posessed wine rack");
			potential_copies.listAppend("Cabinet of Dr. Limpienza.");
		}
        if	( !qprop("questL11Ron") ) {
			potential_copies.listAppend("red butler");
			potential_copies.listAppend("blue oyster cultist");
			potential_copies.listAppend("lynyrd and/or lynyrd skinner");
		}
		
		
		//if (!__quest_state["Level 11"].finished && !__quest_state["Level 11 Palindome"].finished && $item[talisman o' namsilat].available_amount() == 0 && $items[gaudy key,snakehead charrrm].available_amount() < 2 && my_path().id != PATH_G_LOVER)
            //potential_copies.listAppend("Gaudy pirate - copy once for extra key."); //now obsolete
        //√baa'baa. astronomer? √nuns trick brigand
        //FIXME astronomer when we can calculate that
        //if (!__quest_state["Level 12"].state_boolean["Nuns Finished"])
            //potential_copies.listAppend("Brigand - nuns trick.");
        //possibly less relevant:
        //√ghosts/skulls/bloopers...?
        //seems very marginal
        //if (!__quest_state["Level 13"].state_boolean["past keys"] && ($item[digital key].available_amount() + creatable_amount($item[digital key])) == 0)
            //potential_copies.listAppend("Ghosts / morbid skulls / bloopers.");
        //bricko bats, if they have bricko...?
        //if (__misc_state["bookshelf accessible"] && $skill[summon brickos].skill_is_usable())
            //potential_copies.listAppend("Bricko bats...?");
    }
    ChecklistEntry copy_source_entry;
    copy_source_entry.tags.id = "Copy options resource";
	if (__misc_state["in run"]) {
		copy_source_entry.importance_level = -50;
	} else {
		copy_source_entry.importance_level = -50;
	}
	
    
    if ( __iotms_usable[$item[Chateau Mantegna room key]] && !get_property_boolean("_chateauMonsterFought") && mafiaIsPastRevision(15115))
    {
        string url = "place.php?whichplace=chateau";
        string header = "Chateau painting copy";
        string [int] description;
        monster current_monster = get_property_monster("chateauMonster");
        
        if (current_monster == $monster[none])
            header += " available";
        else
            header += " fightable";
        
        if (__misc_state["in run"])
        {
            if ($item[alpine watercolor set].available_amount() == 0)
                description.listAppend("Acquire an alpine watercolor set to copy something else.");
            else
                description.listAppend("Copy something else with alpine watercolor set.");
            /*string line;
            if (current_monster == $monster[none])
                line += "Options:";
            else
                line += "Other options:";
            
            if ($item[alpine watercolor set].available_amount() == 0)
            {
                //url = "shop.php?whichshop=chateau";
                line += " (buy alpine watercolor set first)";
            }
            else
                line += " (copy with alpine watercolor set)";
        
            line += "|*" + potential_copies.listJoinComponents("|*");
            description.listAppend(line);*/
        }
        
        if (current_monster != $monster[none])
        {
            string [int] monster_description;
            CopiedMonstersGenerateDescriptionForMonster(current_monster, monster_description, true, true);
            string line = "Current monster: " + HTMLGenerateSpanFont(current_monster.to_string() + ".", "red");
            if (monster_description.count() > 0)
                line += "|*" + monster_description.listJoinComponents("|*");
            description.listPrepend(line);
        }
		//resource_entries.listAppend(ChecklistEntryMake("__item fancy oil painting", url, ChecklistSubentryMake(header, "", description)));
        
        
        copy_source_entry.subentries.listAppend(ChecklistSubentryMake(header, "", description));
        if (copy_source_entry.image_lookup_name == "")
            copy_source_entry.image_lookup_name = "__item fancy oil painting";
        if (copy_source_entry.url == "")
            copy_source_entry.url = "place.php?whichplace=chateau";
    }
	if (copies_left > 0)
	{
		string [int] copy_source_list;
		if (have_spooky_putty)
            copy_source_list.listAppend("spooky putty");
		if ($item[Rain-Doh black box].available_amount() + $item[rain-doh box full of monster].available_amount() > 0)
            copy_source_list.listAppend("rain-doh black box");
        
		string copy_sources = copy_source_list.listJoinComponents("/");
		string name = "";
		//FIXME make this possibly say which one in the case of 6 (does that matter? how does that mechanic work?)
		name = pluralise(copies_left, copy_sources + " copy", copy_sources + " copies") + " left";
		string [int] description;// = potential_copies;
        
		//resource_entries.listAppend(ChecklistEntryMake(copy_source_list[0], "", ChecklistSubentryMake(name, "", description)));
        
        copy_source_entry.subentries.listAppend(ChecklistSubentryMake(name, "", description));
        if (copy_source_entry.image_lookup_name == "")
            copy_source_entry.image_lookup_name = copy_source_list[0];
	}
	if (__misc_state["fax available"] && $item[photocopied monster].available_amount() == 0) {
        copy_source_entry.subentries.listAppend(ChecklistSubentryMake(pluralise(1, "fax machine fight", "fax machine fights") + " available", "", ""));
	}
    if (!get_property_boolean("_cameraUsed") && $item[4-d camera].available_amount() > 0)
    {
		//resource_entries.listAppend(ChecklistEntryMake("__item 4-d camera", "", ChecklistSubentryMake("4-d camera copy available", "", potential_copies)));
        
        copy_source_entry.subentries.listAppend(ChecklistSubentryMake("4-d camera copy available", "", ""));
        if (copy_source_entry.image_lookup_name == "")
            copy_source_entry.image_lookup_name = "__item 4-d camera";
    }
    if (!get_property_boolean("_iceSculptureUsed") && $item[unfinished ice sculpture].available_amount() > 0)
    {
		//resource_entries.listAppend(ChecklistEntryMake("__item unfinished ice sculpture", "", ChecklistSubentryMake("Ice sculpture copy available", "", potential_copies)));
        
        copy_source_entry.subentries.listAppend(ChecklistSubentryMake("Ice sculpture copy available", "", ""));
        if (copy_source_entry.image_lookup_name == "")
            copy_source_entry.image_lookup_name = "__item unfinished ice sculpture";
    }
    if ($item[sticky clay homunculus].available_amount() > 0)
    {
		//resource_entries.listAppend(ChecklistEntryMake("__item sticky clay homunculus", "", ChecklistSubentryMake(pluralise($item[sticky clay homunculus].available_amount(), "sticky clay copy", "sticky clay copies") + " available", "", "Unlimited/day.")));
        
        copy_source_entry.subentries.listAppend(ChecklistSubentryMake(pluralise($item[sticky clay homunculus].available_amount(), "sticky clay copy", "sticky clay copies") + " available", "", "Unlimited/day."));
        if (copy_source_entry.image_lookup_name == "")
            copy_source_entry.image_lookup_name = "__item sticky clay homunculus";
    }
    if ($item[print screen button].available_amount() > 0)
    {
        copy_source_entry.subentries.listAppend(ChecklistSubentryMake(pluralise($item[print screen button].available_amount(), "print screen copy", "print screen copies") + " available", "", ""));
        if (copy_source_entry.image_lookup_name == "")
            copy_source_entry.image_lookup_name = "__item print screen button";
    }
    if (lookupItem("cloning kit").available_amount() > 0)
    {
        copy_source_entry.subentries.listAppend(ChecklistSubentryMake(pluralise($item[cloning kit].available_amount(), "cloning kit", "cloning kits") + " available", "", ""));
        if (copy_source_entry.image_lookup_name == "")
            copy_source_entry.image_lookup_name = "__item cloning kit";
    }
    if ($item[LOV Enamorang].available_amount() > 0)
    {
        copy_source_entry.subentries.listAppend(ChecklistSubentryMake(pluralise($item[LOV Enamorang].available_amount(), "LOV Enamorang", "LOV Enamorangs")+"","",""));
        if (copy_source_entry.image_lookup_name == "")
            copy_source_entry.image_lookup_name = "__item lov enamorang";
    }
    if ($item[Spooky VHS Tape].available_amount() > 0)
    {
        copy_source_entry.subentries.listAppend(ChecklistSubentryMake(pluralise($item[Spooky VHS Tape].available_amount(), "Spooky VHS Tape", "Spooky VHS Tapes")+"<br><span style='color:gray; font-size:75%; font-weight:normal;'>(1 wanderer in 8 turns, insta-killed & Y-rayed)</span>","",""));
        if (copy_source_entry.image_lookup_name == "")
            copy_source_entry.image_lookup_name = "__item Spooky VHS Tape";
    }
	if	( is_unrestricted($item[Spooky VHS Tape]) && get_property_int("availableMrStore2002Credits") > 0 )
	{
        copy_source_entry.subentries.listAppend(ChecklistSubentryMake(get_property_int("availableMrStore2002Credits")+" Spooky VHS Tape(s) purchasable","",""));
        if (copy_source_entry.image_lookup_name == "")
            copy_source_entry.image_lookup_name = "__item 2002 Mr. Store Catalog";
	}
    if (!get_property_boolean("_crappyCameraUsed") && $item[crappy camera].available_amount() > 0)
    {
        string [int] description;// = listCopy(potential_copies);
        description.listPrepend("50% success rate");
		//resource_entries.listAppend(ChecklistEntryMake("__item crappy camera", "", ChecklistSubentryMake("Crappy camera copy available", "", description)));
        copy_source_entry.subentries.listAppend(ChecklistSubentryMake("Crappy camera copy available", "", description));
        if (copy_source_entry.image_lookup_name == "")
            copy_source_entry.image_lookup_name = "__item crappy camera";
    }
	
    if (__iotms_usable[lookupItem("backup camera")] && get_property_int("_backUpUses") < 11)
    {
        int pix_taken = get_property_int("_backUpUses");
		int pix_left = 11 - pix_taken;
		copy_source_entry.subentries.listAppend(ChecklistSubentryMake(pluralise(pix_left, "backup camera use", "backup camera uses") + "", "", ""));
        if (copy_source_entry.image_lookup_name == "")
            copy_source_entry.image_lookup_name = "__item backup camera";
    }
	//_monstersMapped
    if ($skill[Map the Monsters].skill_is_usable() && get_property_int("_monstersMapped") < 3)
    {
        int maps_taken = get_property_int("_monstersMapped");
		int maps_left = 3 - maps_taken;
		copy_source_entry.subentries.listAppend(ChecklistSubentryMake(pluralise(maps_left, "cast of Map the Monsters", "casts of Map the Monsters") + "", "", ""));
        if (copy_source_entry.image_lookup_name == "")
            copy_source_entry.image_lookup_name = "__skill Map the Monsters";
    }
    //combat lover's locket		_locketMonstersFought = comma separated list of monster id's
	string[int] lmf = split_string(get_property("_locketMonstersFought"),",");
	int monstersReminisced = count(lmf);
	if	( get_property("_locketMonstersFought") == "" ) { monstersReminisced = 0; }
	int usesRemaining = 3 - monstersReminisced;
    if (__iotms_usable[lookupItem("combat lover's locket")] && usesRemaining > 0)
    {
		copy_source_entry.subentries.listAppend(ChecklistSubentryMake(pluralise(usesRemaining, "combat lover's locket fight", "combat lover's locket fights") + "", "", ""));
        if (copy_source_entry.image_lookup_name == "")
            copy_source_entry.image_lookup_name = "__item combat lover's locket";
    }
	//_genieFightsUsed
    if (get_property_int("_genieFightsUsed") < 3 && is_unrestricted($item[pocket wish]) && available_amount($item[pocket wish]) > 0 )
    {
		int gf = 3 - get_property_int("_genieFightsUsed");
		int pw = item_amount($item[pocket wish]);
		
		if	( !get_property_boolean("kingLiberated") ) {
			gf = min(gf,pw);
		}
		copy_source_entry.subentries.listAppend(ChecklistSubentryMake(pluralise(gf, "genie/wish fight", "genie/wish fights") + " <span style='color:gray; font-size:75%; font-weight:bold;'>("+pw+" pocket wishes)</span>", "", ""));
        if (copy_source_entry.image_lookup_name == "")
            copy_source_entry.image_lookup_name = "__item pocket wish";
    }
	//beGregariousCharges
	int greg_copies = 3 * get_property_int("beGregariousCharges");
	if	( get_property_int("beGregariousCharges") > 0 && greg_copies > 0 ) {
		copy_source_entry.subentries.listAppend(ChecklistSubentryMake(pluralise(greg_copies, "copies via Be Gregarious", "copies via Be Gregarious") + "", "", ""));
        if (copy_source_entry.image_lookup_name == "")
            copy_source_entry.image_lookup_name = "__item physiostim pill";
	}
	if	( get_property_int("beGregariousFightsLeft") > 0 ) {
		copy_source_entry.subentries.listAppend(ChecklistSubentryMake(get_property_int("beGregariousFightsLeft")+" gregarious fight(s) vs <span style='color:red; font-size:75%; font-weight:bold;'>"+get_property("beGregariousMonster")+"</span> remain", "", ""));
        if (copy_source_entry.image_lookup_name == "")
            copy_source_entry.image_lookup_name = "__item physiostim pill";
	}
	//Extrovermectin  __iotms_usable[lookupItem("cold medicine cabinet")] && 
    if (available_amount($item[Extrovermectin&trade;]) > 0 && spleen_limit() - my_spleen_use() >= 2 )
    {
		copy_source_entry.subentries.listAppend(ChecklistSubentryMake(pluralise(available_amount($item[Extrovermectin&trade;]), "Extrovermectin&trade; pill", "Extrovermectin&trade; pills") + "", "", "|*3 wandering copies for 2 spleen|*(via casting be gregarious)"));
        if (copy_source_entry.image_lookup_name == "")
            copy_source_entry.image_lookup_name = "__item cold medicine cabinet";
    }
	//_cargoPocketEmptied
    if (__iotms_usable[lookupItem("Cargo Cultist Shorts")] && !get_property_boolean("_cargoPocketEmptied"))
    {
		copy_source_entry.subentries.listAppend(ChecklistSubentryMake(pluralise(1, "cargo pocket fight is possible", "") + "", "", ""));
        if (copy_source_entry.image_lookup_name == "")
            copy_source_entry.image_lookup_name = "__item cargo cultist shorts";
    }
	//chest mimic
	if	( $familiar[chest mimic].familiar_is_usable() && $familiar[chest mimic].experience > 50 ) {
		int chestCopiesAvailable = ($familiar[chest mimic].experience.to_float() / 50.0).to_int();
		int chestCopiesLimit = 11 - get_property_int("_mimicEggsObtained");
		chestCopiesAvailable = min(chestCopiesAvailable, chestCopiesLimit);
		copy_source_entry.subentries.listAppend(ChecklistSubentryMake(pluralise(chestCopiesAvailable, "chest mimic copy is possible", "chest mimic copies are possible") + "", "", ""));
        if (copy_source_entry.image_lookup_name == "")
            copy_source_entry.image_lookup_name = "__familiar chest mimic";
            //copy_source_entry.image_lookup_name = "__skill %fn, lay an egg";
	}
	//patriotic eagle
	if	( $familiar[patriotic eagle].familiar_is_usable() && have_effect($effect[Everything Looks Red, White and Blue]) == 0 ) {
		copy_source_entry.subentries.listAppend(ChecklistSubentryMake(pluralise(1, "red, white & blue blast&nbsp;&nbsp;(2 immediate copies)", "") + "", "", ""));
        if (copy_source_entry.image_lookup_name == "")
            copy_source_entry.image_lookup_name = "__familiar patriotic eagle";
            //copy_source_entry.image_lookup_name = "__skill Recall Facts: Monster Habitats";
	}
	//habitat recalls, book of facts, Just the Facts
	if	(skill_is_usable($skill[Just the Facts]) && get_property_int("_monsterHabitatsRecalled") < 3 ) {
		int jtfCastsLeft = 3 - get_property_int("_monsterHabitatsRecalled");
		copy_source_entry.subentries.listAppend(ChecklistSubentryMake(pluralise(jtfCastsLeft, "cast of habitat recall", "casts of habitat recall") + "&nbsp;&nbsp;(6 wandering copies)", "", ""));
        if (copy_source_entry.image_lookup_name == "")
            copy_source_entry.image_lookup_name = "__item book of facts";
	}
	
	//waffle, replace monster (eg power glove ~ replace enemy, macrometeor)
	if	( is_unrestricted($item[waffle]) && $item[waffle].available_amount() > 0 ) {
		copy_source_entry.subentries.listAppend(ChecklistSubentryMake(pluralise($item[waffle].available_amount(), "waffle replacement monster", "waffle replacement monsters") + "", "", ""));
        if (copy_source_entry.image_lookup_name == "")
            copy_source_entry.image_lookup_name = "__item waffle";
	}
	
	
	
	string[int] dummy;
	dummy[0] = "dummy entry";
	int seidx = 1;
	foreach s in copy_source_entry.subentries {
		dummy[seidx] = s;
		seidx++;
	}
	
    if (copy_source_entry.subentries.count() > 0)
    {
        ChecklistSubentry last_subentry = copy_source_entry.subentries[copy_source_entry.subentries.count() - 1];
        if (last_subentry.entries.count() > 0 && potential_copies.count() > 0)
        {
            copy_source_entry.subentries.listAppend(ChecklistSubentryMake("Potential targets:", "", potential_copies));
        }
        else
            last_subentry.entries.listAppendList(potential_copies);
        resource_entries.listAppend(copy_source_entry);
    }
	
	generateCopiedMonstersEntry(resource_entries, resource_entries, false);
	
	SCopiedMonstersGenerateResourceForCopyType(resource_entries, $item[Rain-Doh box full of monster], "rain doh", "rainDohMonster");
	SCopiedMonstersGenerateResourceForCopyType(resource_entries, $item[spooky putty monster], "spooky putty", "spookyPuttyMonster");
    if (!get_property_boolean("_cameraUsed"))
        SCopiedMonstersGenerateResourceForCopyType(resource_entries, $item[shaking 4-d camera], "shaking 4-d camera", "cameraMonster");
    if (!get_property_boolean("_crappyCameraUsed"))
        SCopiedMonstersGenerateResourceForCopyType(resource_entries, $item[shaking crappy camera], "shaking crappy camera", "crappyCameraMonster");
	if (!get_property_boolean("_photocopyUsed"))
		SCopiedMonstersGenerateResourceForCopyType(resource_entries, $item[photocopied monster], "photocopied", "photocopyMonster");
	if (!get_property_boolean("_envyfishEggUsed"))
		SCopiedMonstersGenerateResourceForCopyType(resource_entries, $item[envyfish egg], "envyfish egg", "envyfishMonster");
	if (!get_property_boolean("_iceSculptureUsed"))
		SCopiedMonstersGenerateResourceForCopyType(resource_entries, $item[ice sculpture], "ice sculpture", "iceSculptureMonster");
    SCopiedMonstersGenerateResourceForCopyType(resource_entries, $item[wax bugbear], "wax bugbear", "waxMonster");
    SCopiedMonstersGenerateResourceForCopyType(resource_entries, $item[crude monster sculpture], "crude sculpture", "crudeMonster");
    SCopiedMonstersGenerateResourceForCopyType(resource_entries, $item[screencapped monster], "screencapped", "screencappedMonster");
    SCopiedMonstersGenerateResourceForCopyType(resource_entries, $item[mimic egg], "mimic egg", "dummy monster");
    SCopiedMonstersGenerateResourceForCopyType(resource_entries, $item[Spooky VHS Tape], "spooky vhs wanderer", "spookyVHSTapeMonster");
}




void SCopiedMonstersGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	generateCopiedMonstersEntry(task_entries, optional_task_entries, true);
	
}