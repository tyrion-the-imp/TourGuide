//Autumnaton
RegisterTaskGenerationFunction("IOTMAutumnatonGenerateTasks");
void IOTMAutumnatonGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	# if (!__misc_state["in run"]) return; // Turned off because TES likes this tile to appear in aftercore
	if (!get_property_boolean("hasAutumnaton")) return; // Don't show if they don't actually have Fall-E
	if (my_path() == $path[Legacy of Loathing]) return; // Cannot use fall-e in LoL
    if (my_path().id == PATH_G_LOVER) return; // Cannot use fall-e in G-Lover 

	int autobotsToday = get_property_int("_autumnatonQuests");
	int turncountWhereAutobotReturns = get_property_int("autumnatonQuestTurn");
	
	if (get_property("autumnatonUpgrades").contains_text("leftleg1")) {
		autobotsToday -= 1;
	} 
	if (get_property("autumnatonUpgrades").contains_text("rightleg1")) {
		autobotsToday -= 1;
	}
	
	int autobotsReturnTime = autobotsToday;

	if (autobotsToday < 1) {
		autobotsReturnTime = 11;
	}
	else {
		autobotsReturnTime = autobotsToday * 11;
	}
	
	string url;
	string [int] description;
	string [int] [int] targets;

	description.listAppend("Autobot grabs items from a zone you've previously visited.");
	
	// Autobot on expedition
	if (lookupItem("autumn-aton").available_amount() > 0 && autobotsReturnTime < 66 )
	{
		string main_title = "Use your autumn-aton";
		description.listAppend("Next use will take " + HTMLGenerateSpanOfClass(autobotsReturnTime, "r_bold") + " adventures.");
		task_entries.listAppend(ChecklistEntryMake("__item autumn-aton", "inv_use.php?pwd=" + my_hash() + "&whichitem=10954", ChecklistSubentryMake(main_title, "", description), -11));
	}
	else if (turncountWhereAutobotReturns > total_turns_played()) 
	{
		string main_title = "Autumn-aton on a mission";
		string autobotZone = get_property("autumnatonQuestLocation");
		description.listAppend("Will return in " + HTMLGenerateSpanOfClass(turncountWhereAutobotReturns +1 - total_turns_played(), "r_bold") + " adventures.");
		description.listAppend(HTMLGenerateSpanOfClass("Currently exploring: ", "r_bold") + autobotZone);
		optional_task_entries.listAppend(ChecklistEntryMake("__item autumn-aton", url, ChecklistSubentryMake("Autumn-aton on a mission", description), 8));
	}
	else if ( (turncountWhereAutobotReturns -1) == total_turns_played() )
	{
		string main_title = "Autumn-aton returns <span style='color:red; font-size:100%; font-weight:bold;'>next adventure</span>";
		string autobotZone = get_property("autumnatonQuestLocation");
		description.listAppend("Next mission takes " + HTMLGenerateSpanOfClass(autobotsReturnTime, "r_bold") + " adventures.");
		description.listAppend(HTMLGenerateSpanOfClass("Currently exploring: ", "r_bold") + autobotZone);
		task_entries.listAppend(ChecklistEntryMake("__item autumn-aton", url, ChecklistSubentryMake(main_title, description), -11));
	}

	if (!get_property("autumnatonUpgrades").contains_text("cowcatcher")) {
		description.listAppend("Visit mid underground for +1 autumn item (Cyrpt zone, Daily Dungeon?)");
	}
	if (!get_property("autumnatonUpgrades").contains_text("leftarm1")) {
		description.listAppend("Visit low indoor for +1 item (Haunted Pantry?)");
	}
	if (!get_property("autumnatonUpgrades").contains_text("rightarm1")) {
		description.listAppend("Visit mid outdoor for +1 item (Smut Orc Camp?)");
	}
	if (!get_property("autumnatonUpgrades").contains_text("leftleg1")) {
		description.listAppend("Visit low underground for -11 cooldown (Ratbats?)");
	}
	if (!get_property("autumnatonUpgrades").contains_text("rightleg1")) {
		description.listAppend("Visit mid indoor for -11 cooldown (Haunted Library?)");
	}
	
	if (__misc_state["in run"] && my_path().id != 25)
	{
		if (locationAvailable($location[sonofa beach]) == true && available_amount($item[barrel of gunpowder]) < 5 && get_property("sidequestLighthouseCompleted") == "none" )
		{
			int xbog = ( get_property("sidequestLighthouseCompleted") == "none" ) ? 5 - item_amount($item[barrel of gunpowder]):0;
			targets.listAppend(listMake("barrel of gunpowder (need "+xbog+")","Sonofa Beach"));
		}
		if (locationAvailable($location[The Castle in the Clouds in the Sky (Top Floor)]) == true && available_amount($item[thin black candle]) < 3 && available_amount($item[scroll of ancient forbidden unspeakable evil]) > 0 && get_property("sidequestNunsCompleted") == "none" )
		{
			int xbog = ( get_property("sidequestNunsCompleted") == "none" ) ? 3 - item_amount($item[thin black candle]):0;
			targets.listAppend(listMake("thin black candle (need "+xbog+")","Castle (Top Floor)"));
		}
		if (locationAvailable($location[twin peak]) == false && get_property_int("chasmBridgeProgress") < 30 && !qprop("questL09Topping"))
		{
			targets.listAppend(listMake("bridge parts", "The Smut Orc Logging Camp"));
		}
		if (get_property_int("hiddenBowlingAlleyProgress") + available_amount($item[bowling ball]) < 6)
		{
			int ballsNeeded = ( get_property_int("hiddenBowlingAlleyProgress") < 2 ) ? ( 5 - $item[bowling ball].available_amount() ):( 5 - get_property_int("hiddenBowlingAlleyProgress") + 1 - $item[bowling ball].available_amount() );
			ballsNeeded = max(ballsNeeded, 0);
			targets.listAppend(listMake("bowling balls (need "+ballsNeeded+")","Hidden Bowling Alley"));
		}
		if (get_property_int("twinPeakProgress") < 14 && !qprop("questL09Topping") && !get_property_boolean("oilPeakLit"))
		{
			targets.listAppend(listMake("bubblin' crude", "Oil Peak"));
		}
		// gnasirProgress is a weird property, please read the mafia wiki for clarification:
		// https://wiki.kolmafia.us/index.php/Quest_Tracking_Preferences#gnasirProgress
		if (get_property_int("desertExploration") < 100 && available_amount($item[killing jar]) < 1 && (get_property_int("gnasirProgress") & 4) == 0)
		{
			targets.listAppend(listMake("killing jar", "The Haunted Library"));
		}
		if (locationAvailable($location[the oasis]) == true && get_property_int("desertExploration") < 100 && available_amount($item[drum machine]) == 0 && !qprop("questL11Desert"))
		{
			targets.listAppend(listMake("drum machine", "An Oasis"));
		}
		if (__quest_state["Level 11 Ron"].mafia_internal_step < 5)
		{
			targets.listAppend(listMake("glark cables", "The Red Zeppelin"));
		}
		if (targets.count() > 0)
		{
			buffer tooltip_text;
			tooltip_text.append(HTMLGenerateTagWrap("div", "Potential Targets", mapMake("class", "r_bold r_centre", "style", "padding-bottom:0.25em;")));
			tooltip_text.append(HTMLGenerateSimpleTableLines(targets));
			string potentialTargets = HTMLGenerateSpanOfClass(HTMLGenerateSpanOfClass(tooltip_text, "r_tooltip_inner_class r_tooltip_inner_class_margin") + "Potential Autumnaton Targets <span style='color:red; font-size:80%; font-weight:bold;'>(hover to see)</span>", "r_tooltip_outer_class");
			description.listAppend(potentialTargets);
		}	
	}
}
