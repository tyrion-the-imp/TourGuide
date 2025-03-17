//Roman Candelabra
RegisterTaskGenerationFunction("IOTMRomanCandelabraGenerateTasksTEMP");
void IOTMRomanCandelabraGenerateTasksTEMP(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if ($item[roman candelabra].available_amount() == 0) return;

    string url = "inventory.php?ftext=Roman+Candelabra";

    // Extra runaway nag for spring shoes unhavers
	// && $item[spring shoes].available_amount() == 0
    if ($effect[Everything Looks Green].have_effect() == 0)
    {
        string [int] description;
        //description.listAppend(HTMLGenerateSpanFont("Green candle runaway!", "green"));
        description.listAppend(HTMLGenerateSpanFont("Blow the Green Candle!, a free runaway, Myst. enchant +5, +30 ELG", "green"));
        if (lookupItem("Roman Candelabra").equipped_amount() == 0) {
            description.listAppend(HTMLGenerateSpanFont("Equip the Roman Candelabra first.", "red"));
        }
        else {
            description.listAppend(HTMLGenerateSpanFont("Candelbra equipped", "green"));
        }
		
		if (get_property_boolean("kingLiberated")) {
			optional_task_entries.listAppend(ChecklistEntryMake("__item Roman Candelabra", url, ChecklistSubentryMake("Roman Candelabra runaway available!", "", description), -11));
		} else {
			task_entries.listAppend(ChecklistEntryMake("__item Roman Candelabra", url, ChecklistSubentryMake("Roman Candelabra runaway available!", "", description), -10));
		}
    }

    // Purple people beater
    if ($effect[Everything Looks Purple].have_effect() == 0)
    {
        string [int] description;
		description.listAppend(HTMLGenerateSpanFont("Blow the Purple Candle!, a chained combat copy, Mox enchant +5, +50 ELP", "purple"));
        if (lookupItem("Roman Candelabra").equipped_amount() == 0)
        {
            description.listAppend(HTMLGenerateSpanFont("Equip the Roman Candelabra first.", "red"));
        }
        else
        {
            description.listAppend(HTMLGenerateSpanFont("Candelbra equipped", "green"));
        }
		
		if (get_property_boolean("kingLiberated")) {
			optional_task_entries.listAppend(ChecklistEntryMake("__item Roman Candelabra", url, ChecklistSubentryMake("Roman Candelabra purple ray chained copy fight ready!", "", description), -11));
		} else {
			task_entries.listAppend(ChecklistEntryMake("__item Roman Candelabra", url, ChecklistSubentryMake("Roman Candelabra purple ray chained copy fight ready!", "", description), -10));
		
		}
    }

    // Extra runaway nag for spring shoes unhavers
	// && $item[spring shoes].available_amount() == 0
    if ($effect[Everything Looks Yellow].have_effect() == 0)
    {
        string [int] description;
        //description.listAppend(HTMLGenerateSpanFont("Green candle runaway!", "green"));
        description.listAppend(HTMLGenerateSpanFont("Blow the Yellow Candle!, yellow ray", "orange"));
        if (lookupItem("Roman Candelabra").equipped_amount() == 0) {
            description.listAppend(HTMLGenerateSpanFont("Equip the Roman Candelabra first.", "red"));
        }
        else {
            description.listAppend(HTMLGenerateSpanFont("Candelbra equipped", "green"));
        }
		
		if (get_property_boolean("kingLiberated")) {
			optional_task_entries.listAppend(ChecklistEntryMake("__item Roman Candelabra", url, ChecklistSubentryMake("Roman Candelabra yellow ray available!", "", description), -11));
		} else {
			task_entries.listAppend(ChecklistEntryMake("__item Roman Candelabra", url, ChecklistSubentryMake("Roman Candelabra yellow ray available!", "", description), -10));
		}
    }


    {
        string [int] description;
		//Yellow Ray
		if ($effect[Everything Looks Yellow].have_effect() == 0)
			description.listAppend(HTMLGenerateSpanFont("Blow the Yellow Candle!, yray (all items), MP enchant +10, +75 ELY", "goldenrod"));
		if ($effect[Everything Looks Red].have_effect() == 0)
			description.listAppend(HTMLGenerateSpanFont("Blow the Red Candle!, stats & h.dmg, HP enchant +10, +30 ELR", "red"));
		if ($effect[Everything Looks Blue].have_effect() == 0)
			description.listAppend(HTMLGenerateSpanFont("Blow the Blue Candle!, stun 3 rds & 25*L MP, Mus enchant +5, +20 ELB", "blue"));
        if (lookupItem("Roman Candelabra").equipped_amount() == 0)
        {
            description.listAppend(HTMLGenerateSpanFont("Equip the Roman Candelabra first.", "red"));
        }
        else
        {
            description.listAppend(HTMLGenerateSpanFont("Candelbra equipped", "green"));
        }
        optional_task_entries.listAppend(ChecklistEntryMake("__item Roman Candelabra", url, ChecklistSubentryMake("Roman Candelabra skills!", "", description), -11));
    }
}

