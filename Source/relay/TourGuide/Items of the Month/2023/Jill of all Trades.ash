// TILE SPEC: 
//    - Remind the user to get a halloween map. 
//    - Remind the user to get an LED candle.
//    - Recommend halloween monsters for habitation.

// CANNOT DO YET:
//    - Add halloween fights to freebies combination tag; need better mafia tracking...

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
        description.listAppend("You haven't gotten a map to halloween town yet! Try using your Jill for a map at ~"+round(estimatedMapProbability)+"% chance, or approximately "+round(turnsToMap,1)+" turns.");
    }
    else if (mapsDropped < 2) { // The third map drop chance is less than 1 in a thousand - not something that is particularly useful to hunt for
        description.listAppend("You have a map; the next map is at a ~"+round(estimatedMapProbability)+"% chance, or approximately "+round(turnsToMap,1)+" turns.");
    }
    
	int habitatRecallsLeft = clampi(3 - get_property_int("_monsterHabitatsRecalled"), 0, 3);
    if (!lookupSkill("Just the Facts").have_skill() && !__iotms_usable[$item[book of facts (dog-eared)]]) habitatRecallsLeft = 0;
    if (habitatRecallsLeft > 0)
		description.listAppend("Halloween monsters make excellent targets for <b>Recall Habitat</b> from BoFA.");

    // Adding a small exception here to not generate this if they weirdly acquired LED through other means (like casual or a pull or something)
    if (!get_property_boolean("ledCandleDropped") && $item[LED Candle].item_amount() < 1) {
        description.listAppend("Fight a dude for an LED candle, to tune your Jill!");
    }

    // If we have nothing to say, do not display the tile
    if (count(description) == 0) return;
	
    resource_entries.listAppend(ChecklistEntryMake("__familiar jill-of-all-trades", url, ChecklistSubentryMake("Celebrating the Jillenium", "", description)).ChecklistEntrySetIDTag("Jill of All Trades tile"));
}

//Jill-of-All-Trades
//....added 2023.12.04...from https://discord.com/channels/466605739838930955/711957790859460650/1178123877453410415 ... AR
//_mapToACandyRichBlockDrops	1		_mapToACandyRichBlockUsed	false
RegisterResourceGenerationFunction("IOTMJOATGenerateResource");
void IOTMJOATGenerateResource(ChecklistEntry [int] resource_entries)
{
    string [int] description;
    //can only use the first one each day, though more of them can drop, and _mapToACandyRichBlockUsed is never set true until you try
	//to use one and fail? result: You already visited a candy-rich block today, don't be greedy.
	//get_property_int("_mapToACandyRichBlockDrops") < 2
	//also mafia removes the map from inventory when map use fails, though it remains in inventory
	if ( $item[map to a candy-rich block].available_amount() > 0 && !get_property_boolean("_mapToACandyRichBlockUsed") ) {
        description.listAppend("Need to equip an outfit!");
        description.listAppend("Use a 2nd map to mark this task complete.");
    resource_entries.listAppend(ChecklistEntryMake("__item map to a candy-rich block", "inventory.php?ftext=candy-rich", ChecklistSubentryMake("5 Candy-rich block fights available", description), -1).ChecklistEntrySetCombinationTag("daily free fight").ChecklistEntrySetIDTag("JOAT"));
    }
    else if (get_property_boolean("_mapToACandyRichBlockUsed") == true) {
        description.listAppend("Trick-or-Treat!");
    //resource_entries.listAppend(ChecklistEntryMake("__familiar Jill-of-All-Trades", "place.php?whichplace=town&action=town_trickortreat", ChecklistSubentryMake("Candy-rich block available", description),-60).ChecklistEntrySetCombinationTag("JOAT resources").ChecklistEntrySetIDTag("JOAT"));
    resource_entries.listAppend(ChecklistEntryMake("__familiar Jill-of-All-Trades", "place.php?whichplace=town&action=town_trickortreat", ChecklistSubentryMake("Candy-rich block available", description),-60).ChecklistEntrySetCombinationTag("daily free fight"));
    }
}