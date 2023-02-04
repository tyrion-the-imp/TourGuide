//2023
//Rock Garden
RegisterResourceGenerationFunction("IOTMRockGardenGenerateResource");
void IOTMRockGardenGenerateResource(ChecklistEntry [int] resource_entries)
{
    string [int] description;
	string url = "campground.php";
	
	if (!get_property_boolean("_molehillMountainUsed") && available_amount($item[molehill mountain]) > 0) 
	{
        resource_entries.listAppend(ChecklistEntryMake("__item molehill mountain", url = "inventory.php?ftext=molehill+mountain", ChecklistSubentryMake("Molehill moleman", "", "Free scaling fight."), 5).ChecklistEntrySetCombinationTag("daily free fight").ChecklistEntrySetIDTag("Molehill free fight"));
    }
	// Ascension stuff
    if (!__iotms_usable[lookupItem("packet of rock seeds")]) return;
	if (__misc_state["in run"] && my_path().id != 25) return;
	int gardenGravels = available_amount($item[groveling gravel]);
	int gardenMilestones = available_amount($item[milestone]);
	int gardenWhetstones = available_amount($item[whet stone]);
	int desertProgress = get_property_int("desertExploration");
	if (gardenGravels > 0 && $item[groveling gravel].item_is_usable())
	{
		description.listAppend(HTMLGenerateSpanOfClass(gardenGravels, "r_bold") + "x groveling gravel (free kill*)");
	}
	if (gardenWhetstones > 0 && $item[whet stone].item_is_usable() && (__misc_state["can eat just about anything"]))
	{
		description.listAppend(HTMLGenerateSpanOfClass(gardenWhetstones, "r_bold") + "x whet stone (+1 adv on food)");
	}	
	if (gardenMilestones > 0 && $item[milestone].item_is_usable() && desertProgress < 100)
	{
		description.listAppend(HTMLGenerateSpanOfClass(gardenMilestones, "r_bold") + "x milestone (+5% desert progress), " + (100 - desertProgress) + "% remaining");
	}
	resource_entries.listAppend(ChecklistEntryMake("__item rock garden guide", url, ChecklistSubentryMake("Rock garden resources", "", description)).ChecklistEntrySetIDTag("rock garden resource"));
}