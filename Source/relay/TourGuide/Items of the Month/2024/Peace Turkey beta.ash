RegisterResourceGenerationFunction("IOTMPeaceTurkeyGenerateResourceBeta");
void IOTMPeaceTurkeyGenerateResourceBeta(ChecklistEntry [int] resource_entries)
{
    if (!lookupFamiliar("Peace Turkey").familiar_is_usable()) return;
	
	item PEABAN = $item[handful of split pea soup];
    // Purkey Title
    int turkeyProc = 24 + sqrt(effective_familiar_weight($familiar[peace turkey]) + weight_adjustment());
    float PeasCount = available_amount($item[whirled peas]) + ( available_amount(PEABAN) * 2);
    string [int] description;
    string [int] description2;
	int curr_importance = -50;
	if	( creatable_amount(PEABAN) > 0 ) { curr_importance = -5009; }
    string url = "familiar.php";
    {
        description.listAppend("" + PeasCount/2 + " peabanishers available");
        description.listAppend("paste whirled peas + whirled peas <br>&raquo; handful of split pea soup");
        description.listAppend("<br>AV: " + available_amount(PEABAN)+" INV: " + item_amount(PEABAN)+" <span style='color:fuchsia; font-size:100%; font-weight:bold;'>CR: " + creatable_amount(PEABAN)+"</span>");
        description2.listAppend(PEABAN+"<br>AV: " + available_amount(PEABAN)+" INV: " + item_amount(PEABAN)+" <span style='color:fuchsia; font-size:100%; font-weight:bold;'>CR: " + creatable_amount(PEABAN)+"</span>");
        description.listAppend("percentage is Peace Turkey post-combat activation rate");
        
		//banish tile
		resource_entries.listAppend(ChecklistEntryMake("__familiar peace turkey", url, ChecklistSubentryMake(HTMLGenerateSpanFont("A "+turkeyProc +"% active Peace Turkey", "black"), "FREE run & banish 30a", description2), curr_importance).ChecklistEntrySetCombinationTag("banish").ChecklistEntrySetIDTag("handful of pea soup creatable banish"));
		
		//independent tile
		resource_entries.listAppend(ChecklistEntryMake("__familiar peace turkey", url, ChecklistSubentryMake(HTMLGenerateSpanFont("A "+turkeyProc +"% active Peace Turkey", "black"), "", description), curr_importance).ChecklistEntrySetIDTag("handful of pea soup creatable banish individual"));
    }
}