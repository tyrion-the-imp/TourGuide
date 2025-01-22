// Clan VIP Photo booth
RegisterResourceGenerationFunction("IOTMVIPPhotoBoothGenerateResourceBeta");
void IOTMVIPPhotoBoothGenerateResourceBeta(ChecklistEntry [int] resource_entries)
{
    if (available_amount($item[Clan VIP Lounge key]) < 1)
        return;

    string [int] description;
	string url = "inventory.php?ftext=sheriff";
	
    int photosLeft = clampi(3 - get_property_int("_photoBoothEffects"), 0, 3);
	if (photosLeft > 0)
	{
		description.listAppend(HTMLGenerateSpanFont("Get your photo taken:", "black"));
		description.listAppend(HTMLGenerateSpanFont("photobooth west: 50 turns of +50% init, +10 moxie, +3 moxie exp, -5% combat", "black"));
		description.listAppend(HTMLGenerateSpanFont("photobooth tower: 50 turns of +50HP, +10 muscle, +3 muscle exp, +5% combat", "black"));
		description.listAppend(HTMLGenerateSpanFont("photobooth space: 50 turns of +50MP, +10 myst, +3 myst exp, +10-30 mp regen", "black"));
		
		resource_entries.listAppend(ChecklistEntryMake("__item expensive camera", url, ChecklistSubentryMake(photosLeft + " clan photos takeable BETA", description), 8));
	}
	//this here town ain't big enough for the two of us
    int sheriffings = clampi(3 - get_property_int("_assertYourAuthorityCast"), 0, 3);
	if (sheriffings > 0)
	{
		if (lookupItem("sheriff badge").equipped_amount() == 1 && lookupItem("sheriff moustache").equipped_amount() == 1 && lookupItem("sheriff pistol").equipped_amount() == 1)
		{
			description.listAppend(HTMLGenerateSpanFont("Assert your authority!", "blue"));
		} 
		else 
		{
			description.listAppend(HTMLGenerateSpanFont("Equip your sheriff gear first.", "red"));
		}
	resource_entries.listAppend(ChecklistEntryMake("__item badge of authority", url, ChecklistSubentryMake(sheriffings + " Sheriff Authority free kill(s) BETA", description), -65));
	}
}