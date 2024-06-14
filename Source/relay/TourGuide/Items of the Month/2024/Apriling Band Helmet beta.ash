//Apriling band helmet
RegisterResourceGenerationFunction("IOTMAprilingBandHelmetGenerateResourceBeta");
void IOTMAprilingBandHelmetGenerateResourceBeta(ChecklistEntry [int] resource_entries)
{
	string [int] description;
	#if (__misc_state["in run"] && available_amount($item[apriling band helmet]) > 0 && my_path().id != PATH_COMMUNITY_SERVICE)
	if (available_amount($item[apriling band helmet]) > 0 && my_path().id != PATH_COMMUNITY_SERVICE)
	{
		//battle of the bands
		int aprilingBandConductorTimer = get_property_int("nextAprilBandTurn"); 
		string url = "inventory.php?pwd=" + my_hash() + "&action=apriling";
		
		int aprilingBandInstrumentsAvailable = clampi(2 - get_property_int("_aprilBandInstruments"), 0, 2);
		if (aprilingBandInstrumentsAvailable > 0) {
			description.listAppend(HTMLGenerateSpanFont("Can pick " + aprilingBandInstrumentsAvailable + " more instruments!", "green"));
			string url = "inventory.php?pwd=" + my_hash() + "&action=apriling";
		}
		
		if (aprilingBandConductorTimer <= total_turns_played()) {
			description.listAppend(HTMLGenerateSpanFont("You can change your tune!", "blue"));
			description.listAppend("-10% Combat Frequency");
			description.listAppend("+10% Combat Frequency");
			description.listAppend("+25% booze, +50% food, +100% candy");
		}	
		else {
			description.listAppend((aprilingBandConductorTimer - total_turns_played()) + " adventures until you can change your tune.");
		}
		resource_entries.listAppend(ChecklistEntryMake("__item apriling band helmet", url, ChecklistSubentryMake("Apriling band helmet buff", "", description), -12));
	}
	int aprilingBandSaxUsesLeft = clampi(3 - get_property_int("_aprilBandSaxophoneUses"), 0, 3);
	int aprilingBandQuadTomUsesLeft = clampi(3 - get_property_int("_aprilBandTomUses"), 0, 3);
	int aprilingBandTubaUsesLeft = clampi(3 - get_property_int("_aprilBandTubaUses"), 0, 3);
	int aprilingBandPiccoloUsesLeft = clampi(3 - get_property_int("_aprilBandPiccoloUses"), 0, 3);
	
	if ($items[Apriling band saxophone,Apriling band quad tom,Apriling band tuba,Apriling band staff,Apriling band piccolo].available_amount() > 0) {
		string [int] description2;
		string url = "inventory.php?ftext=apriling";
		if (aprilingBandSaxUsesLeft > 1 && available_amount($item[apriling band saxophone]) > 0) {
			description2.listAppend("Can play the Sax " + aprilingBandSaxUsesLeft + " more times. " + (HTMLGenerateSpanFont("LUCKY!", "green") + ""));
		}	
		if (aprilingBandQuadTomUsesLeft > 1 && available_amount($item[apriling band quad tom]) > 0) {
			description2.listAppend("Can play the Quad Toms " + aprilingBandQuadTomUsesLeft + " more times. " + (HTMLGenerateSpanFont("Sandworm!", "orange") + ""));
		}
		if (aprilingBandTubaUsesLeft > 1 && available_amount($item[apriling band tuba]) > 0) {
			description2.listAppend("Can play the Tuba " + aprilingBandTubaUsesLeft + " more times. " + (HTMLGenerateSpanFont("SNEAK!", "grey") + ""));
		}
		if (aprilingBandPiccoloUsesLeft > 1 && available_amount($item[apriling band piccolo]) > 0) {
			description2.listAppend("Can play the Piccolo " + aprilingBandPiccoloUsesLeft + " more times. " + (HTMLGenerateSpanFont("+40 fxp", "purple") + ""));
		}
		resource_entries.listAppend(ChecklistEntryMake("__item apriling band helmet", url, ChecklistSubentryMake("Apriling band instruments", "", description2), -12));
	}
}