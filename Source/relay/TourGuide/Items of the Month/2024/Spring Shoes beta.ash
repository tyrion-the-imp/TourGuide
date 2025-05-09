//Spring shoes
RegisterTaskGenerationFunction("IOTMSpringShoesGenerateTasksBETA");
void IOTMSpringShoesGenerateTasksBETA(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	//if (__misc_state["in run"] && available_amount($item[spring shoes]) > 0 && my_path().id != PATH_COMMUNITY_SERVICE)
	if ( __iotms_usable[lookupItem("spring shoes")] )
	{
		if ( $effect[everything looks green].have_effect() == 0 ) {
			string [int] description;
			string url = "inventory.php?ftext=spring+shoes";
			int importance = -10;
			if	( get_property_boolean("kingLiberated") ) { importance = -1; }
			description.listAppend(HTMLGenerateSpanFont("Run away from your problems! (+30 ELG)", "green"));
			if (lookupItem("spring shoes").equipped_amount() == 0)
			{
				description.listAppend(HTMLGenerateSpanFont("Equip the spring shoes first.", "red"));
			}
			task_entries.listAppend(ChecklistEntryMake("__item spring shoes", url, ChecklistSubentryMake("Free-run away with <b>Spring Away</b> skill! (TEMP)", "", description), importance));
		}
		//if ( $item[spring shoes].available_amount() > 0 && get_property("questL10Garbage").index_of("started") > -1 ) {
		if ( get_property("questL10Garbage").index_of("started") > -1 ) {
			//questL10Garbage = 'step1' after stalk planted, so display while 'unstarted' or 'started'
			string [int] description;
			string url = "inventory.php?ftext=spring+shoes";
			description.listAppend(HTMLGenerateSpanFont("Gain 1000 stats when planting the enchanted bean.", "green"));
			optional_task_entries.listAppend(ChecklistEntryMake("__item spring shoes", url, ChecklistSubentryMake("Beanstalk bonus!", "", description), -11));
		}
	}
}

RegisterResourceGenerationFunction("IOTMSpringShoesGenerateResourceTEMP");
void IOTMSpringShoesGenerateResourceTEMP(ChecklistEntry [int] resource_entries)
{
	// Initialization. Do not generate iof you don't have spring shoes.
	if (!__iotms_usable[lookupItem("spring shoes")]) return;

	string [int] banishDescription;
	banishDescription.listAppend("All day banish, doesn't end combat (TEMP)");
	if (lookupItem("spring shoes").equipped_amount() == 0)
	{
		banishDescription.listAppend(HTMLGenerateSpanFont("Equip the spring shoes first.", "red"));
	}
	resource_entries.listAppend(ChecklistEntryMake("__skill spring shoes", "", ChecklistSubentryMake("Spring Kick (non-free)", "", banishDescription)).ChecklistEntrySetCombinationTag("banish").ChecklistEntrySetIDTag("Spring shoes spring kick banish"));
}