RegisterResourceGenerationFunction("IOTMBoomBoxGenerateResource");
void IOTMBoomBoxGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (lookupItem("SongBoom&trade; BoomBox").available_amount() == 0)
		return;
	
	string song = get_property("boomBoxSong");
	int changes_left = get_property_int("_boomBoxSongsLeft"); //the boys are back in town, eleven times. everyone will love it
	
	int boomboxProgress = get_property_int("_boomBoxFights");
	string [int] description;
	{
		if (song == "")
		{
			song = "The Sound of Silence";
		}
		description.listAppend("Currently playing " + song + ", the soundtrack of your life!");
		description.listAppend("Currently " + boomboxProgress + "/11 fights until next drop.");
		if (boomboxProgress == 9)
		{
			description.listAppend(HTMLGenerateSpanFont("Boombox drop soon", "blue"));
		}
		if (boomboxProgress == 10)
		{
			description.listAppend(HTMLGenerateSpanFont("Boombox drop next fight", "red"));
		}
		description.listAppend("" + changes_left + " song changes left today.");
		resource_entries.listAppend(ChecklistEntryMake("__item SongBoom&trade; BoomBox", "inv_use.php?pwd=" + my_hash() + "&whichitem=9919", ChecklistSubentryMake("Boombox song stuff", "", description), -7));
	}
	
	if (song == "" && changes_left > 0)
	{
		string [int] description;
		if (!__quest_state["Level 7"].finished && my_path().id != PATH_COMMUNITY_SERVICE)
			description.listAppend("Eye of the Giger: Nightmare Fuel for the cyrpt.");
		if (fullness_limit() > 0)
			description.listAppend("Food Vibrations: extra adventures from food" + (__misc_state["in run"] ? ", +30% food drop" : "") + ".");
		description.listAppend("Total Eclipse of Your Meat: extra meat, +30% meat.");
		
		resource_entries.listAppend(ChecklistEntryMake("__item SongBoom&trade; BoomBox", "inv_use.php?pwd=" + my_hash() + "&whichitem=9919", ChecklistSubentryMake("Set BoomBox song", "", description), CHECKLIST_DEFAULT_IMPORTANCE));
	}
	
}