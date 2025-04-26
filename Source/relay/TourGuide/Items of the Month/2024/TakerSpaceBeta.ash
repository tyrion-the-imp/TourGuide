//Takerspace
RegisterResourceGenerationFunction("IOTMTakerspaceGenerateResource");
void IOTMTakerspaceGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (__iotms_usable[lookupItem("TakerSpace letter of Marque")]) return;
	
	string [int] description;
	string url = "campground.php?action=workshed";
	int TSAnchors = get_property_int("takerSpaceAnchor");
	int TSGold = get_property_int("takerSpaceGold");
	int TSMasts = get_property_int("takerSpaceMast");
	int TSRum = get_property_int("takerSpaceRum");
	int TSSilk = get_property_int("takerSpaceSilk");
	int TSSpice = get_property_int("takerSpaceSpice");
	
	if (TSAnchors + TSGold + TSMasts + TSRum + TSSilk + TSSpice > 0) 
	{
		description.listAppend(HTMLGenerateSpanOfClass("Spices: ", "r_bold") + "" + TSSpice + "");
		description.listAppend(HTMLGenerateSpanOfClass("Rum: ", "r_bold") + "" + TSRum + "");
		description.listAppend(HTMLGenerateSpanOfClass("Anchors: ", "r_bold") + "" + TSAnchors + "");
		description.listAppend(HTMLGenerateSpanOfClass("Masts: ", "r_bold") + "" + TSMasts + "");
		description.listAppend(HTMLGenerateSpanOfClass("Silk: ", "r_bold") + "" + TSSilk + "");
		description.listAppend(HTMLGenerateSpanOfClass("Gold: ", "r_bold") + "" + TSGold + "");
		
		if ($item[pirate dinghy].available_amount() == 0 ) {
			description.listAppend(HTMLGenerateSpanFont("Boat: 1 anchor/1 mast/1 silk", "blue"));
		}
		if ($item[deft pirate hook].available_amount() == 0 ) {
			description.listAppend(HTMLGenerateSpanFont("Hook: 1 anchor/1 mast/1 gold", "blue"));
		}
		if ($item[jolly roger flag].available_amount() == 0 ) {
			description.listAppend(HTMLGenerateSpanFont("Flag: 1 rum/1 mast/1 silk/1 gold", "blue"));
		}
		resource_entries.listAppend(ChecklistEntryMake("__item pirate dinghy", url, ChecklistSubentryMake("Takerspace resources", description), -30));
	}
	
	
	item ANCHBAN = $item[anchor bomb];
	string [int] description2;
    if	( available_amount(ANCHBAN) > 0 ) {
		resource_entries.listAppend(ChecklistEntryMake("__item anchor bomb", url, ChecklistSubentryMake(HTMLGenerateSpanFont(""+available_amount(ANCHBAN)+" Anchor Bomb(s) are available.", "black"), "", description2), 0).ChecklistEntrySetCombinationTag("banish").ChecklistEntrySetIDTag("anchor bombs available banish"));
    }
	if	( creatable_amount(ANCHBAN) > 0 ) {
		int curr_importance = -5000;
		string url = "campground.php?action=workshed";
		{
			//individual high-importance tile to urge creation
			description2.listAppend(""+creatable_amount(ANCHBAN)+" "+ANCHBAN+" are <span style='color:red; font-size:100%; font-weight:bold;'>creatable</span> (banisher, free)");
			resource_entries.listAppend(ChecklistEntryMake("__item anchor bomb", url, ChecklistSubentryMake(HTMLGenerateSpanFont("Anchor Bomb(s) are creatable.", "black"), "", description2), curr_importance).ChecklistEntrySetIDTag("anchor bomb banish tile"));
			//also added to banish combo tile
			resource_entries.listAppend(ChecklistEntryMake("__item anchor bomb", url, ChecklistSubentryMake(HTMLGenerateSpanFont("Anchor Bomb(s) are creatable.", "black"), "", description2), 0).ChecklistEntrySetCombinationTag("banish").ChecklistEntrySetIDTag("anchor bomb banish loose tile"));
		}
	}
	
}
