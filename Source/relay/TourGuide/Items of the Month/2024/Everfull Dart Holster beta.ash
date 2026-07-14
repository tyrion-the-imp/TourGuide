//Everfull Dart Holster
RegisterTaskGenerationFunction("IOTMEverfullDartsGenerateTasksBeta");
void IOTMEverfullDartsGenerateTasksBeta(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (item_is_usable($item[everfull dart holster]) && available_amount($item[everfull dart holster]) > 0 && my_path().id != PATH_COMMUNITY_SERVICE)
    {
        string [int] description;
        string url = "inventory.php?ftext=everfull+dart_holster";
		item iref1 = $item[Everfull dart holster];
		string iref1txt1 = (have_equipped(iref1)) ? iref1+" is equipped ("+iref1.to_slot()+").":"Equip the "+iref1+" ("+iref1.to_slot()+")";
		string iref1clr = (have_equipped(iref1)) ? "green":"red";
		description.listAppend("<span style='color:"+iref1clr+";'>"+iref1txt1+"</span>");
            
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
			optional_task_entries.listAppend(ChecklistEntryMake("__item everfull dart holster", url, ChecklistSubentryMake("Everfull Darts free kill available!", "", description), -11));
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
		item iref1 = $item[Everfull dart holster];
		string iref1txt1 = (have_equipped(iref1)) ? iref1+" is equipped ("+iref1.to_slot()+").":"Equip the "+iref1+" ("+iref1.to_slot()+")";
		string iref1clr = (have_equipped(iref1)) ? "green":"red";
		description.listAppend("<span style='color:"+iref1clr+";'>"+iref1txt1+"</span>");

            
        int dartSkill = get_property_int("dartsThrown");
        int dartsNeededForNextPerk = (floor(sqrt(dartSkill)+1) **2 - dartSkill);
		int importancenum = ( get_property_boolean("kingLiberated") ) ? -40:-888;

        description.listAppend("Current dart skill: " + dartSkill);
        description.listAppend(HTMLGenerateSpanFont(dartsNeededForNextPerk, "blue") + " darts needed for next Perk");
    
		
		resource_entries.listAppend(ChecklistEntryMake("__item everfull dart holster", url, ChecklistSubentryMake("Everfull Dart Holster charging", "", description), importancenum));
    }
}