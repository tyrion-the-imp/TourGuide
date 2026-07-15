//monodent of the sea
RegisterResourceGenerationFunction("IOTMMonodentGenerateResource");
void IOTMMonodentGenerateResource(ChecklistEntry [int] resource_entries)
{
    // TODO: tile updates:
    //   - remove indigo/blue, no need for color on this


	if (!__iotms_usable[lookupItem("monodent of the sea")]) return;

	// it is important to name things properly
	string [int] dentPrefixes = { 'Mono', 'Bi', 'Tri', 'Qua', 'Penta', 'Hexa', 'Hepta', 'Octo', 'Nona', 'Deca' };
	int constructs = get_property('seadentConstructKills').to_int();
	int level = clampi(get_property('seadentLevel').to_int(), 1, 10);
	string prefix = dentPrefixes[level - 1];

	string monodentName = prefix + "dent of the sea";
	string monodentShortName = prefix + "dent";

    string url = "inventory.php?ftext=dent+of+the+sea";
	int monodentLightningsLeft = clampi(11 - get_property_int("_seadentLightningUsed"), 0, 11);
    boolean monodentWaveUsed = get_property_boolean("_seadentWaveUsed");
	string monodentWaveZone = get_property("_seadentWaveZone");
	string [int] description;
	string title = "Seaworthy "+monodentShortName+" powers!";
	boolean monodentIsEquipped = lookupItem("monodent of the sea").equipped_amount() > 0;
	int equipimplvl = -40;
	if	( !get_property_boolean("kingLiberated") ) { equipimplvl = -8888; }
	item iref1 = $item[Monodent of the Sea];
	string iref1txt1 = (have_equipped(iref1)) ? iref1+" is equipped ("+iref1.to_slot()+").":"Equip the "+iref1+" ("+iref1.to_slot()+")";
	string iref1clr = (have_equipped(iref1)) ? "green":"red";
	description.listAppend("<span style='color:"+iref1clr+";'>"+iref1txt1+"</span>");
	
	if (!monodentWaveUsed) {
		description.listAppend(HTMLGenerateSpanFont("Flood a zone for +30% item/meat", "blue"));		
	}
	else if (monodentWaveUsed) {
		description.listAppend(HTMLGenerateSpanFont(monodentWaveZone + " flooded, +30 item/meat", "indigo"));	
		if ($effect[fishy].have_effect() < 1 && lookupItem("monodent of the sea").equipped_amount() == 0) {
			description.listAppend(HTMLGenerateSpanFont("Equip "+monodentShortName+" for Fishy?", "red"));		
		}		
	}
	if (monodentLightningsLeft > 0) {
		description.listAppend("Killbanish, preserves drops. " + monodentLightningsLeft + " left.");
	}
	
	int monodentUpgrades = get_property_int("seadentConstructKills");
	if (monodentUpgrades < 100) {
		int constructsNeededForNextPerk = floor(sqrt(monodentUpgrades) + 1) ** 2 - monodentUpgrades;
        description.listAppend("Current upgrades: " + monodentUpgrades + "/100");
        description.listAppend((HTMLGenerateSpanFont(constructsNeededForNextPerk, "blue")) + " constructs needed for upgrade");
    }
	
	resource_entries.listAppend(ChecklistEntryMake("__item monodent of the sea", url, ChecklistSubentryMake(title, "who lives in a monodent under the sea", description), equipimplvl));

	// Banish combination tile
	if (monodentLightningsLeft > 0)
    {
        string [int] banishDesc;
		
		
		banishDesc.listAppend("Turn-taking kill, all-day banish.");
		if (!monodentIsEquipped) banishDesc.listAppend(HTMLGenerateSpanFont("Equip the "+monodentName+" first", "red"));
		resource_entries.listAppend(ChecklistEntryMake("__item monodent of the sea", "", ChecklistSubentryMake(pluralise(monodentLightningsLeft, "lightning strike", "lightning strikes"), "", banishDesc), equipimplvl).ChecklistEntrySetCombinationTag("banish").ChecklistEntrySetIDTag("seadent killbanish"));
    }
}