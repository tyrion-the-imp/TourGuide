//Spring shoes
RegisterTaskGenerationFunction("IOTMSpringShoesGenerateTasksBETA");
void IOTMSpringShoesGenerateTasksBETA(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	if (__misc_state["in run"] && available_amount($item[spring shoes]) > 0 && my_path().id != PATH_COMMUNITY_SERVICE)
	{
		if ($effect[everything looks green].have_effect() == 0) 
		{
			string [int] description;
			string url = "inventory.php?ftext=spring+shoes";
			description.listAppend(HTMLGenerateSpanFont("Run away from your problems!", "green"));
			if (lookupItem("spring shoes").equipped_amount() == 0)
			{
				description.listAppend(HTMLGenerateSpanFont("Equip the spring shoes first.", "red"));
			}
			task_entries.listAppend(ChecklistEntryMake("__item spring shoes", url, ChecklistSubentryMake("Spring shoes runaway available! (TEMP)", "", description), -11));
		}
	}
}