//Sept-Ember Censer
RegisterResourceGenerationFunction("IOTMSeptemberCenserGenerateResourceBeta");
void IOTMSeptemberCenserGenerateResourceBeta(ChecklistEntry [int] resource_entries)
{
	if ($item[Sept-Ember Censer].available_amount() == 0) return;
	
	int SeptEmbers = get_property_int("availableSeptEmbers");
	string [int] description;
	float cold_resistance = numeric_modifier("cold resistance");
	int mainstat_gain = (7 * (cold_resistance) ** 1.7) * (1.0 + numeric_modifier(my_primestat().to_string() + " Experience Percent") / 100.0);
	item BOOM = $item[throwin' ember];
	string url = "shop.php?whichshop=september";
	string title = "Sept-Ember Censer";
	int bembershootCount = $item[bembershoot].available_amount();
	int mouthwashCount = $item[Mmm-brr! brand mouthwash].available_amount();
	int structureCount = $item[structural ember].available_amount();
	int hunkCount = $item[embering hunk].available_amount();
	boolean hulkFought = get_property_boolean("_emberingHulkFought"); 
	boolean structureUsed = get_property_boolean("_structuralEmberUsed"); 
	int visibility = -30;
	
	if	( creatable_amount(BOOM) > 0 ) {
		//description.listAppend(""+creatable_amount(BOOM)+" "+BOOM+" are creatable. (sepcen, banish 30a)");
		//visibility = -6000;
	}
	int creatableember = BOOM.creatable_amount();
	int onhandember = BOOM.item_amount();
	int avember = BOOM.available_amount();
	string boomnums = " <span style='color:red; font-size:100%; font-weight:bold;'>CR: "+creatableember+"</span> INV: "+item_amount(BOOM)+" AV: "+BOOM.available_amount()+"";
	string boominf = " ban 30a, use turn, alias sepcen";
	
   if (creatableember > 0 || avember > 0 )
    {
        //shop.php?whichshop=september
		//add to banish tile
		string cr_url = "shop.php?whichshop=september";
		resource_entries.listAppend(ChecklistEntryMake("__item throwin' ember", cr_url, ChecklistSubentryMake(pluralise(BOOM), boomnums+" [+turn, 30a, sepcen]", ""), visibility).ChecklistEntrySetCombinationTag("banish").ChecklistEntrySetIDTag("throwin' ember creatable banish"));
		
		if	( creatableember > 0 ) {
			//individual high-importance tile to urge creation
			resource_entries.listAppend(ChecklistEntryMake("__item throwin' ember", cr_url, ChecklistSubentryMake(pluralise(BOOM), boomnums+" [+turn, 30a, sepcen]", ""), -5000).ChecklistEntrySetIDTag("throwin' ember creatable banish loose tile"));
		}
    }
	
	
	
	description.listAppend("<b>Have (" + (HTMLGenerateSpanFont(SeptEmbers, "red")) + ") Sept-Embers to make stuff with!</b>");
	description.listAppend("1 embers: +5 cold res accessory. ("+HTMLGenerateSpanFont(bembershootCount, "red")+")"+clrindent+" bembershoot (melts)");
	description.listAppend("2 embers: mmm-brr! mouthwash ("+HTMLGenerateSpanFont(mouthwashCount, "red")+") " +clrindent+ HTMLGenerateSpanFont(mainstat_gain, "blue") + " mainstat/ea");
	description.listAppend("2 embers: throwin' ember ("+HTMLGenerateSpanFont(avember, "red")+")");
	
	description.listAppend(clrindent2+boomnums);
	description.listAppend(clrindent2+boominf);
	
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
	
	description.listAppend(clrindent2+$item[embering hunk]+" (" + (HTMLGenerateSpanFont(hunkCount, "red")) + ")");

	resource_entries.listAppend(ChecklistEntryMake("__item sept-ember censer", url, ChecklistSubentryMake(title, "", description), visibility));
}