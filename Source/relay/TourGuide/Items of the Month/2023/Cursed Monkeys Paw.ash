//Cursed monkey's paw
RegisterResourceGenerationFunction("IOTMCursedMonkeysPawGenerateResource");
void IOTMCursedMonkeysPawGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (!lookupItem("cursed monkey's paw").have()) return;
    
    string url;
	string [int] description;
	url = "main.php?action=cmonk&pwd=" + my_hash() + "";
	description.listAppend("Wish for items or effects:");
	
	int monkey_wishes_left = clampi(5 - get_property_int("_monkeyPawWishesUsed"), 0, 5);
	string [int] options;
    if (__misc_state["in run"] && my_path().id != 25)
	{
		if (locationAvailable($location[the batrat and ratbat burrow]) == true && locationAvailable($location[the boss bat's lair]) == false)
		{	
			options.listAppend("sonar-in-a-biscuit");
		}
		if (locationAvailable($location[the hidden temple]) == true && locationAvailable($location[the hidden park]) == false)
		{	
			options.listAppend("stone wool");
		}
		if (locationAvailable($location[the penultimate fantasy airship]) == true && locationAvailable($location[the castle in the clouds in the sky (basement)]) == false)
		{	
			options.listAppend("plot amulet, mohawk wig, SGEEAs");
		}
		if (my_ascensions() > get_property_int("hiddenTavernUnlock")) {
			options.listAppend("book of matches");
		}	
		if (get_property_int("twinPeakProgress") < 13);
		{	
			options.listAppend("rusty hedge trimmers");
		}
		if (get_property_int("desertExploration") < 100);
		{	
			options.listAppend("killing jar");
		}
        if (get_property_int("zeppelinProtestors") < 80) {
			options.listAppend("Buff: Dirty Pear / +100 Sleaze");
		}
		if (__quest_state["Level 11 Ron"].mafia_internal_step < 5)
		{	
			options.listAppend("glark cables");
		}
    	if ($item[spectre scepter].available_amount() < 1)
		{
			options.listAppend("short writ of habeas corpus");
		}	
        if ($item[mega gem].available_amount() < 1)
		{
			options.listAppend("lion oil, bird rib");
		}
		if (locationAvailable($location[the oasis]) == true && get_property_int("desertExploration") < 100)
		{	
			options.listAppend("drum machine");
		}
		if (!__quest_state["Level 12"].finished)
            options.listAppend("green smoke bombs");
		if ($item[Richard's star key].available_amount() < 1)
		{	
			options.listAppend("star chart");
		}
		if ($item[digital key].available_amount() < 1)
		{
			options.listAppend("Buff: Frosty");
		}
		if ($item[wand of nagamar].available_amount() < 1)
		{
			options.listAppend("lowercase N");
		}
    }
	if (!__misc_state["in run"])
	{
		if (locationAvailable($location[the ice hotel]) == true)
		{	
			options.listAppend("bag of foreign bribes");
			options.listAppend("effects");
		}
		else if (locationAvailable($location[the ice hotel]) == false)
		{	
			options.listAppend("The poors will have to settle for wishing effects.");
		}
	}
	
    if (options.count() > 0)
        description.listAppend("Possible wishes:" + options.listJoinComponents("<hr>").HTMLGenerateIndentedText());
	
	description.listAppend("" + HTMLGenerateSpanOfClass("5 fingers: ", "r_bold") + "killbanish");
	description.listAppend("" + HTMLGenerateSpanOfClass("4 fingers: ", "r_bold") + "delevel");
	description.listAppend("" + HTMLGenerateSpanOfClass("3 fingers: ", "r_bold") + "spooky delevel");
	description.listAppend("" + HTMLGenerateSpanOfClass("2 fingers: ", "r_bold") + "heal");
	description.listAppend("" + HTMLGenerateSpanOfClass("1 finger: ", "r_bold") + "Olfaction-lite?");
	description.listAppend("" + HTMLGenerateSpanOfClass("0 fingers: ", "r_bold") + "physical damage");
	//you shouldn't be able to see this at 0
	
	string image_name;
	
	if (monkey_wishes_left == 5)
		image_name = "__skill Monkey Slap";
	if (monkey_wishes_left == 4)
		image_name = "__skill Monkey Tickle";
	if (monkey_wishes_left == 3)
		image_name = "__skill Evil Monkey Eye";
	if (monkey_wishes_left == 2)
		image_name = "__skill Monkey Peace Sign";
	if (monkey_wishes_left == 1)
		image_name = "__skill Monkey Point";
	if (monkey_wishes_left == 0)
		image_name = "__skill Monkey Punch";
		
    //if (monkey_wishes_left > 0)
    if (description.count() > 0)
	{
        resource_entries.listAppend(ChecklistEntryMake(image_name, url, ChecklistSubentryMake(monkey_wishes_left + " monkey's paw wishes", "", description), -10).ChecklistEntrySetIDTag("Monkey wishes"));
	}
}
