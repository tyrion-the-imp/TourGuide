//2024
//Chest Mimic
RegisterTaskGenerationFunction("IOTMChestMimicGenerateTasksBETA");
void IOTMChestMimicGenerateTasksBETA(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
		string line;
		boolean requirements_met = false;
		string [int] description;
		string url = "inventory.php?ftext=mimic";
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
		if	( requirements_met ) {
			task_entries.listAppend(ChecklistEntryMake("__item mimic egg", url, ChecklistSubentryMake("Mimic Egg (beta)", "", description), -11));
		}
}
RegisterResourceGenerationFunction("IOTMChestMimicGenerateResourceBETA");
void IOTMChestMimicGenerateResourceBETA(ChecklistEntry [int] resource_entries)
{
	if (!lookupFamiliar("Chest Mimic").familiar_is_usable()) return;
    int famExperienceGain = numeric_modifier("familiar experience") +1;
	int chestExperience = ($familiar[chest mimic].experience);
	int chestCopiesAvailable = (chestExperience.to_float() / 50.0).to_int();
	int famExpNeededForNextEgg = (50 - (chestExperience % 50));
	int mimicEggsLeft = clampi(11 - get_property_int("_mimicEggsObtained"), 0, 11);
	chestCopiesAvailable = min(chestCopiesAvailable, mimicEggsLeft);
	string fightsForNextEgg = pluralise(ceil(to_float(famExpNeededForNextEgg) / famExperienceGain), "fight", "fights");
	string [int] description;
	//DNA Bank: place.php?whichplace=town_right&action=townright_dna
	string url = "familiar.php";
	{
		description.listAppend("Currently have " + HTMLGenerateSpanOfClass(chestExperience, "r_bold") + " experience, currently gain " + HTMLGenerateSpanOfClass(famExperienceGain, "r_bold") + " fam exp per fight.");
		description.listAppend("Can currently add <span style='color:red; font-weight:bold;'>"+chestCopiesAvailable+"</span> copies to the egg.");
		description.listAppend("Need " + HTMLGenerateSpanOfClass(famExpNeededForNextEgg, "r_bold") + " more famxp for next egg. (" + fightsForNextEgg + " fight(s))");
		description.listAppend("Can lay " + HTMLGenerateSpanOfClass(mimicEggsLeft, "r_bold") + " more eggs today.");
		resource_entries.listAppend(ChecklistEntryMake("__familiar chest mimic", url, ChecklistSubentryMake(HTMLGenerateSpanFont("Chest mimic fxp (beta)", "black"), "", description), -50));
	}
	//mafia doesn't currently recognize when the egg disappears after fighting the last monster in it
	//this should probably be in Copied Monsters.ash, or duplicated there
	/*
	if ($item[mimic egg].available_amount() > 0) {
        string header = $item[mimic egg].pluralise().capitaliseFirstLetter();
		string url = "inv_use.php?pwd=" + my_hash() + "&whichitem=11542";
        resource_entries.listAppend(ChecklistEntryMake("__item mimic egg", url, ChecklistSubentryMake(header, "", "Fight some copies"), -12));
	}
	*/
}