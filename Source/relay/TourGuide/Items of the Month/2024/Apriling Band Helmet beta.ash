// Apriling band helmet
RegisterResourceGenerationFunction("IOTMAprilingBandHelmetGenerateResourceBETA");
void IOTMAprilingBandHelmetGenerateResourceBETA(ChecklistEntry [int] resource_entries)
{
    if (available_amount($item[apriling band helmet]) < 1)
        return;

    string [int] description;

    //battle of the bands
    int aprilingBandConductorTimer = get_property_int("nextAprilBandTurn");
    string url = "inventory.php?pwd=" + my_hash() + "&action=apriling";
	int resrc_importance = -150;

    foreach e in $effects[Apriling Band Patrol Beat,Apriling Band Battle Cadence,Apriling Band Celebration Bop,] {
		if	( have_effect(e) > 0 ) {
			description.listAppend("Current tune: <b>"+e+"</b> (<font color='blue'>"+string_modifier(e,"Modifiers")+"</font>)");
		}
	}
	
	if (aprilingBandConductorTimer <= total_turns_played()) {
        description.listAppend(HTMLGenerateSpanFont("You can change your tune!", "blue"));
        if ($effect[Apriling Band Patrol Beat].have_effect() > 0) {
            description.listAppend(HTMLGenerateSpanFont("-10% Combat Frequency ~ Beat", "blue"));
            description.listAppend("+10% Combat Frequency ~ Cadence");
            description.listAppend("+25% booze, +50% food, +100% candy ~ Bop");
        }
        if ($effect[Apriling Band Battle Cadence].have_effect() > 0) {
            description.listAppend("-10% Combat Frequency ~ Beat");
            description.listAppend(HTMLGenerateSpanFont("+10% Combat Frequency ~ Cadence", "blue"));
            description.listAppend("+25% booze, +50% food, +100% candy ~ Bop");
        }
        if ($effect[Apriling Band Celebration Bop].have_effect() > 0) {
            description.listAppend("+10% Combat Frequency ~ Cadence");
            description.listAppend("-10% Combat Frequency ~ Beat");
            description.listAppend(HTMLGenerateSpanFont("+25% booze, +50% food, +100% candy ~ Bop", "blue"));
        }
		if ($effect[Apriling Band Patrol Beat].have_effect() == 0 && $effect[Apriling Band Battle Cadence].have_effect() == 0 && $effect[Apriling Band Celebration Bop].have_effect() == 0) {
            description.listAppend("<b>No Apriling Effects are active</b>");
            description.listAppend("+10% Combat Frequency ~ Cadence");
            description.listAppend("-10% Combat Frequency ~ Beat");
            description.listAppend("+25% booze, +50% food, +100% candy ~ Bop");
		}
    }
    else {
        description.listAppend((aprilingBandConductorTimer - total_turns_played()) + " adventures until you can change your tune.");
    }
    resource_entries.listAppend(ChecklistEntryMake("__item apriling band helmet", url, ChecklistSubentryMake("Apriling band helmet buff", "", description), resrc_importance));

    int aprilingBandSaxUsesLeft = clampi(3 - get_property_int("_aprilBandSaxophoneUses"), 0, 3);
    int aprilingBandQuadTomUsesLeft = clampi(3 - get_property_int("_aprilBandTomUses"), 0, 3);
    int aprilingBandTubaUsesLeft = clampi(3 - get_property_int("_aprilBandTubaUses"), 0, 3);
    int aprilingBandPiccoloUsesLeft = clampi(3 - get_property_int("_aprilBandPiccoloUses"), 0, 3);
    int instrumentUses = get_property_int("_aprilBandSaxophoneUses") +
        get_property_int("_aprilBandTomUses") +
        get_property_int("_aprilBandTubaUses") +
        get_property_int("_aprilBandPiccoloUses");

    string [int] instrumentDescription;

    int aprilingBandInstrumentsAvailable = clampi(2 - get_property_int("_aprilBandInstruments"), 0, 2);
    if (aprilingBandInstrumentsAvailable > 0) {
        instrumentDescription.listAppend(HTMLGenerateSpanFont("Can pick " + aprilingBandInstrumentsAvailable + " more instruments!", "green"));
    }

    if (instrumentUses < 6) {
        string url = "inventory.php?ftext=apriling";
        if (aprilingBandSaxUsesLeft > 0) {
            instrumentDescription.listAppend(`Can play the Sax {aprilingBandSaxUsesLeft} more times. {HTMLGenerateSpanFont("LUCKY!", "green")}`);
        }
        if (aprilingBandQuadTomUsesLeft > 0) {
            instrumentDescription.listAppend(`Can play the Quad Toms {aprilingBandQuadTomUsesLeft} more times. {HTMLGenerateSpanFont("Sandworm!", "orange")}`);
        }
        if (aprilingBandTubaUsesLeft > 0) {
            instrumentDescription.listAppend(`Can play the Tuba {aprilingBandTubaUsesLeft} more times. {HTMLGenerateSpanFont("SNEAK!", "grey")}`);
        }
        if (aprilingBandPiccoloUsesLeft > 0) {
            instrumentDescription.listAppend(`Can play the Piccolo {aprilingBandPiccoloUsesLeft} more times. {HTMLGenerateSpanFont("+40 fxp", "purple")}`);
        }
		foreach i in $items[apriling band saxophone,apriling band quad tom,apriling band tuba,apriling band piccolo] {
			if	( available_amount(i) > 0 ) {
				instrumentDescription.listAppend("You currently have an: "+i);
				if	( i.contains_text("sax") ) {
					instrumentDescription.listAppend("You have used it: "+get_property("_aprilBandSaxophoneUses")+" of 3 times");
				}
				if	( i.contains_text("quad") ) {
					instrumentDescription.listAppend("You have used it: "+get_property("_aprilBandTomUses")+" of 3 times");
				}
				if	( i.contains_text("tuba") ) {
					instrumentDescription.listAppend("You have used it: "+get_property("_aprilBandTubaUses")+" of 3 times");
				}
				if	( i.contains_text("picc") ) {
					instrumentDescription.listAppend("You have used it: "+get_property("_aprilBandPiccoloUses")+" of 3 times");
				}
			}
		}
		instrumentDescription.listAppend("You have used "+instrumentUses+" of 6 possible instrument uses.");
		
        resource_entries.listAppend(ChecklistEntryMake("__item apriling band helmet", url, ChecklistSubentryMake("Apriling band instruments", "", instrumentDescription), resrc_importance));
    }
}
