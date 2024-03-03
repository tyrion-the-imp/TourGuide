//2022: cursed magnifying glass
RegisterTaskGenerationFunction("IOTYCursedMagnifyingGlassGenerateTasks");
void IOTYCursedMagnifyingGlassGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	if (lookupItem("cursed magnifying glass").available_amount() == 0) return;
	
	int free_void_fights_left = clampi(5 - get_property_int("_voidFreeFights"), 0, 5);
	int cursedGlassCounter = get_property_int("cursedMagnifyingGlassCount");
	string url;
	string [int] description;
	if (lookupItem("cursed magnifying glass").equipped_amount() == 0) {
		description.listAppend(HTMLGenerateSpanFont("Equip the cursed magnifying glass", "red"));
		url = invSearch("cursed magnifying glass");
	} 
	{
		if (cursedGlassCounter < 12)
		{
            url = invSearch("cursed magnifying glass");
			description.listAppend((13 - cursedGlassCounter).pluralise("combat", "combats") + " until next void fight.");
			optional_task_entries.listAppend(ChecklistEntryMake("__item cursed magnifying glass", url, ChecklistSubentryMake("Cursed magnifying glass combat", "", description), 8));
        }
		int cmg_il = -1;
		if	( __misc_state["in run"] ) { cmg_il = -10; }
		
		
		
		if (cursedGlassCounter == 12)
		{
			description.listAppend(HTMLGenerateSpanFont("One more fight until you encounter a void.", "blue"));
			task_entries.listAppend(ChecklistEntryMake("__item void stone", url, ChecklistSubentryMake("Cursed magnifying glass combat", "", description), cmg_il));
        }	
		
		if (cursedGlassCounter == 13)
        {
            if (lookupItem("cursed magnifying glass").equipped_amount() == 0) 
			{
			task_entries.listAppend(ChecklistEntryMake("__item void stone", url, ChecklistSubentryMake("Cursed magnifying glass combat", "", description), cmg_il));
			}  
			else 
			{
			description.listAppend(HTMLGenerateSpanFont("Void combat next adventure, ", "red") + HTMLGenerateSpanFont("magnifying glass equipped", "blue"));
			task_entries.listAppend(ChecklistEntryMake("__item void stone", url, ChecklistSubentryMake("Cursed magnifying glass combat", "", description), cmg_il));
			}
        }
		
		if (free_void_fights_left > 0)
		{
            description.listAppend("" + free_void_fights_left + " free void fights remaining.");
        }
		else if (lookupSkill("Meteor Lore").have_skill() || lookupItem("powerful glove").available_amount() > 0) 
		{
			description.listAppend("No free void fights remaining, but you can replace them with lobsterfrogmen or something.");
		}
		else
		{
			description.listAppend("No free void fights remaining, but you can charge it up for tomorrow?");
		}
	}	
}

RegisterResourceGenerationFunction("IOTYCursedMagnifyingGlassGenerateResource");
void IOTYCursedMagnifyingGlassGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (lookupItem("cursed magnifying glass").available_amount() == 0) return;
    
    int free_void_fights_left = clampi(5 - get_property_int("_voidFreeFights"), 0, 5);
	int cursedGlassCounter = get_property_int("cursedMagnifyingGlassCount");
	string url;
	string [int] description;

    if (get_property_int("_voidFreeFights") < 5) {
        int cursedGlassCounter = get_property_int("cursedMagnifyingGlassCount");
        url = invSearch("cursed magnifying glass");
		description.listAppend((13 - cursedGlassCounter).pluralise("combat", "combats") + " until next void fight.");
		
		resource_entries.listAppend(ChecklistEntryMake("__item void stone", url, ChecklistSubentryMake(pluralise(free_void_fights_left, "void glass monster", "void glass monsters"), "", description), 8).ChecklistEntrySetCombinationTag("daily free fight").ChecklistEntrySetIDTag("Cursed magnifying glass free fight"));
    }
}