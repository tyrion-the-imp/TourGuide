//2002 Mr. Store
RegisterResourceGenerationFunction("IOTM2002MrStoreGenerateResourceTemp");
void IOTM2002MrStoreGenerateResourceTemp(ChecklistEntry [int] resource_entries)
{
    #if (!lookupItem("2002 Mr. Store Catalog").have()) return;
	
	int Mr2002Credits = get_property_int("availableMrStore2002Credits");
	string main_title = (Mr2002Credits + " 2002 Mr. Store credits (TEMP)");
	string [int] description;
	string url = "inv_use.php?pwd=" + my_hash() + "&which=3&whichitem=11257";

    if (Mr2002Credits > 0) {
    description.listAppend("Spend credits on prehistoric IotMs!");
		
		string [int] options;
		if (__misc_state["in run"] && my_path().id != PATH_COMMUNITY_SERVICE)
		{
        	if ($item[Flash Liquidizer Ultra Dousing Accessory].available_amount() == 0)
            {
                options.listAppend(HTMLGenerateSpanOfClass("Flash Liquidizer Ultra Dousing Accessory:", "r_bold") + " +3 BLARTpockets, +20% items (& multi-equip)");
            }        
            if ($item[pro skateboard].available_amount() == 0)
            {
                options.listAppend(HTMLGenerateSpanOfClass("Pro skateboard:", "r_bold") + " +1 duplicate");
            }
            if ($item[letter from carrie bradshaw].available_amount() == 0 && $item[red-soled high heels].available_amount() == 0)
            {
                options.listAppend(HTMLGenerateSpanOfClass("Letter from Carrie Bradshaw:", "r_bold") + " +50% booze drop accessory");
            }
            if ($item[Loathing Idol Microphone].available_amount() < 69420)
            {
                options.listAppend(HTMLGenerateSpanOfClass("Loathing Idol Microphone:", "r_bold") + " +100% init or +50% items, +5% combat, 4 uses");
            }
			if ($item[Spooky VHS Tape].available_amount() < 69420)
            {
                options.listAppend(HTMLGenerateSpanOfClass("Spooky VHS Tape:", "r_bold") + " wandering freekill YR of the monster you used it on (7 turns later)");
            }
		}
		if (options.count() > 0)
            description.listAppend("Possible purchases:|*" + options.listJoinComponents("|*"));
	}
	
	int availableVHSes = available_amount($item[Spooky VHS Tape]);
	int availableIdolMics = available_amount($item[Loathing Idol Microphone]);
	// Ascension stuff
	//if (!__misc_state["in run"] || my_path().id == PATH_COMMUNITY_SERVICE || availableVHSes + availableIdolMics == 0) { return; }

	/* if (availableVHSes > 0 && $item[Spooky VHS Tape].item_is_usable())
	{
		description.listAppend("Have " + availableVHSes + " VHS tapes.");
	}
	if (availableIdolMics > 0 && $item[Loathing Idol Microphone].item_is_usable())
	{
		description.listAppend("Have " + availableIdolMics + " Loathing Idol microphones.");
	} */
	//https://kol.coldfront.net/thekolwiki/index.php/2002_Mr._Store
	description.listAppend("<a href='https://kol.coldfront.net/thekolwiki/index.php/2002_Mr._Store' target='_blank'><span style='color:blue; font-size:100%; font-weight:normal;'>2002 Mr. Store merch</span></a><br><span style='color:red; font-size:100%; font-weight:bold;'>Credits disappear on rollover.</span>");
	
	
	// List out the mics from least to most charged
	item [int] listOfMics = listMake($item[Loathing Idol Microphone (25% charged)],$item[Loathing Idol Microphone (50% charged)],$item[Loathing Idol Microphone (75% charged)],$item[Loathing Idol Microphone]);
	int totalIdolCharge;

	foreach i, micItem in listOfMics {
		// Add # of charge based on index of the above list to the total charge.
		totalIdolCharge += i*available_amount(micItem);
	}
	//list if items is 0-indexed, so add 1
	totalIdolCharge += 1;

	boolean McTwistUsed = get_property_boolean("_epicMcTwistUsed");
	int FLUDAdousesLeft = clampi(3 - get_property_int("_douseFoeUses"), 0, 3);
	
	// Ascension stuff
	if (!__misc_state["in run"] ||
		my_path().id == PATH_COMMUNITY_SERVICE ||
		availableVHSes + totalIdolCharge + FLUDAdousesLeft == 0)
		return;

	// Generate useful VHS copy list
	string [int] optionsVHS;

	if (__quest_state["Level 12"].state_int["hippies left on battlefield"] > 5) optionsVHS.listAppend("War monsters; especially GROPs");
	if (!__quest_state["Level 7"].state_boolean["cranny finished"]) optionsVHS.listAppend("Giant swarm of ghuol whelps");
	if (!__quest_state["Level 8"].state_boolean["Mountain climbed"]) optionsVHS.listAppend("Ninja snowman assassin");
	if ($item[amulet of extreme plot significance].available_amount() == 0) optionsVHS.listAppend("Quiet Healer");
	if ($item[mohawk wig].available_amount() == 0) optionsVHS.listAppend("Burly Sidekick");

	if (availableVHSes > 0 && $item[Spooky VHS Tape].item_is_usable())
	{
		string VHSDescription = "Have " + availableVHSes + " VHS tapes.";
		if (optionsVHS.count() > 0) {
			VHSDescription += " Use to free-copy into delay & guarantee drops from:|*"+optionsVHS.listJoinComponents("|*");
		}
		description.listAppend(VHSDescription);
	}
	if (totalIdolCharge > 0)
	{
		description.listAppend("Have <span style='color:fuchsia; font-size:100%; font-weight:bold;'>" + totalIdolCharge + "</span> Loathing Idol microphone uses. (50% item, 5% com, or 100% init.)");
	}

	string [int] optionsMcTwist;

	if ($item[goat cheese].available_amount() < 2 && !__quest_state["Level 8"].state_boolean["Past mine"])
		optionsMcTwist.listAppend(HTMLGenerateFutureTextByLocationAvailability("a dairy goat", $location[the goatlet]));
	if (__quest_state["Level 9"].state_int["twin peak progress"] < 15) 
		optionsMcTwist.listAppend(HTMLGenerateFutureTextByLocationAvailability("a hedge trimmer monster", $location[Twin Peak]));
	if (!__quest_state["Level 7"].state_boolean["nook finished"]) 
		optionsMcTwist.listAppend(HTMLGenerateFutureTextByLocationAvailability("an evil eye monster", $location[the defiled nook]));
	if (__quest_state["Level 12"].state_int["hippies left on battlefield"] > 5) 
		optionsMcTwist.listAppend(HTMLGenerateFutureTextByLocationAvailability("a green ops soldier", $location[the battlefield (frat uniform)]));

	if (available_amount($item[pro skateboard]) > 0 && McTwistUsed == False) {
		string mcTwistDescription = "Can Epic McTwist to double drops!";
		if (optionsMcTwist.count() > 0) {
			mcTwistDescription += " Consider using on: "+optionsMcTwist.listJoinComponents(", ", "or ") + ".";
		}

		description.listAppend(mcTwistDescription);
	}
	string [int] optionsFLUDA;

	if ($item[goat cheese].available_amount() < 2 && !__quest_state["Level 8"].state_boolean["Past mine"])
		optionsFLUDA.listAppend(HTMLGenerateFutureTextByLocationAvailability("goat cheese", $location[the goatlet]));
	if (!__quest_state["Level 12"].state_boolean["Orchard Finished"] && my_path().id != PATH_2CRS)
		optionsFLUDA.listAppend(HTMLGenerateFutureTextByLocationAvailability("filthworm sweat glands", $location[the battlefield (frat uniform)]));


	if (available_amount($item[Flash Liquidizer Ultra Dousing Accessory]) > 0 && FLUDAdousesLeft > 0) {
		string fludaDescription = "Can waterpocket " + FLUDAdousesLeft + " more foes with FLUDA.";
		if (optionsFLUDA.count() > 0) {
			fludaDescription += " Try stealing some "+optionsFLUDA.listJoinComponents(", ", "or ")+".";
		}
		description.listAppend(fludaDescription);
	}
	
	
	
	for i from 11257 to 11284 by 1 {
		item i2002 = i.to_item();
		string iclr = "blue";
		//11257 = 2002 Mr. Store Catalog
		if	( i == 11257 ) { continue; }
		//if	( available_amount(i2002) < 1 ) { iclr = "red"; }
		if	( available_amount(i2002) > 0 ) {
			description.listAppend("Have <span style='color:"+iclr+"; font-size:100%; font-weight:bold;'>" + available_amount(i2002) + "</span> "+i2002);
		}
	}

	resource_entries.listAppend(ChecklistEntryMake("__item mr. accessaturday", url, ChecklistSubentryMake(main_title, description), -7));
}