//Book of Facts
RegisterTaskGenerationFunction("IOTMBookofFactsGenerateTasks");
void IOTMBookofFactsGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    // Exit out of the tile if they have neither skill and we don't actually think they should, either
    if (!lookupSkill("Just the Facts").have_skill() && !__iotms_usable[$item[book of facts (dog-eared)]]) return;
	
	monster habitat_monster = get_property_monster("_monsterHabitatsMonster");
    int fights_left = clampi(get_property_int("_monsterHabitatsFightsLeft"), 0, 5);
	string [int] description;

	// If they have an eagle, remind them they can eagle-banish to make it easier to find the habitat guys
	string eagleString = lookupFamiliar("Patriotic Eagle").familiar_is_usable() ? "; remember, you can phylum-banish with your Patriotic Eagle to make it easier!" : "." ;
	
	if (habitat_monster != $monster[none] && fights_left > 0) 
	{
        description.listAppend("Neaaaar, faaaaaaar, wherever you spaaaaaaar, I believe that the heart does go onnnnn.");
		description.listAppend("Appears as a wandering monster in any zone. Try a place with few competing monsters"+eagleString);
		optional_task_entries.listAppend(ChecklistEntryMake("__monster " + habitat_monster, "", ChecklistSubentryMake("Fight " + pluralise(fights_left, "more non-native " + habitat_monster, "more non-native " + habitat_monster + "s"), "", description), -4));
    }

	// Moving priority on this down a tiny bit due to in-run mediocrity
	int circadianAdv = (get_property_int("_circadianRhythmsAdventures"));
	if ($effect[Recalling Circadian Rhythms].have_effect() > 0 && circadianAdv < 10) {
        string [int] circadianDescription;
		string circadianPhylum = (get_property("_circadianRhythmsPhylum"));
		circadianDescription.listAppend("Fight " + (11 - circadianAdv) + " more " + circadianPhylum + "s to get RO advs.");
        task_entries.listAppend(ChecklistEntryMake("__item cheap wind-up clock", "", ChecklistSubentryMake("Circadian Rhythms turngen", circadianDescription), -1).ChecklistEntrySetIDTag("Circadian Rhythms turngen"));
    }
}

RegisterResourceGenerationFunction("IOTMBookofFactsGenerateResource");
void IOTMBookofFactsGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (!lookupSkill("Just the Facts").have_skill() && !__iotms_usable[$item[book of facts (dog-eared)]]) return;
	string [int] description;
	string [int] circadianDescription;

	// Populating different things based on run state & IOTM availability
	string constructDescriptor = __iotms_usable[$item[X-32-F snowman crate]] ? " + snojo" : "";
	if (lookupItem("[glitch season reward name]").item_amount() > 0) constructDescriptor += " + glitch"; 
	string dudeDescriptor = __iotms_usable[$item[Witchess Set]] ? " + witchess" : "";
	if (__iotms_usable[lookupItem("Neverending Party invitation envelope")]) dudeDescriptor += " + NEP"; 
	string horrorDescriptor = lookupItem("closed-circuit pay phone").have() ? " + shadow rifts" : "";
	
	if (!get_property_boolean("_circadianRhythmsRecalled")) {
        circadianDescription.listAppend("Can recall Circadian Rhythms to get +11 RO adv.");
		circadianDescription.listAppend("Good targets: construct (nightstands"+constructDescriptor+"), dudes (pygmies"+dudeDescriptor+"), horrors (copied tentacles"+horrorDescriptor+")");
        resource_entries.listAppend(ChecklistEntryMake("__item cheap wind-up clock", "", ChecklistSubentryMake("Circadian Rhythms turngen", circadianDescription), 11).ChecklistEntrySetIDTag("Circadian Rhythms turngen"));
    }
	
	int habitatRecallsLeft = clampi(3 - get_property_int("_monsterHabitatsRecalled"), 0, 3);
    if (get_property_int("_monsterHabitatsRecalled") < 3) {
        description.listAppend("Good targets include monsters you want 6 of:");
		description.listAppend("Fantasy bandit, eldritch tentacle, black crayon monsters, halloween monsters.");
        resource_entries.listAppend(ChecklistEntryMake("__item hey deze map", "", ChecklistSubentryMake(pluralise(habitatRecallsLeft, "Habitat recall", "Habitat recalls"), "", description), -12).ChecklistEntrySetIDTag("habitat recalls"));
    }

	// TODO: Once mt_rand is exposed, show on-path wishes. Not really doable yet lol
	string [int] BOFAdropsDescription;
	int BOFApocketwishes = clampi(3 - get_property_int("_bookOfFactsWishes"), 0, 3);
	if (get_property_int("_bookOfFactsWishes") < 3) {
        BOFAdropsDescription.listAppend("" + BOFApocketwishes + " BOFA wishes available.");
    }

	// Not going to remove this because I think it's valid right now but once mt_rand is 
	//   properly exposed it would be good to hide this if the user is in a seed where 
	//   they can't really access tatters...
	int BOFAtatters = clampi(11 - get_property_int("_bookOfFactsTatters"), 0, 11);
	if (get_property_int("_bookOfFactsTatters") < 11) {
        BOFAdropsDescription.listAppend("" + BOFAtatters + " BOFA tatters available.");
	}
	resource_entries.listAppend(ChecklistEntryMake("__item book of facts", "", ChecklistSubentryMake(("Miscellaneous valuable BOFA drops"), "", BOFAdropsDescription), 8).ChecklistEntrySetIDTag("bofa tatters"));
}
