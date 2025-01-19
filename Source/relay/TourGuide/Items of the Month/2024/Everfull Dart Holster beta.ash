//Everfull Dart Holster
RegisterTaskGenerationFunction("IOTMEverfullDartsGenerateTasksBeta");
void IOTMEverfullDartsGenerateTasksBeta(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (item_is_usable($item[everfull dart holster]) && available_amount($item[everfull dart holster]) > 0 && my_path().id != PATH_COMMUNITY_SERVICE)
    {
        string [int] description;
        string url = "inventory.php?ftext=everfull+dart_holster";
            
            if ($effect[everything looks red].have_effect() == 0) 
        {
            int dartCooldown = 50;
            if (get_property("everfullDartPerks").contains_text("You are less impressed by bullseyes")) {
                dartCooldown -= 10;
            }
            if (get_property("everfullDartPerks").contains_text("Bullseyes do not impress you much")) {
                dartCooldown -= 10;
            }
            description.listAppend(HTMLGenerateSpanFont("Shoot a bullseye! (" + dartCooldown + " ELR)", "red"));
            if (lookupItem("everfull dart holster").equipped_amount() == 0)
            {
                description.listAppend(HTMLGenerateSpanFont("Equip the dart holster first.", "red"));
            }
            else description.listAppend(HTMLGenerateSpanFont("dart holster equipped", "blue"));
			if (!get_property_boolean("kingLiberated")) {
				task_entries.listAppend(ChecklistEntryMake("__item everfull dart holster", url, ChecklistSubentryMake("Everfull Darts free kill available!", "", description), -10));
			} else {
				optional_task_entries.listAppend(ChecklistEntryMake("__item everfull dart holster", url, ChecklistSubentryMake("Everfull Darts free kill available!", "", description), -11));
			}
        }
    }
}

RegisterResourceGenerationFunction("IOTMEverfullDartsGenerateResourceBeta");
void IOTMEverfullDartsGenerateResourceBeta(ChecklistEntry [int] resource_entries)
{
    if (__misc_state["in run"] && available_amount($item[everfull dart holster]) > 0 && my_path().id != PATH_COMMUNITY_SERVICE)
    {
        string [int] description;
        string url = "inventory.php?ftext=everfull+dart_holster";
            
        int dartSkill = get_property_int("dartsThrown");
        int dartsNeededForNextPerk = (floor(sqrt(dartSkill)+1) **2 - dartSkill);
        description.listAppend("Current dart skill: " + dartSkill);
        description.listAppend(HTMLGenerateSpanFont(dartsNeededForNextPerk, "blue") + " darts needed for next Perk");
    
        if (lookupItem("everfull dart holster").equipped_amount() == 0)
        {
            description.listAppend(HTMLGenerateSpanFont("Equip the dart holster first.", "red"));
        }
        else description.listAppend(HTMLGenerateSpanFont("dart holster equipped", "blue"));
		
		resource_entries.listAppend(ChecklistEntryMake("__item everfull dart holster", url, ChecklistSubentryMake("Everfull Dart Holster charging", "", description), -40));
    }
}