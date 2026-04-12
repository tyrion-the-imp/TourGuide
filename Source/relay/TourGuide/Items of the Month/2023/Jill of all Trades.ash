RegisterTaskGenerationFunction("IOTMJillMapGenerateTask");
void IOTMJillMapGenerateTask(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries) {

    boolean mapAvailable = ($item[map to a candy-rich block].available_amount() > 0);

    // Don't generate a tile if the user doesn't have a map.
    if (!mapAvailable) return;

    boolean usedMap = get_property_boolean("_mapToACandyRichBlockUsed");	

    // Populate a free fights count of trick-or-treat fights.
	string trickOrTreatMap = get_property("_trickOrTreatBlock");
	string[int] splitToT = split_string(trickOrTreatMap, "");

    int fightsParsed;

	foreach house in splitToT {
		if (splitToT[house] == "D") {fightsParsed +=1;}
		if (splitToT[house] == "d") {fightsParsed +=1;}
	}

    string [int] description;
    string url = "inventory.php?ftext=candy-rich";
    string main_title = "Use your Map to a Candy-Rich Block.";  

    // Do not generate the tile if the user has access to trick-or-treat zones because it's Halloween
    if (getHolidaysToday()["Halloween"]) return;

    // Do not generate the tile if the user has access to trick-or-treat zones and has visited it
    if (fightsParsed > 0 && usedMap) return;

    // Still generate it even if they've used the map because mafia needs one T&T visit to generate the pref for the freefight tile
    if (fightsParsed == 0 && usedMap) {
        main_title = "Visit your Trick-or-Treat block!";
        string url = "place.php?whichplace=town&action=town_trickortreat";
        description.listAppend("Might have a star house... 👀");
    }

    if (fightsParsed == 0 && !usedMap) {
        description.listAppend("Use your map for five free fights & some candy!");
    }

    optional_task_entries.listAppend(ChecklistEntryMake("__item plastic pumpkin bucket", url, ChecklistSubentryMake(main_title, "", description), 7).ChecklistEntrySetIDTag("map to a candy-rich block"));
    

}

// TILE SPEC: 
//    - Remind the user to get a halloween map. 
//    - Remind the user to get an LED candle.
//    - Recommend halloween monsters for habitation.

RegisterResourceGenerationFunction("IOTMJillv2GenerateResource");
void IOTMJillv2GenerateResource(ChecklistEntry [int] resource_entries)
{
    familiar bigJillyStyle = lookupFamiliar("Jill-of-All-Trades");
	if (!bigJillyStyle.familiar_is_usable()) return;

	int mapsDropped = get_property_int("_mapToACandyRichBlockDrops");
	
	string url = "familiar.php";
	if (bigJillyStyle == my_familiar())
		url = "";
  
    // Initial chance is 35% with a masssive dropoff (multiply by 5% per map dropped)
    float estimatedMapProbability = 35 * (0.05 ** clampi(mapsDropped, 0, 3)); // confirmed by cannonfire to stop decreasing after 3rd time

    // Convert to turns
    float turnsToMap = 1/(estimatedMapProbability/100);

    string [int] description;
    if (mapsDropped == 0) {
        description.listAppend("You haven't gotten a map to halloween town yet! Try using your Jill for a map at ~"+round(estimatedMapProbability)+"% chance, or approximately "+round(turnsToMap,1)+" turns. <a href='place.php?whichplace=town&action=town_trickortreat' target='mainpane'><span style='color:blue; font-size:100%; font-weight:normal;'>Go!</span></a>");
    }
    else if (mapsDropped < 2) { // The third map drop chance is less than 1 in a thousand - not something that is particularly useful to hunt for
        description.listAppend("You have a map; the next map is at a ~"+round(estimatedMapProbability)+"% chance, or approximately "+round(turnsToMap,1)+" turns. <a href='place.php?whichplace=town&action=town_trickortreat' target='mainpane'><span style='color:blue; font-size:100%; font-weight:normal;'>Go!</span></a>");
    }
    
	int habitatRecallsLeft = clampi(3 - get_property_int("_monsterHabitatsRecalled"), 0, 3);
    if (!lookupSkill("Just the Facts").have_skill() && !__iotms_usable[$item[book of facts (dog-eared)]]) habitatRecallsLeft = 0;
    if (habitatRecallsLeft > 0)
		description.listAppend("Halloween monsters make excellent targets for <b>Recall Habitat</b> from BoFA. <a href='place.php?whichplace=town&action=town_trickortreat' target='mainpane'><span style='color:blue; font-size:100%; font-weight:normal;'>Go!</span></a>");

    // Adding a small exception here to not generate this if they weirdly acquired LED through other means (like casual or a pull or something)
    if (!get_property_boolean("ledCandleDropped") && $item[LED Candle].item_amount() < 1) {
        description.listAppend("Fight a dude for an LED candle, to tune your Jill!");
    }

    // Populate a free fights count of trick-or-treat fights.
	string trickOrTreatMap = get_property("_trickOrTreatBlock");
	string[int] splitToT = split_string(trickOrTreatMap, "");
    int freeFightsLeft;

	foreach house in splitToT {
		if (splitToT[house] == "D") {freeFightsLeft +=1;}
	}

    if (freeFightsLeft > 0) {resource_entries.listAppend(ChecklistEntryMake("__familiar jill-of-all-trades", "place.php?whichplace=town&action=town_trickortreat", ChecklistSubentryMake(pluralise(freeFightsLeft, "Trick or Treat fight", "Trick or Treat fights"), "", "Equip an outfit and mess with some halloweenies."), 0).ChecklistEntrySetCombinationTag("daily free fight").ChecklistEntrySetIDTag("trick or treat free fights"));}

    // If we have nothing to say, do not display the tile
    if (count(description) == 0) return;
	
    resource_entries.listAppend(ChecklistEntryMake("__familiar jill-of-all-trades", url, ChecklistSubentryMake("Jill of All Trades", "", description), -50).ChecklistEntrySetIDTag("Jill of All Trades tile"));
}

