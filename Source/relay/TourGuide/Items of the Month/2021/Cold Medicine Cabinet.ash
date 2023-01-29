//Cold Medicine Cabinet
RegisterTaskGenerationFunction("IOTMColdMedicineCabinetGenerateTasksAR");
void IOTMColdMedicineCabinetGenerateTasksAR(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    monster gregarious_monster = get_property_monster("beGregariousMonster");
    int fights_left = clampi(get_property_int("beGregariousFightsLeft"), 0, 3);
	string [int] description;
	
	if (gregarious_monster != $monster[none] && fights_left > 0) 
	{
        description.listAppend("Will appear in any zone, so try to find a zone with few monsters.");
	
		optional_task_entries.listAppend(ChecklistEntryMake("__monster " + gregarious_monster, "url", ChecklistSubentryMake("Fight " + pluralise(fights_left, "more gregarious " + gregarious_monster, "more gregarious " + gregarious_monster + "s"), "", "Neaaaar, faaaaaaar, wherever you aaaaaaaare, I believe that the heart does go on."), -1));
    }
}

RegisterResourceGenerationFunction("IOTMColdMedicineCabinetGenerateResourceAR");
void IOTMColdMedicineCabinetGenerateResourceAR(ChecklistEntry [int] resource_entries)
{
    
	int pill_uses_remaining = floor((spleen_limit() - my_spleen_use()) / 2.0);
	int imp = -8;
	//buy pills from mall
	if ( pill_uses_remaining > 0 && !in_hardcore() ) {
		string url = "mall.php";
		if	( !in_hardcore() && pulls_remaining() > 0 ) { imp = -8; }
		string [int] pillprices;
		if ( lookupItem("Extrovermectin&trade;").available_amount() == 0 ) {
			pillprices.listAppend("Extrovermectin&trade; @ "+rnum(historical_price($item[Extrovermectin&trade;])) + " meat |* 3 wandering copies / 1 Be Gregarious");
		}
		if ( lookupItem("Homebodyl&trade;").available_amount() == 0 ) {
			pillprices.listAppend("Homebodyl&trade; @ "+rnum(historical_price($item[Homebodyl&trade;])) + " meat |* 11 free crafts");
		}
		if ( lookupItem("Breathitin&trade;").available_amount() == 0 ) {
			pillprices.listAppend("Breathitin&trade; @ "+rnum(historical_price($item[Breathitin&trade;])) + " meat |* 5 free outdoor fights");
		}
		if ( lookupItem("Fleshazole&trade;").available_amount() == 0 ) {
			pillprices.listAppend("Fleshazole&trade; @ "+rnum(historical_price($item[Fleshazole&trade;])) + " meat |* Level x 1000 meat, max 11k");
		}
		if ( count(pillprices) > 0 ) {
			 resource_entries.listAppend(ChecklistEntryMake("__item vitamin G pill", url, ChecklistSubentryMake("Buy (& pull?) CMC pills (2 spleen/ea.)", "", pillprices), imp)); 
		}
	}
	
	
	
	//gregariousness
	int uses_remaining = get_property_int("beGregariousCharges");
	imp = -8;
	if (uses_remaining > 0 || ( lookupItem("Extrovermectin&trade;").available_amount() > 0 && pill_uses_remaining > 0 )) 
	{
        if (true) 
		{
            //The section that will be sent as a STAND-ALONE RESOURCE
            string url;
            
            string [int] description;
            description.listAppend("Be gregarious in combat, which lets you turn foe into friend!");
            description.listAppend("Extrovermectin&trade; (2 spleen): <span style='color:red; font-size:90%; font-weight:bold;'>"+lookupItem("Extrovermectin&trade;").available_amount()+"</span> available");
			string [int] gregfriends;
			if (__misc_state["in run"]) {
				gregfriends.listAppend("eldritch tentacle");
				gregfriends.listAppend("lobsterfrogman");
				gregfriends.listAppend("lynyrd");
				gregfriends.listAppend("dense liana");
				gregfriends.listAppend("drunk pygmy");
				gregfriends.listAppend("war monster");
			} else {
				gregfriends.listAppend("aftercore farming target???");
			}
			
			description.listAppend("3 Wandering copies <a href='https://kol.coldfront.net/thekolwiki/index.php/Be_Gregarious#Notes' target='_blank'><span style='color:blue; font-size:100%; font-weight:normal;'>info</span></a>:|*" + gregfriends.listJoinComponents("|*"));
			if ( uses_remaining > 0 ) { imp = -11; }
            resource_entries.listAppend(ChecklistEntryMake("__item vitamin G pill", url, ChecklistSubentryMake(uses_remaining.pluralise("gregarious handshake", "gregarious handshakes"), "", description), imp).ChecklistEntrySetIDTag("gregarious wanderer resource")); 
        }
    }
	
	//default imp may have changed above for STAND-ALONE RESOURCE
	imp = 7;
	
	//Fleshazole&trade;
	int flesh_uses_remaining = floor((spleen_limit() - my_spleen_use()) / 2.0);
	if (lookupItem("Fleshazole&trade;").available_amount() > 0 && pill_uses_remaining > 0) 
	{
        string [int] description;
		description.listAppend("Fleshazole&trade; (2 spleen): <span style='color:red; font-size:90%; font-weight:bold;'>"+lookupItem("Fleshazole&trade;").available_amount()+"</span> available");
        description.listAppend("Trade 2 spleen for "+HTMLGenerateSpanFont(min((my_level() * 1000),11000), "blue")+" meat.");
        resource_entries.listAppend(ChecklistEntryMake("__item beefy pill", "", ChecklistSubentryMake(pluralise(flesh_uses_remaining, "Fleshazole&trade; use possible<br>(Meat source)", "Fleshazole&trade; uses possible<br>(Meat source)"), "", description), imp));
    }
	
	//breathitin
	int breaths_remaining = get_property_int("breathitinCharges");
	if (breaths_remaining > 0 || ( lookupItem("Breathitin&trade;").available_amount() > 0 && pill_uses_remaining > 0 ) ) 
	{
        string [int] description;
		int biiimp = -11;
		description.listAppend("Breathitin&trade; (2 spleen): <span style='color:red; font-size:90%; font-weight:bold;'>"+lookupItem("Breathitin&trade;").available_amount()+"</span> available");
        description.listAppend("Next 5 outdoor fights become free.");
        resource_entries.listAppend(ChecklistEntryMake("__item beefy pill", "", ChecklistSubentryMake(pluralise(breaths_remaining, "free outdoor fight via Breathitin&trade;", "free outdoor fights via Breathitin&trade;")+"", "", description), biiimp).ChecklistEntrySetCombinationTag("daily free fight"));
    }
	//homebodyl Homebodyl&trade;
	int homebodyls_remaining = get_property_int("homebodylCharges");
	if (homebodyls_remaining > 0 || ( lookupItem("Homebodyl&trade;").available_amount() > 0 && pill_uses_remaining > 0 )) 
	{
        string [int] description;
		int hbimp = -5;
		description.listAppend("Homebodyl&trade; (2 spleen): <span style='color:red; font-size:90%; font-weight:bold;'>"+lookupItem("Homebodyl&trade;").available_amount()+"</span> available");
        description.listAppend("Free crafting.");
		description.listAppend("Lynyrd equipment, potions, and more.");
		if ( homebodyls_remaining > 0 ) { hbimp = -10; }
        resource_entries.listAppend(ChecklistEntryMake("__item excitement pill", "", ChecklistSubentryMake(pluralise(homebodyls_remaining, "homebodyl free craft", "homebodyl free crafts"), "", description), hbimp));
    }
	
	//consultation counter
	if (!__iotms_usable[lookupItem("cold medicine cabinet")]) return;
	//defer to 'official' tile for this resource
	
	if	( false )
	{
		int CMC_consults = clampi(5 - get_property_int("_coldMedicineConsults"), 0, 5);
		if (CMC_consults > 0) 
		{
			int next_CMC_Turn = get_property_int("_nextColdMedicineConsult");
			int next_CMC_Timer = (next_CMC_Turn - total_turns_played());
			int cmcrsrcimp = -5;
			string [int] description;
			string url = "campground.php?action=workshed";
			//shouldn't be in inventory if restricted or already in shed
			if	( __misc_state["in run"] && !get_property_boolean("_workshedItemUsed") && item_amount($item[cold medicine cabinet]) > 0 ) {
				description.listAppend(HTMLGenerateSpanFont("<span style='font-weight:bold;'>Place the Medicine Cabinet in your workshed.</span>", "red"));
				description.listAppend("You have " + CMC_consults + " consultations remaining.");
				cmcrsrcimp = -9;
				resource_entries.listAppend(ChecklistEntryMake("__item snow suit", url, ChecklistSubentryMake("Cold medicine cabinet to shed?", "", description), cmcrsrcimp));
			}
			else if ( next_CMC_Turn <= total_turns_played() )
			{
				description.listAppend(HTMLGenerateSpanFont("Get some drugs!", "red"));
				description.listAppend("You have " + CMC_consults + " consultations remaining.");
				cmcrsrcimp = -10;
				resource_entries.listAppend(ChecklistEntryMake("__item snow suit", url, ChecklistSubentryMake("The cold medicine cabinet is in session", "", description), cmcrsrcimp));
			}	
			else
			{
				description.listAppend("<span style='color:green; font-size:100%; font-weight:bold;'><span style='color:fuchsia; font-size:110%; font-weight:bold;'>"+next_CMC_Timer + "</span> advs. until your next consult.</span>");
				//resource_entries.listAppend(ChecklistEntryMake("__item snow suit", url, ChecklistSubentryMake("An apple today kept the doctor away", "", description), 8));
			
				//description.listAppend(HTMLGenerateSpanOfClass("Diagnosis: dickstabbing", "r_bold") + "");
				description.listAppend("Do 11+ combats in underground zones for 5 free kills.");
				description.listAppend("Do 11+ combats in indoor zones for a wanderer.");
				description.listAppend("Do 11+ combats in outdoor zones for 11 free crafts.");
				resource_entries.listAppend(ChecklistEntryMake("__item snow suit", url, ChecklistSubentryMake(CMC_consults.pluralise("CMC consultation", "CMC consultations" + " remaining"), "", description), cmcrsrcimp).ChecklistEntrySetIDTag("cold medicine cabinet resource")); 
			}
		}
	}
}