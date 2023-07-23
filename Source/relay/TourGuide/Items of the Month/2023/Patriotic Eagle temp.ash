//Patriotic Eagle
RegisterTaskGenerationFunction("IOTMPatrioticEagleGenerateTasksTEMP");
void IOTMPatrioticEagleGenerateTasksTEMP(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	if (!lookupFamiliar("Patriotic Eagle").familiar_is_usable()) return;

    monster RWB_monster = get_property_monster("rwbMonster");
    if (RWB_monster != $monster[none]) {
        int fights_left = clampi(get_property_int("rwbMonsterCount"), 0, 2);
        location [int] possible_appearance_locations = RWB_monster.getPossibleLocationsMonsterCanAppearInNaturally().listInvert();
        
        if (fights_left > 0 && possible_appearance_locations.count() > 0)
            optional_task_entries.listAppend(ChecklistEntryMake("__monster " + RWB_monster, possible_appearance_locations[0].getClickableURLForLocation(), ChecklistSubentryMake("Fight " + pluralise(fights_left, "more " + RWB_monster, "more " + RWB_monster + "s"), "", "Will appear when you adventure in " + possible_appearance_locations.listJoinComponents(", ", "or") + "."), -1).ChecklistEntrySetIDTag("RWB copies"));
    }
	
    if (get_property("_citizenZone") == "" ) {
		string [int] description;
		description.listAppend(HTMLGenerateSpanOfClass("+30% Item:", "r_bold") + " Haunted Library, Haunted Laundry");
		description.listAppend(HTMLGenerateSpanOfClass("+50% Meat:", "r_bold") + " Ninja Snowmen, Hidden Hospital");
		description.listAppend(HTMLGenerateSpanOfClass("Citizen of Zone effect can be removed.", "r_bold") + "");
		description.listAppend(HTMLGenerateSpanOfClass("<a href='https://docs.google.com/spreadsheets/d/1jJhgityF_MS_Ohna6VePJ4IVXNAzrHIieqlST49C-SU/edit#gid=2131678522' target='_blank'><span style='color:blue; font-size:100%;'>Zones.</span></a>", "r_bold") + "");
		
		task_entries.listAppend(ChecklistEntryMake("__familiar patriotic eagle", "familiar.php", ChecklistSubentryMake("Pledge citizenship! ", "", description), -11).ChecklistEntrySetIDTag("Patriotic Eagle familiar task"));
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
		description.listAppend(HTMLGenerateSpanOfClass("Citizen of: : ", "r_bold") + "<span style='color:blue; font-size:90%; font-weight:bold;'>"+get_property("_citizenZone")+"</span>");
		description.listAppend(HTMLGenerateSpanOfClass("Mods: ", "r_bold") + HTMLGenerateSpanFont(get_property("_citizenZoneMods"), "red"));
	}
	
	
    resource_entries.listAppend(ChecklistEntryMake("__familiar Patriotic Eagle", "familiar.php", ChecklistSubentryMake(title, description), -9).ChecklistEntrySetIDTag("Patriotic Eagle familiar resource"));
}