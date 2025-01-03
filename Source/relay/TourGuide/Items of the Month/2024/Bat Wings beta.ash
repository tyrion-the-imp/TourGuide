// Bat Wings
RegisterResourceGenerationFunction("IOTMBatWingsGenerateResource");
void IOTMBatWingsGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (available_amount($item[bat wings]) < 1)
        return;

    string [int] description;
	string url = "inventory.php?ftext=bat+wings";
	
    //save the city of gotpork, battyman!
    int batWingSwoopsLeft = clampi(11 - get_property_int("_batWingsSwoopUsed"), 0, 11);
	int batWingRestsLeft = clampi(11 - get_property_int("_batWingsRestUsed"), 0, 11);
	int batWingCauldronsLeft = clampi(11 - get_property_int("_batWingsCauldronUsed"), 0, 11);
	int batWingFreeFlapsLeft = clampi(5 - get_property_int("_batWingsFreeFights"), 0, 5);
	int bridge = get_property_int("chasmBridgeProgress");
	
	if (lookupItem("bat wings").equipped_amount() == 0)
	{
		description.listAppend(HTMLGenerateSpanFont("Equip your bat wings.", "red"));
	}
	else
	{
		description.listAppend(HTMLGenerateSpanFont("Nanananananananana Battyman!", "purple"));
	}
	if (!$location[The Castle in the Clouds in the Sky (Basement)].locationAvailable()) {
        description.listAppend(HTMLGenerateSpanFont("This saves turns in the Airshit!", "blue"));
	}
	if (batWingSwoopsLeft == 0)
	{
		description.listAppend(HTMLGenerateSpanFont("0 Swoop Evilpockets left.", "red"));
	}
	else
	{
		description.listAppend("Swoop Evilpockets: " + (HTMLGenerateSpanOfClass(batWingSwoopsLeft, "r_bold")) + " left.");
	}
	if (batWingRestsLeft == 0)
	{
		description.listAppend(HTMLGenerateSpanFont("0 Bat Rests left.", "red"));
	}
	else
	{
		description.listAppend("Rest +1000 HP/MP: " + (HTMLGenerateSpanOfClass(batWingRestsLeft, "r_bold")) + " left.");
	}
	if (batWingCauldronsLeft == 0)
	{
		description.listAppend(HTMLGenerateSpanFont("0 Cauldron Summons left.", "red"));
	}
	else
	{
		description.listAppend("Bat Cauldron group damage: " + (HTMLGenerateSpanOfClass(batWingCauldronsLeft, "r_bold")) + " left.");
	}
	if (batWingFreeFlapsLeft == 0)
	{
		description.listAppend(HTMLGenerateSpanFont("0 Free Flaps left.", "red"));
	}
	else
	{
		description.listAppend("Free flaps: " + (HTMLGenerateSpanOfClass(batWingFreeFlapsLeft, "r_bold")) + " left.");
	}
	
	if (bridge >= 25 && !locationAvailable($location[Oil Peak])) {
		description.listAppend("You can skip the rest of the bridge!");
	}
	if (($locations[A Mob of Zeppelin Protesters] contains __last_adventure_location)) {
		description.listAppend("This does... something useful!");
	}
	
	if (!get_property_boolean("batWingsGuanoJunction")) {
		description.listAppend("Visit the Bat Hole zones to unlock the Beanbat Chamber and get a bean");
	}

	resource_entries.listAppend(ChecklistEntryMake("__item bat wings", url, ChecklistSubentryMake("Bat Wings functions", "", Description), -500));
}