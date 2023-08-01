string[int] eagle30item;
string[int] eagle50meat;

void populateEagleCitizenshipMaps() {
	int ix = 0;
	clear(eagle30item);
	foreach s in $strings[
		The Bat Hole Entrance,
		Cobb's Knob Laboratory,
		The Valley of Rof L'm Fao,
		Whitey's Grove,
		The Icy Peak,
		Belowdecks,
		An Octopus's Garden,
		Mer-kin Colosseum,
		Noob Cave,
		Cobb's Knob Treasury,
		Itznotyerzitz Mine,
		The Hidden Temple,
		Dreadsylvanian Castle,
		The Haunted Library,
		The Haunted Laundry Room,
		Madness Bakery,
		LavaCo™ Lamp Factory,
		The X-32-F Combat Training Snowman,
		Gingerbread Upscale Retail District,
		Default (no zone chosen),
	] {
		eagle30item[ix] = s;
		ix++;
	}

	ix = 0;
	clear(eagle50meat);
	foreach s in $strings[
	The Batrat and Ratbat Burrow,
	Cobb's Knob Menagerie\, Level 2,
	The Dire Warren,
	The Sleazy Back Alley,
	An Oasis,
	The Laugh Floor,
	Lair of the Ninja Snowmen,
	The Castle in the Clouds in the Sky (Basement),
	The Hidden Hospital,
	The Haunted Bathroom,
	The Fun-Guy Mansion,
	Barf Mountain,
	] {
		eagle50meat[ix] = s;
		ix++;
	}
}


//Patriotic Eagle
RegisterTaskGenerationFunction("IOTMPatrioticEagleGenerateTasksTEMP");
void IOTMPatrioticEagleGenerateTasksTEMP(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	if (!lookupFamiliar("Patriotic Eagle").familiar_is_usable()) return;

	if	( count(eagle30item) == 0 || count(eagle50meat) == 0 ) {
		populateEagleCitizenshipMaps();
	}
	
	int sgeeaa = $item[soft green echo eyedrop antidote].available_amount();
	
	eagle50meat[count(eagle50meat)] = "<a href='https://docs.google.com/spreadsheets/d/1jJhgityF_MS_Ohna6VePJ4IVXNAzrHIieqlST49C-SU/edit#gid=2131678522' target='_blank'><span style='color:blue; font-size:100%;'>Zones.</span></a>";
	
	
	ChecklistSubentry [int] lists;
	lists.listAppend(ChecklistSubentryMake(HTMLGenerateSpanOfStyle("Citizen of Zone is removable. sgeea ("+sgeeaa+")", "font-size:75%") + "<br>" + HTMLGenerateSpanOfStyle("Curr mods: "+get_property("_citizenZoneMods"), "font-size:75%")));
	lists.listAppend(ChecklistSubentryMake("+30% items", "", eagle30item));
	lists.listAppend(ChecklistSubentryMake("+50% meat", "", eagle50meat));
	ChecklistSubentry [int] descs;
	
	ChecklistEntry entry;
	entry.image_lookup_name = "__familiar patriotic eagle";
	entry.url = "familiar.php";
	entry.tags.id = "Patriotic Eagle familiar task";
	entry.importance_level = -2;
	entry.subentries_on_mouse_over = lists;


    //optional_task_entries
	monster RWB_monster = get_property_monster("rwbMonster");
    if (RWB_monster != $monster[none]) {
        int fights_left = clampi(get_property_int("rwbMonsterCount"), 0, 2);
        location [int] possible_appearance_locations = RWB_monster.getPossibleLocationsMonsterCanAppearInNaturally().listInvert();
        
        if (fights_left > 0 && possible_appearance_locations.count() > 0)
            optional_task_entries.listAppend(ChecklistEntryMake("__monster " + RWB_monster, possible_appearance_locations[0].getClickableURLForLocation(), ChecklistSubentryMake("Fight " + pluralise(fights_left, "more " + RWB_monster, "more " + RWB_monster + "s"), "", "Will appear when you adventure in " + possible_appearance_locations.listJoinComponents(", ", "or") + "."), -1).ChecklistEntrySetIDTag("RWB copies"));
    }
	
	//task_entries
    if (
			get_property("_citizenZone") == ""
			|| $effect[Citizen of A Zone].have_effect() == 0
			|| ( get_property("sidequestNunsCompleted") == "none" && my_location() == $location[The Themthar Hills] && sgeeaa > 0 )
		) {
		string [int] description; 
		//description.listAppend(HTMLGenerateSpanOfClass("+30% Item:", "r_bold") + " Haunted Library, Haunted Laundry");
		//description.listAppend(HTMLGenerateSpanOfClass("+50% Meat:", "r_bold") + " Ninja Snowmen, Hidden Hospital");
		description.listAppend(HTMLGenerateSpanOfStyle("=== Hover mouse for info ===", "font-size:0.8em;color:red"));
		
		
		
		descs.listAppend(ChecklistSubentryMake("Eagle can Pledge Allegiance", "", description));
		entry.subentries = descs;
		entry.importance_level = -10;
		
		task_entries.listAppend(entry);
	}
	
	if	( get_property("banishedPhyla").index_of("Patriotic Screech") > -1 ) {
		string[int] prop_parts = split_string(get_property("banishedPhyla"), ":");
		string banishedPhylumStr = "";
		foreach i, s in prop_parts {
			if	( s == "Patriotic Screech" ) {
				banishedPhylumStr = prop_parts[i - 1];
			}
		}
		string [int] description2;
		if	( banishedPhylumStr != "" ) {
			if	( get_property_int("screechCombats") > 0 ) {
				description2.listAppend(HTMLGenerateSpanOfStyle(get_property_int("screechCombats")+" fights before Eagle can screech again.", "color:red"));
			} else {
				description2.listAppend(HTMLGenerateSpanOfStyle("Eagle can screech again.", "color:green"));
			}
			task_entries.listAppend(ChecklistEntryMake("__skill Singer's Faithful Ocelot", "familiar.php", ChecklistSubentryMake("Banned phylum: "+ HTMLGenerateSpanOfStyle(banishedPhylumStr, "color:red"), "", description2), -10).ChecklistEntrySetIDTag("Banned Phyla"));
		//__item ketchup hound
		}
	}
}

