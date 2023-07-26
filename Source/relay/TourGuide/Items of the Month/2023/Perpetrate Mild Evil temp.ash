//Mild evil
RegisterResourceGenerationFunction("MildEvilGenerateResourceTemp");
void MildEvilGenerateResourceTemp(ChecklistEntry [int] resource_entries)
{
    if (!lookupSkill("Perpetrate Mild Evil").have_skill()) return;
    
    int evilPocketsLeft = clampi(3 - get_property_int("_mildEvilPerpetrated"), 0, 3);
    string url;
    string [int] description;

    if (get_property_int("_mildEvilPerpetrated") < 3) {
        description.listAppend((evilPocketsLeft).pluralise("evilpocket", "evilpockets") + " remaining.");
        
        resource_entries.listAppend(ChecklistEntryMake("__effect Ancestral Disapproval", "", ChecklistSubentryMake(pluralise(evilPocketsLeft, "Mild Evil use", "Mild Evil uses"), "", description), 8).ChecklistEntrySetIDTag("evilpockets"));
    }
}