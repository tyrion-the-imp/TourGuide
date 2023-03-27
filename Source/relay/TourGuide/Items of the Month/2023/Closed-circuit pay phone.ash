//Shadow phone
RegisterResourceGenerationFunction("ClosedCircuitPayPhoneGenerateResourceOLD");
void ClosedCircuitPayPhoneGenerateResourceOLD(ChecklistEntry [int] resource_entries)
{
    if (!__misc_state["in run"]) return;
    string [int] description;
    int shadowLodestones = available_amount($item[Rufus's shadow lodestone]);
    
    int RufusQuestItems;
    string url;
    for i from 1 to 6
    {
        RufusQuestItems += i*available_amount(to_item(11169+i));
    }
    if (RufusQuestItems > 0)
    {
        description.listAppend(HTMLGenerateSpanFont("xGive Rufus that shadow quest item to get a lodestone!", "blue") + "");
        resource_entries.listAppend(ChecklistEntryMake("__item Rufus's shadow lodestone", url, ChecklistSubentryMake("xShadow lodestone usable", "", description), 5));
    }
    
    if ($item[Rufus's shadow lodestone].available_amount() > 0)
    {
        description.listAppend("x30 advs of +100% init, +100% item, +200% meat, -10% combat.");
        description.listAppend("xTriggers on next visit to any Shadow Rift.");
        resource_entries.listAppend(ChecklistEntryMake("__item Rufus's shadow lodestone", url, ChecklistSubentryMake("xShadow lodestone usable", "", description), 5));
    }
    //https://kol.coldfront.net/thekolwiki/index.php/Shadow_Rifts#Loot
	if (!get_property_boolean("_shadowAffinityToday") || have_effect($effect[Shadow Affinity]) > 0 ) {
		description.listAppend("x<a href='https://kol.coldfront.net/thekolwiki/index.php/Shadow_Rifts#Loot' target='_blank'><span style='color:blue; font-size:100%; font-weight:normal;'>Shadow_Rifts#Loot table</span></a>");
		
		if	( have_effect($effect[Shadow Affinity]) == 0 ) {
			resource_entries.listAppend(ChecklistEntryMake("__effect Shadow Affinity", "", ChecklistSubentryMake("xShadow Rift info", "", description), 5).ChecklistEntrySetCombinationTag("daily free fight").ChecklistEntrySetIDTag("pay phone free fight"));
		}
	}
    /* if (!get_property_boolean("_shadowAffinityToday"))
    {
        description.listAppend("Call Rufus to get 11 free Shadow Rift combats.");
        resource_entries.listAppend(ChecklistEntryMake("__effect Shadow Affinity", "", ChecklistSubentryMake("Shadow Affinity free fights", "", description), 5).ChecklistEntrySetCombinationTag("daily free fight").ChecklistEntrySetIDTag("pay phone free fight"));
    } */
    
	if ( have_effect($effect[Shadow Affinity]) > 0 )
	{
		description.listAppend("xShadow Rift combats.");
		resource_entries.listAppend(ChecklistEntryMake("__effect Shadow Affinity", "", ChecklistSubentryMake(have_effect($effect[Shadow Affinity])+" xShadow Affinity free fights remain", "", description), 5).ChecklistEntrySetCombinationTag("daily free fight").ChecklistEntrySetIDTag("pay phone free fight"));
	}
	
}

//20230325 https://github.com/uthuluc/TourGuide/blob/master/iotm2023shadowphone
RegisterTaskGenerationFunction("IOTMClosedCircuitPayPhoneGenerateTasks");
void IOTMClosedCircuitPayPhoneGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	string [int] description;
	string [int] description2;
	int riftAdvsUntilNC = get_property_int("encountersUntilSRChoice");
	if (riftAdvsUntilNC == 0)
	{
		description2.listAppend(HTMLGenerateSpanFont("Fight a boss or get an artifact", "black"));
		task_entries.listAppend(ChecklistEntryMake("__item shadow bucket", "", ChecklistSubentryMake("Shadow Rift NC up next", "", description2), -11));
	}
	if (get_property("questRufus").contains_text("step1"))
	{
		string url = "inv_use.php?pwd=" + my_hash() + "&which=3&whichitem=11169";
		description2.listAppend(HTMLGenerateSpanFont("Call Rufus and get a lodestone", "black"));
		task_entries.listAppend(ChecklistEntryMake("__item closed-circuit pay phone", url, ChecklistSubentryMake("Rufus quest done", "", description2), -11));
	}
	else if (get_property("questRufus").contains_text("started"))
	{
		string url = "inv_use.php?pwd=" + my_hash() + "&which=3&whichitem=11169";
		description2.listAppend(HTMLGenerateSpanFont("Finish the quest to get a lodestone.", "black"));
		description2.listAppend(HTMLGenerateSpanFont(riftAdvsUntilNC + " encounters until NC/boss.", "black"));
		optional_task_entries.listAppend(ChecklistEntryMake("__item closed-circuit pay phone", url, ChecklistSubentryMake("Rufus quest in progress", "", description2), -11));
	}
	if ($effect[Shadow Affinity].have_effect() > 0) 
	{
		int shadowRiftFightsDoableRightNow = $effect[Shadow Affinity].have_effect();
		description.listAppend(HTMLGenerateSpanFont("Shadow Rift fights are free!", "purple"));
		description.listAppend(HTMLGenerateSpanFont("(don't use other free kills in there)", "black"));
		task_entries.listAppend(ChecklistEntryMake("__effect Shadow Affinity", "", ChecklistSubentryMake(shadowRiftFightsDoableRightNow + " Shadow Rift free fights", "", description), -11));
	}
	
}		
		
RegisterResourceGenerationFunction("IOTMClosedCircuitPayPhoneGenerateResource");
void IOTMClosedCircuitPayPhoneGenerateResource(ChecklistEntry [int] resource_entries)
{
	#if (!__misc_state["in run"]) return;
	string [int] description;
	string [int] description2;
	int shadowLodestones = available_amount($item[Rufus's shadow lodestone]);
	
	int RufusQuestItems;
	string url = "inv_use.php?pwd=" + my_hash() + "&which=3&whichitem=11169";
	for i from 1 to 6
	{
		RufusQuestItems += i*available_amount(to_item(11169+i));
	}
	
	if ($item[Rufus's shadow lodestone].available_amount() > 0)
    {
        description2.listAppend("30 advs of +100% init, +100% item, +200% meat, -10% combat.");
		description2.listAppend("Triggers on next visit to any Shadow Rift.");
		resource_entries.listAppend(ChecklistEntryMake("__item Rufus's shadow lodestone", url, ChecklistSubentryMake("Rufus's shadow lodestone noncom", description2), -11));
    }
	if (RufusQuestItems > 0)
	{
		description2.listAppend(HTMLGenerateSpanFont("Give Rufus that shadow quest item to get a lodestone!", "blue") + "");
		resource_entries.listAppend(ChecklistEntryMake("__item closed-circuit pay phone", url, ChecklistSubentryMake("Rufus's shadow lodestone noncom", description2), -11));
	}
	
	if (!get_property_boolean("_shadowAffinityToday"))
    {
        description.listAppend("Call Rufus to get 11+ free Shadow Rift combats.");
		resource_entries.listAppend(ChecklistEntryMake("__effect Shadow Affinity", url, ChecklistSubentryMake("Shadow Affinity free fights", "", description), -11).ChecklistEntrySetCombinationTag("daily free fight").ChecklistEntrySetIDTag("Shadow affinity free fights"));

	//shadow bricks
	int shadowBricks = available_amount($item[shadow brick]);
	int shadow_brick_uses_left = clampi(13 - get_property_int("_shadowBricksUsed"), 0, 13);
	string url = "inventory.php?ftext=shadow+brick";
	if ($item[shadow brick].available_amount() > 0)
        {
            string header = $item[shadow brick].pluralise().capitaliseFirstLetter();
            int shadow_brick_uses_left = clampi(13 - get_property_int("_shadowBricksUsed"), 0, 13);
            if (shadow_brick_uses_left < $item[shadow brick].available_amount())
            {
                if (shadow_brick_uses_left == 0)
                    header += " (not usable today)";
                else
                    header += " (" + shadow_brick_uses_left + " usable today)";
            }
            resource_entries.listAppend(ChecklistEntryMake("__item shadow brick", "", ChecklistSubentryMake(header, "", "Win a fight without taking a turn.")).ChecklistEntrySetCombinationTag("free instakill"));
        }
	}
}