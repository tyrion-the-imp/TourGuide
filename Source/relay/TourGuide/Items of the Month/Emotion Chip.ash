//Emotion Chip
RegisterResourceGenerationFunction("IOTMEmotionChipGenerateResource");
void IOTMEmotionChipGenerateResource(ChecklistEntry [int] resource_entries)
{
	if	( !$skill[Emotionally Chipped].skill_is_usable() ) { return; }
    ChecklistSubentry getEmotions() {
        // Title
        string main_title = "Emotion chip feelings";
        // Entries
		string [int] description;
		string [int] emotions;
 
        int emotionDisappointed = clampi(3 - get_property_int("_feelDisappointedUsed"), 0, 3);
        if (emotionDisappointed > 0)
			{
            emotions.listAppend(emotionDisappointed + "/3 Disappointments left.");
			}
        int emotionExcitement = clampi(3 - get_property_int("_feelExcitementUsed"), 0, 3);
        if (emotionExcitement > 0)
			{
            emotions.listAppend(emotionExcitement + "/3 Excitement left. 20 advs of +25 Mus/Mys/Mox.");
			}
        int emotionLonely = clampi(3 - get_property_int("_feelLonelyUsed"), 0, 3);
        if (emotionLonely > 0)
			{
            emotions.listAppend(emotionLonely + "/3 Lonelys left. 20 advs of -5% Combat.");
			}
        int emotionLost = clampi(3 - get_property_int("_feelLostUsed"), 0, 3);
        if (emotionLost > 0)
			{
            emotions.listAppend(emotionLost + "/3 Losts left. Weird Teleportitis buff.");
			}
        int emotionNervous = clampi(3 - get_property_int("_feelNervousUsed"), 0, 3);
        if (emotionNervous > 0)
			{
            emotions.listAppend(emotionNervous + "/3 Nervouses left. Passive damage.");
			}
        int emotionPeaceful = clampi(3 - get_property_int("_feelPeacefulUsed"), 0, 3);
        if (emotionPeaceful > 0)
			{
            emotions.listAppend(emotionPeaceful + "/3 Peacefuls left. 20 advs of +2 elemental resist.");
			}
        int emotionPride = clampi(3 - get_property_int("_feelPrideUsed"), 0, 3);
        if (emotionPride > 0)
			{
            emotions.listAppend(emotionPride + "/3 Prides left. Increase stat gain.");
			}
        int emotionHatred = clampi(3 - get_property_int("_feelHatredUsed"), 0, 3);
        if (emotionHatred > 0)
			{
            emotions.listAppend(emotionHatred + "/3 Hatreds left. 50-turn banish.");
			}
			resource_entries.listAppend(ChecklistEntryMake("__skill feel hatred", "", ChecklistSubentryMake(pluralise(get_property_int("_feelHatredUsed"), "Feel Hatred", "Feels Hatreds"), "", "Cast Feel Hatred. Free run/banish.")).ChecklistEntrySetCombinationTag("banish").ChecklistEntrySetIDTag("Emotion chip feel hatred banish"));
        int emotionEnvy = clampi(3 - get_property_int("_feelEnvyUsed"), 0, 3);
        if (emotionEnvy > 0)
			{
            emotions.listAppend(emotionEnvy + "/3 Envys left. Black Ray.");
			}
        int emotionNostalgic = clampi(3 - get_property_int("_feelNostalgicUsed"), 0, 3);
		int nostalgicMonster = (get_property_int("feelNostalgicMonster"));
        if (emotionNostalgic > 0)
			{
            emotions.listAppend(emotionNostalgic + "/3 Nostalgias left. Item copying. Can currently feel nostalgic for: " + nostalgicMonster);
			}
        int emotionSuperior = clampi(3 - get_property_int("_feelSuperiorUsed"), 0, 3);
        if (emotionSuperior > 0)
			{
            emotions.listAppend(emotionSuperior + "/3 Superiors left. +1 PvP Fight if used as killshot.");
			}
 
 
 
        return ChecklistSubentryMake(main_title, description, emotions);
    }
 
	ChecklistEntry entry;
    entry.image_lookup_name = "__item emotion chip";
    entry.tags.id = "emotion chip resource";
 
    ChecklistSubentry emotions = getEmotions();
    if (emotions.entries.count() > 0) {
        entry.subentries.listAppend(emotions);
    }
 
    if (entry.subentries.count() > 0) {
        resource_entries.listAppend(entry);
    }
}