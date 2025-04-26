//Sept-Ember Censer
RegisterResourceGenerationFunction("IOTMSeptemberCenserGenerateResourceBeta");
void IOTMSeptemberCenserGenerateResourceBeta(ChecklistEntry [int] resource_entries)
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
	int visibility = -30;
	
	if	( creatable_amount($item[throwin' ember]) > 0 ) {
		description.listAppend(""+creatable_amount($item[throwin' ember])+" "+$item[throwin' ember]+" are creatable. (sepcen, banisher)");
		//visibility = -6000;
	}
	int creatableember = $item[throwin' ember].creatable_amount();
   if (creatableember > 0 )
    {
        //shop.php?whichshop=september
		//add to banish tile
		string cr_url = "shop.php?whichshop=september";
		resource_entries.listAppend(ChecklistEntryMake("__item throwin' ember", cr_url, ChecklistSubentryMake(pluralise($item[throwin' ember]), "", "Non-free run/banish|*("+creatableember+") throwin' ember are <span style='color:red; font-size:100%; font-weight:bold;'>creatable</span>.|*Must kill the monster?"), 0).ChecklistEntrySetCombinationTag("banish").ChecklistEntrySetIDTag("throwin' ember creatable banish"));
		//individual high-importance tile to urge creation
		resource_entries.listAppend(ChecklistEntryMake("__item throwin' ember", cr_url, ChecklistSubentryMake(pluralise($item[throwin' ember]), "", "Non-free banish|*("+creatableember+") throwin' ember are <span style='color:red; font-size:100%; font-weight:bold;'>creatable</span>.|*Must kill the monster?"), -5000).ChecklistEntrySetIDTag("throwin' ember creatable banish loose tile"));
    }
	
	description.listAppend("Have " + (HTMLGenerateSpanFont(SeptEmbers, "red")) + " Sept-Embers to make stuff with!");
	description.listAppend("1 embers: +5 cold res accessory. (You have " + (HTMLGenerateSpanFont(bembershootCount, "red")) + " of this)");
	description.listAppend("2 embers: mmm-brr! mouthwash for " + (HTMLGenerateSpanFont(mainstat_gain, "blue")) + " mainstat. (You have " + (HTMLGenerateSpanFont(mouthwashCount, "red")) + " of this)");
	
	if (structureUsed) {
		description.listAppend((HTMLGenerateSpanFont("Already used structural ember today", "red")));
	}
	else {
		description.listAppend("4 embers: +5/5 bridge parts (1/day).");
	}
	if (hulkFought) {
		description.listAppend((HTMLGenerateSpanFont("Already fought embering hulk today", "red")));
	}
	else {
		description.listAppend("6 embers: embering hulk (1/day)");
	}
	
	description.listAppend("(You have " + (HTMLGenerateSpanFont(hunkCount, "red")) + " hunks)");

	resource_entries.listAppend(ChecklistEntryMake("__item sept-ember censer", url, ChecklistSubentryMake(title, "", description), visibility));
}