RegisterResourceGenerationFunction("IOTMPatrioticEagleGenerateResourceTEMP");
void IOTMPatrioticEagleGenerateResourceTEMP(ChecklistEntry [int] resource_entries)
{
    if (!lookupFamiliar("Patriotic Eagle").familiar_is_usable()) return;
	int screechRecharge = get_property_int("screechCombats");
	string title;
    string [int] description;
    
    if (screechRecharge > 0) {
        title = (screechRecharge + " combats until Patriotic Eagle can screech again.");
    } else {
        //title = "Patriotic Eagle can screech and banish an entire phylum!";
        title = HTMLGenerateSpanFont("Patriotic ", "red") + HTMLGenerateSpanFont("Eagle ", "grey") + HTMLGenerateSpanFont("can screech.", "blue");
        //description.listAppend(HTMLGenerateSpanFont("SCREEEE", "red") + HTMLGenerateSpanFont("EEEEE", "grey") + HTMLGenerateSpanFont("EEEEE!,", "blue"));
        description.listAppend("Banish an entire phylum!");
    }
    
	if ($effect[Citizen of A Zone].have_effect() == 0) {
        description.listAppend(HTMLGenerateSpanFont("Pledge ", "red") + HTMLGenerateSpanFont("allegiance ", "grey") + HTMLGenerateSpanFont("to a zone!", "blue"));
		description.listAppend(HTMLGenerateSpanOfClass("+30% Item:", "r_bold") + " Haunted Library, Haunted Laundry");
		description.listAppend(HTMLGenerateSpanOfClass("+50% Meat:", "r_bold") + " Ninja Snowmen, Hidden Hospital");
		description.listAppend(HTMLGenerateSpanOfClass("Citizen of Zone effect can be removed.", "r_bold") + "");
		description.listAppend(HTMLGenerateSpanOfClass("<a href='https://docs.google.com/spreadsheets/d/1jJhgityF_MS_Ohna6VePJ4IVXNAzrHIieqlST49C-SU/edit#gid=2131678522' target='_blank'><span style='color:blue; font-size:100%;'>Zones.</span></a>", "r_bold") + "");
	}
	
    string [int] options;
    #if (__misc_state["in run"] && my_path().id != PATH_COMMUNITY_SERVICE) 
	{
        options.listAppend(HTMLGenerateSpanOfClass("Dude:", "r_bold") + " Black Forest 2/5, Twin Peak 5/8, Whitey's Grove 1/4");
        options.listAppend(HTMLGenerateSpanOfClass("Beast:", "r_bold") + " Hidden Park 1/4, Palindome 3/7, Airship 2/7");
		options.listAppend(HTMLGenerateSpanOfClass("Construct:", "r_bold") + " Billiards Room 1/2, Whitey's Grove 1/4, Airship 1/7, Oasis 1/5");
		options.listAppend(HTMLGenerateSpanOfClass("Undead:", "r_bold") + " Haunted Library 1/3, Red Zeppelin 1/5, Haunted Wine Cellar 1/3, Haunted Boiler 1/3, Pyramid Middle 1/3");
    }
    if (options.count() > 0)
        description.listAppend("Screech targets:" + options.listJoinComponents("<hr>").HTMLGenerateIndentedText());
    
	if ($effect[Citizen of A Zone].have_effect() > 0) {
		if	( get_property("_aaa_guideCitizenship") != today_to_string() ) {
			visit_url("desc_effect.php?whicheffect=9391a5f7577e30ac3af6309804da6944");
			set_property("_aaa_guideCitizenship", today_to_string());
		}
		description.listAppend(HTMLGenerateSpanOfClass("Citizen of Zone effect can be removed.", "r_bold") + "");
		description.listAppend(HTMLGenerateSpanOfClass("<a href='https://docs.google.com/spreadsheets/d/1jJhgityF_MS_Ohna6VePJ4IVXNAzrHIieqlST49C-SU/edit#gid=2131678522' target='_blank'><span style='color:blue; font-size:100%;'>Zones.</span></a>", "r_bold") + "");
		description.listAppend(HTMLGenerateSpanOfClass("Citizen of: ", "r_bold") + "<span style='color:blue; font-size:90%; font-weight:bold;'>"+get_property("_citizenZone")+"</span>");
		description.listAppend(HTMLGenerateSpanOfClass("Mods: ", "r_bold") + HTMLGenerateSpanFont(get_property("_citizenZoneMods"), "red"));
	}
	
	
    resource_entries.listAppend(ChecklistEntryMake("__familiar Patriotic Eagle", "familiar.php", ChecklistSubentryMake(title, description), -9).ChecklistEntrySetIDTag("Patriotic Eagle familiar resource"));
}