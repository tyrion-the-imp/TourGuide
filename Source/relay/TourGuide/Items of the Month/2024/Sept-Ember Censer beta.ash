//Sept-Ember Censer
RegisterResourceGenerationFunction("IOTMSeptemberSeptemberCenserGenerateResourceBeta");
void IOTMSeptemberSeptemberCenserGenerateResourceBeta(ChecklistEntry [int] resource_entries)
{
	if ($item[Sept-Ember Censer].available_amount() == 0) return;
	
	int SeptEmbers = get_property_int("availableSeptEmbers");
	string [int] description;
	float cold_resistance = numeric_modifier("cold resistance");
	int mainstat_gain = (7 * (cold_resistance) ** 1.7) * (1.0 + numeric_modifier(my_primestat().to_string() + " Experience Percent") / 100.0);
	string url = "shop.php?whichshop=september";
	string title = "Sept-Ember Censer";
	int bembershootCount = $item[bembershoot].available_amount();
	int mouthwashCount = $item[Mmm-brr! brand mouthwash].available_amount();
	int structureCount = $item[structural ember].available_amount();
	int hunkCount = $item[embering hunk].available_amount();
	boolean hulkFought = get_property_boolean("_emberingHulkFought"); 
	boolean structureUsed = get_property_boolean("_structuralEmberUsed"); 
	
	description.listAppend("Have " + (HTMLGenerateSpanFont(SeptEmbers, "red")) + " Sept-Embers to make stuff with!");
	description.listAppend("1 embers: +5 cold res accessory. (You have " + (HTMLGenerateSpanFont(bembershootCount, "red")) + " of this)");
	description.listAppend("2 embers: mmm-brr! mouthwash for " + (HTMLGenerateSpanFont(mainstat_gain, "blue")) + " mainstat. (You have " + (HTMLGenerateSpanFont(mouthwashCount, "red")) + " of this)");
	
	if (structureUsed) {
		description.listAppend((HTMLGenerateSpanFont("Already used structural ember today", "red")));
	}
	if (structureUsed == false) {
		description.listAppend("4 embers: +5/5 bridge parts (1/day).");
	}
	if (hulkFought) {
		description.listAppend((HTMLGenerateSpanFont("Already fought embering hulk today", "red")));
	}
	if (hulkFought == false) {
		description.listAppend("6 embers: embering hulk (1/day)");
	}
	description.listAppend("(You have " + (HTMLGenerateSpanFont(hunkCount, "red")) + " hunks)");

	resource_entries.listAppend(ChecklistEntryMake("__item sept-ember censer", url, ChecklistSubentryMake(title, "", description), -501));
}