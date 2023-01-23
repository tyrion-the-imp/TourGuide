RegisterResourceGenerationFunction("IOTMKGBriefcaseGenerateResource");
void IOTMKGBriefcaseGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (!__iotms_usable[lookupItem("kremlin's greatest briefcase")]) return;
    ChecklistEntry entry;
    entry.image_lookup_name = "__item Kremlin's Greatest Briefcase";
    entry.importance_level = 5;
    entry.url = "place.php?whichplace=kgb";
    entry.tags.id = "Kremlin Briefcase resource";
    if (get_property_int("_kgbTranquilizerDartUses") < 3 && my_path().id != PATH_POCKET_FAMILIARS)
    {
        string [int] description;
        description.listAppend("Free run/banishes for twenty turns.|Use the KGB tranquilizer dart skill in-combat.");
        if (lookupItem("kremlin's greatest briefcase").equipped_amount() == 0)
        {
		    description.listAppend(HTMLGenerateSpanFont("Equip the briefcase first!", "red"));
            entry.url = "inventory.php?ftext=kremlin";
        }
        resource_entries.listAppend(ChecklistEntryMake("__item Kremlin's Greatest Briefcase", entry.url, ChecklistSubentryMake(pluralise(3 - get_property_int("_kgbTranquilizerDartUses"), "briefcase dart", "briefcase darts"), "", description)).ChecklistEntrySetCombinationTag("banish").ChecklistEntrySetIDTag("Kremlin Briefcase tranq dart banish"));
    }
    int clicks_remaining = clampi(22 - get_property_int("_kgbClicksUsed"), 0, 22);
    if (!mafiaIsPastRevision(18110))
        clicks_remaining = 0;
    if (clicks_remaining > 0)
    {
        string [int] description;
        description.listAppend("All sorts of things. Buffs, martinis, cigars!");
        
        entry.subentries.listAppend(ChecklistSubentryMake(pluralise(clicks_remaining, "click", "clicks"), "", description));
    }
    if (entry.subentries.count() > 0)
        resource_entries.listAppend(entry);
}
