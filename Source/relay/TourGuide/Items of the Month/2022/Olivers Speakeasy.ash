//2022: Shadows of Loathing Mr A Content (itoy?)
//Oliver's Speakeasy
RegisterResourceGenerationFunction("IOTMOliversSpeakeasyGenerateResource");
void IOTMOliversSpeakeasyGenerateResource(ChecklistEntry [int] resource_entries)
{
    #if (!locationAvailable($location[An Unusually Quiet Barroom Brawl])) return; //un-comment this when the check starts working
    
    int free_speakeasy_fights_left = clampi(3 - get_property_int("_speakeasyFreeFights"), 0, 3);
	string url;
	string [int] description;
	url = "place.php?whichplace=speakeasy";
	description.listAppend("Smuggle in some wanderers to make them free!|*<span style='color:blue; font-size:85%; font-weight:bold;'>(An Unusually Quiet Barroom Brawl)</span>");
		
    if (get_property_int("_speakeasyFreeFights") < 3) {
        resource_entries.listAppend(ChecklistEntryMake("__item drink chit", url, ChecklistSubentryMake(pluralise(free_speakeasy_fights_left, "speakeasy fight", "speakeasy fights"), "", description), 8).ChecklistEntrySetCombinationTag("daily free fight").ChecklistEntrySetIDTag("Speakeasy free fight"));
    }
}