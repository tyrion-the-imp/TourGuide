//Chest Mimic DISCARDED
RegisterResourceGenerationFunction("IOTMChestMimicGenerateResource");
void IOTMChestMimicGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (!lookupFamiliar("Chest Mimic").familiar_is_usable()) return;

	// Title
	int famExperienceGain = numeric_modifier("familiar experience") + 1;
	int chestExperience = ($familiar[chest mimic].experience);
	int famExpNeededForNextEgg = (50 - (chestExperience % 50));
	string fightsForNextEgg;
	if (famExperienceGain > 0) {
		fightsForNextEgg = pluralise(ceil(to_float(famExpNeededForNextEgg) / famExperienceGain), "fight", "fights");
	}
	else {
		fightsForNextEgg = "cannot get";
	}
	int mimicEggsLeft = clampi(11 - get_property_int("_mimicEggsObtained"), 0, 11);

	string [int] description;
	string url = "familiar.php";
	description.listAppend(`Currently have {HTMLGenerateSpanOfClass(chestExperience, "r_bold")} experience, currently gain {HTMLGenerateSpanOfClass(famExperienceGain, "r_bold")} fam exp per fight.`);
	description.listAppend(`Need {HTMLGenerateSpanOfClass(famExpNeededForNextEgg, "r_bold")} more famxp for next egg. ({fightsForNextEgg})`);
	description.listAppend(`Can lay {HTMLGenerateSpanOfClass(mimicEggsLeft, "r_bold")} more eggs today.`);

	//resource_entries.listAppend(ChecklistEntryMake("__familiar chest mimic", url, ChecklistSubentryMake("Chest mimic fxp", "", description), -49));
	if ($item[mimic egg].available_amount() > 0) {
		string header = $item[mimic egg].pluralise().capitaliseFirstLetter();
		string url = `inv_use.php?pwd={my_hash()}&whichitem=11542`;
		resource_entries.listAppend(ChecklistEntryMake("__item mimic egg", url, ChecklistSubentryMake(header, "", "Fight some copies"), -49).ChecklistEntrySetCombinationTag("fax and copies"));
	}
}
