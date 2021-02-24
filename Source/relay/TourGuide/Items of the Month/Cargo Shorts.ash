RegisterResourceGenerationFunction("IOTMCargoCultistShortsGenerateResource");
void IOTMCargoCultistShortsGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (lookupItem("cargo cultist shorts").available_amount() == 0 || get_property_boolean("_cargoPocketEmptied")) return;
 
	//Generate some possibly useful pockets
	string [int] description;
	string [int] useful_pocket;
	string [int][int] table;
 
	//Stat pockets
	if (my_primestat() == $stat[muscle])
		useful_pocket[161] = "   +250 mainstat";
	else if (my_primestat() == $stat[mysticality])
		useful_pocket[37] = "   +250 mainstat";
	else if (my_primestat() == $stat[moxie])
		useful_pocket[277] = "   +250 mainstat";
 
    table.listAppend(listMake(HTMLGenerateSpanOfClass("Pocket", "r_bold"), HTMLGenerateSpanOfClass("For", "r_bold")));
	foreach digit, reason in useful_pocket {
		table.listAppend(listMake(digit, reason));
	}
	description.listAppend("Stat Pockets" + "|*" + HTMLGenerateSimpleTableLines(table));
 
 
	//Fight pockets
	useful_pocket = {};
	table = {};
	useful_pocket[565] = "Mountain Man (ore)";
	useful_pocket[568] = "War Pledge (war outfit)";
	useful_pocket[666] = "Smut Orc Pervert (bridge building materials)";
	useful_pocket[220] = "Lobsterfrogman (gunpowder)";
 
    table.listAppend(listMake(HTMLGenerateSpanOfClass("Pocket", "r_bold"), HTMLGenerateSpanOfClass("For", "r_bold")));
	foreach digit, reason in useful_pocket {
		table.listAppend(listMake(digit, reason));
	}
	description.listAppend("Fight Pockets" + "|*" + HTMLGenerateSimpleTableLines(table));
 
 
	//Effects pockets
	useful_pocket = {};
	table = {};
	useful_pocket[343] = "Filthworm Drone Stench (filthworms)";
 
    table.listAppend(listMake(HTMLGenerateSpanOfClass("Pocket", "r_bold"), HTMLGenerateSpanOfClass("For", "r_bold")));
	foreach digit, reason in useful_pocket {
		table.listAppend(listMake(digit, reason));
	}
	description.listAppend("Effect Pockets" + "|*" + HTMLGenerateSimpleTableLines(table));
 
	string url = "inventory.php?action=pocket";
	resource_entries.listAppend(ChecklistEntryMake("__item Cargo Cultist Shorts", url, ChecklistSubentryMake("Explore a pocket", "", description), 0));
}