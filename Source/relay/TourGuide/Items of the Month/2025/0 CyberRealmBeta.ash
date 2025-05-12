int CyberFree = get_property_int("_cyberFreeFights");
	if (!have_skill($skill[OVERCLOCK(10)])) { CyberFree = 10; }
int cyberTurns = get_property_int("_cyberZone1Turns") + get_property_int("_cyberZone2Turns") + get_property_int("_cyberZone3Turns");
int usedNum = max(cyberTurns,CyberFree);
CyberFree = usedNum;


//CyberRealm
RegisterTaskGenerationFunction("IOTYCyberRealmGenerateTasks");
void IOTYCyberRealmGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	if ($item[server room key].available_amount() < 1) return;
	
	int zone1Turns = get_property_int("_cyberZone1Turns");
	int zone2Turns = get_property_int("_cyberZone2Turns");
	int zone3Turns = get_property_int("_cyberZone3Turns");
	int CyberZoneUsed = zone1turns + zone2turns + zone3turns;
	string [int] description;
	string url = "place.php?whichplace=CyberRealm";
	string image_name = "__skill stats+++";
	item fitmw = $item[familiar-in-the-middle wrapper];
		
	description.listAppend(HTMLGenerateSpanFont("familiar-in-the-middle wrapper", "gray"));
	
	if ($item[familiar-in-the-middle wrapper].available_amount() == 0) {
		description.listAppend(HTMLGenerateSpanFont("You don't have an FITMW (+'1' / fight)", "red"));
	}
	else if ($item[familiar-in-the-middle wrapper].equipped_amount() == 1) {
		description.listAppend(HTMLGenerateSpanFont("FITMW equipped. Extra 1 per fight.", "blue"));
	}
	else if ($item[familiar-in-the-middle wrapper].equipped_amount() == 0) {
		description.listAppend(HTMLGenerateSpanFont("Equip your FITMW for an extra 1 per fight.", "red"));
	}
	
	#if (zone1Turns < 20)
	{
		if (zone1Turns < 9) {			
			description.listAppend(9 - zone1Turns + " combats until Zone 1 Eleres test.");
		}
		else if (zone1Turns == 9)
		{
			description.listAppend(HTMLGenerateSpanFont("Get 11 eleres for the Cyberzone 1 test", "blue"));
			image_name = "__skill overclock(10)";
		}
		else if (zone1Turns < 19) 
		{			
			description.listAppend(19 - zone1Turns + " combats until Zone 1 reward.");
		}
		else if (zone1Turns == 19)
		{
			description.listAppend(HTMLGenerateSpanFont("Cyberzone 1 reward!", "green"));
			image_name = "__skill sleep(5)";
		}
		else if (zone1Turns > 19) {
			description.listAppend(HTMLGenerateSpanFont("Cyberzone 1 finished.", "grey"));
		}
	}
	
	#if (zone2Turns < 20)
	{
		if (zone2Turns < 9) {
			description.listAppend(9 - zone2Turns + " combats until Zone 2 Eleres test.");
		}
		else if (zone2Turns == 9)
		{
			description.listAppend(HTMLGenerateSpanFont("Get 11 eleres for the Cyberzone 2 test", "blue"));
			image_name = "__skill overclock(10)";
		}
		else if (zone2Turns < 19) 
		{			
			description.listAppend(19 - zone2Turns + " combats until Zone 2 reward.");
		}
		else if (zone2Turns == 19)
		{
			description.listAppend(HTMLGenerateSpanFont("Cyberzone 2 reward!", "green"));
			image_name = "__skill sleep(5)";
		}
		else if (zone2Turns > 19) {
			description.listAppend(HTMLGenerateSpanFont("Cyberzone 2 finished.", "grey"));
		}
	}
	
	#if (zone3Turns < 20)
	{
		if (zone3Turns < 9) {
			description.listAppend(9 - zone3Turns + " combats until Zone 3 Eleres test.");
		}
		else if (zone3Turns == 9)
		{
			description.listAppend(HTMLGenerateSpanFont("Get 11 eleres for the Cyberzone 3 test", "blue"));
			image_name = "__skill overclock(10)";
		}
		else if (zone3Turns < 19) 
		{			
			description.listAppend(19 - zone3Turns + " combats until Zone 3 reward.");
		}
		else if (zone3Turns == 19)
		{
			description.listAppend(HTMLGenerateSpanFont("Cyberzone 3 reward!", "green"));
			image_name = "__skill sleep(5)";
		}
		else if (zone3Turns > 19) {
			description.listAppend(HTMLGenerateSpanFont("Cyberzone 3 finished.", "grey"));
		}
	}
	
	if (($locations[Cyberzone 1,Cyberzone 2,Cyberzone 3] contains __next_adventure_location) && have_skill($skill[OVERCLOCK(10)]) && CyberZoneUsed < 60 ) {
		description.listAppend(HTMLGenerateSpanFont("Have used " + usedNum + " turns in server room.", "blue"));
		description.listAppend(HTMLGenerateSpanFont("Have " + max(10 - CyberFree,0) + " free fights left!", "green"));
		task_entries.listAppend(ChecklistEntryMake(image_name, url, ChecklistSubentryMake(60 - CyberZoneUsed + " CyberRealm adventures!", "", description), -103));
	}
	else {
		if ( have_skill($skill[OVERCLOCK(10)]) ) {
			description.listAppend(HTMLGenerateSpanFont("Have used " + usedNum + " turns in server room.", "blue"));
			description.listAppend(HTMLGenerateSpanFont("Have " + max(10 - CyberFree,0) + " free fights left!", "green"));
		}
		else if (!have_skill($skill[OVERCLOCK(10)])) {
			description.listAppend(HTMLGenerateSpanFont("Gain skill OVERCLOCK(10) for 10 free fights.", "red"));
		}
		else	{
			description.listAppend(HTMLGenerateSpanFont("No free fights left", "red"));
		}
		
		if	( CyberZoneUsed == 60 ) {
			clear(description);
			//description[0] = "Try again tomorrow.";
			optional_task_entries.listAppend(ChecklistEntryMake(image_name, url, ChecklistSubentryMake(60 - CyberZoneUsed + " CyberRealm adventures!", "Try again tomorrow.", description), -101));
		} else {
			optional_task_entries.listAppend(ChecklistEntryMake(image_name, url, ChecklistSubentryMake(60 - CyberZoneUsed + " CyberRealm adventures!", "", description), -101));
		}
	}
}


RegisterResourceGenerationFunction("IOTMCyberRealmBetaGenerateResource");
void IOTMCyberRealmBetaGenerateResource(ChecklistEntry [int] resource_entries) {
	string [int] description;
	string url = "place.php?whichplace=CyberRealm";
	string image_name = "__skill stats+++";
	if (!have_skill($skill[OVERCLOCK(10)])) { CyberFree = 10; }
	if (cyberfree < 10 && have_skill($skill[OVERCLOCK(10)])) {
		description.listAppend(HTMLGenerateSpanFont("Have " + (10 - CyberFree) + " free Cyberzone fights left!", "green"));
		resource_entries.listAppend(ChecklistEntryMake(image_name, url, ChecklistSubentryMake((10 - CyberFree) + " CyberRealm free adventures!", "", description), -11).ChecklistEntrySetCombinationTag("daily free fight").ChecklistEntrySetIDTag("Cyber realm free fights"));
	}
}