//Jill-of-All-Trades
//....added 2023.12.04...from https://discord.com/channels/466605739838930955/711957790859460650/1178123877453410415 ... AR
//_mapToACandyRichBlockDrops	1		_mapToACandyRichBlockUsed	false
RegisterResourceGenerationFunction("IOTMJOATGenerateResource");
void IOTMJOATGenerateResource(ChecklistEntry [int] resource_entries)
{
    string [int] description;
	description.listAppend("tgg hmap (_aaa_halloweenMapCompleted)");
	description.listAppend("_mapToACandyRichBlockUsed = "+get_property("_mapToACandyRichBlockUsed"));
	description.listAppend("_trickOrTreatBlock = "+get_property("_trickOrTreatBlock"));
    //can only use the first one each day, though more of them can drop, and _mapToACandyRichBlockUsed is never set true until you try
	//to use one and fail? result: You already visited a candy-rich block today, don't be greedy.
	//get_property_int("_mapToACandyRichBlockDrops") < 2
	//also mafia removes the map from inventory when map use fails, though it remains in inventory
	if ( $item[map to a candy-rich block].available_amount() > 0 && !get_property_boolean("_mapToACandyRichBlockUsed") ) {
        description.listAppend("Need to equip an outfit!");
        description.listAppend("Use a 2nd map to mark this task complete.");
    resource_entries.listAppend(ChecklistEntryMake("__item map to a candy-rich block", "inventory.php?ftext=candy-rich", ChecklistSubentryMake("5 Candy-rich block fights available", description), -50).ChecklistEntrySetCombinationTag("daily free fight").ChecklistEntrySetIDTag("JOAT"));
    }
    else if (get_property_boolean("_mapToACandyRichBlockUsed") == true) {
        description.listAppend("Trick-or-Treat!");
    //resource_entries.listAppend(ChecklistEntryMake("__familiar Jill-of-All-Trades", "place.php?whichplace=town&action=town_trickortreat", ChecklistSubentryMake("Candy-rich block available", description),-60).ChecklistEntrySetCombinationTag("JOAT resources").ChecklistEntrySetIDTag("JOAT"));
	
		if	( !get_property_boolean("_aaa_halloweenMapCompleted") ) {
			resource_entries.listAppend(ChecklistEntryMake("__familiar Jill-of-All-Trades", "place.php?whichplace=town&action=town_trickortreat", ChecklistSubentryMake("Candy-rich block available <a href='place.php?whichplace=town&action=town_trickortreat' target='mainpane'><span style='color:blue; font-size:100%; font-weight:normal;'>Go!</span></a>", description),-60).ChecklistEntrySetCombinationTag("daily free fight"));
		}
    }
}