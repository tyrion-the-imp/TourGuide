//2002 Mr. Store
RegisterResourceGenerationFunction("IOTM2002MrStoreGenerateResourceTemp");
void IOTM2002MrStoreGenerateResourceTemp(ChecklistEntry [int] resource_entries)
{
    #if (!lookupItem("2002 Mr. Store Catalog").have()) return;
	
	int Mr2002Credits = get_property_int("availableMrStore2002Credits");
	string main_title = (Mr2002Credits + " 2002 Mr. Store credits (TEMP)");
	string [int] description;
	string url = "inv_use.php?pwd=" + my_hash() + "&which=3&whichitem=11280";

    if (Mr2002Credits > 0) {
    description.listAppend("Spend credits on prehistoric IotMs!");
		
		string [int] options;
		if (__misc_state["in run"] && my_path().id != PATH_COMMUNITY_SERVICE)
		{
        	if ($item[Flash Liquidizer Ultra Dousing Accessory].available_amount() == 0)
            {
                options.listAppend(HTMLGenerateSpanOfClass("Flash Liquidizer Ultra Dousing Accessory:", "r_bold") + " +3 BLARTpockets");
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
                options.listAppend(HTMLGenerateSpanOfClass("Loathing Idol Microphone:", "r_bold") + " +100% init or +50% items, 4 uses");
            }
			if ($item[Spooky VHS Tape].available_amount() < 69420)
            {
                options.listAppend(HTMLGenerateSpanOfClass("Spooky VHS Tape:", "r_bold") + " complicated dickstabbing");
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
	description.listAppend("<a href='https://kol.coldfront.net/thekolwiki/index.php/2002_Mr._Store' target='_blank'><span style='color:blue; font-size:100%; font-weight:normal;'>2002 Mr. Store merch</span></a>");
	
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