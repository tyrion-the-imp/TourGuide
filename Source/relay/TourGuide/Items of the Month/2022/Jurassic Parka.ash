//Jurassic parka

RegisterTaskGenerationFunction("IOTMJurrassicParkaGenerateTasks");
void IOTMJurrassicParkaGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	//string url = "inventory.php?ftext=jurassic";
	string url = "inventory.php?action=jparka";
	string [int] description;
	int spikos_left = clampi(5 - get_property_int("_spikolodonSpikeUses"), 0, 5);
	string main_title = spikos_left + " Parka forced non-coms remaining";
	
	if	( spikos_left > 0 && __misc_state["in run"] ) {
		task_entries.listAppend(ChecklistEntryMake("__item jurrassic parka", url, ChecklistSubentryMake(main_title, description), -9));
	}
}

RegisterResourceGenerationFunction("IOTMJurassicParkaGenerateResource");
void IOTMJurassicParkaGenerateResource(ChecklistEntry [int] resource_entries)
{
    item parka = lookupItem("jurassic parka");
    if (!parka.have()) return;
    //if (!__misc_state["in run"]) return; 
    string url;
	string parkaMode = get_property("parkaMode");
	string parkaEnchant;
	string [int] description;
    url = invSearch("jurassic parka");
	int spikos_left = clampi(5 - get_property_int("_spikolodonSpikeUses"), 0, 5);
    // Title
        string main_title = "Jurassic Parka";
        description.listAppend("You're the dinosaur now, dawg.");
		
		switch (get_property("parkaMode"))			
		{
			case "kachungasaur":
				parkaEnchant = "+100% HP, +50% meat, +2 Cold res."; break;
			case "dilophosaur":
				parkaEnchant = "+20 Sleaze and Sleaze Spell, +2 Stench res, YR free kill."; break;
			case "spikolodon":
				parkaEnchant = "+ML, +2 Sleaze res, NC forcing ability."; break;
			case "ghostasaurus":
				parkaEnchant = "+10 DR, +50 MP, +2 Spooky res."; break;
			case "pterodactyl":
				parkaEnchant = "-5% Combat Frequency, +50% Initiative, +2 Hot res."; break;
		}
		description.listAppend(HTMLGenerateSpanOfClass("Current enchantment: ", "r_bold") + parkaMode);
		description.listAppend(HTMLGenerateSpanFont(parkaEnchant, "blue") + "");
		description.listAppend(HTMLGenerateSpanOfClass(spikos_left, "r_bold") + " spikolodon spikes available.");
		resource_entries.listAppend(ChecklistEntryMake("__item jurassic parka", "inventory.php?action=jparka", ChecklistSubentryMake(main_title, "", description)));
}