// Clan VIP Photo booth
RegisterResourceGenerationFunction("IOTMVIPPhotoBoothGenerateResourceEffectsBeta");
void IOTMVIPPhotoBoothGenerateResourceEffectsBeta(ChecklistEntry [int] resource_entries)
{
    if (available_amount($item[Clan VIP Lounge key]) < 1)
        return;

    string [int] description;
	string url = "clan_viplounge.php?action=photobooth";
	
    int photosLeft = clampi(3 - get_property_int("_photoBoothEffects"), 0, 3);
	if (photosLeft > 0)
	{
		description.listAppend(HTMLGenerateSpanFont("Get your photo taken:", "black"));
		description.listAppend(HTMLGenerateSpanFont("photobooth west: 50 turns of +50% init, +10 moxie, +3 moxie exp, -5% combat", "black"));
		description.listAppend(HTMLGenerateSpanFont("photobooth tower: 50 turns of +50HP, +10 muscle, +3 muscle exp, +5% combat", "black"));
		description.listAppend(HTMLGenerateSpanFont("photobooth space: 50 turns of +50MP, +10 myst, +3 myst exp, +10-30 mp regen", "black"));
		
		resource_entries.listAppend(ChecklistEntryMake("__item expensive camera", url, ChecklistSubentryMake(photosLeft + " clan photos takeable BETA", description), 8));
	}
}

RegisterResourceGenerationFunction("IOTMVIPPhotoBoothGenerateResourceFreeFightsBeta");
void IOTMVIPPhotoBoothGenerateResourceFreeFightsBeta(ChecklistEntry [int] resource_entries)
{
    string [int] description;
	string url = "inventory.php?ftext=sheriff";
	//this here town ain't big enough for the two of us
    int sheriffings = clampi(3 - get_property_int("_assertYourAuthorityCast"), 0, 3);
	if (sheriffings > 0)
	{
		clear(description);
		if (lookupItem("sheriff badge").equipped_amount() == 1 && lookupItem("sheriff moustache").equipped_amount() == 1 && lookupItem("sheriff pistol").equipped_amount() == 1)
		{
			description.listAppend(HTMLGenerateSpanFont("Assert your authority!", "blue"));
		} 
		else 
		{
			description.listAppend(HTMLGenerateSpanFont("Equip your sheriff gear first. [alias=sher]", "red"));
		}
		
		{
			description.listAppend(HTMLGenerateSpanFont(get_property("_photoBoothEquipment")+" / 3 equips from VIP photobooth used", "purple"));
			boolean[item] sheriffgear = $items[sheriff badge, sheriff moustache, sheriff pistol];
			string gearColor = "green";
			foreach i in sheriffgear {
				gearColor = "green";
				if	( i.available_amount() == 0 ) {
					//if any are red, change url
					url = "clan_viplounge.php?action=photobooth";
					gearColor = "red";
					description.listAppend(HTMLGenerateSpanFont("Obtain a "+i+" from VIP photobooth", gearColor));
				} else { description.listAppend(HTMLGenerateSpanFont("Have: "+i, gearColor)); }
			}
			resource_entries.listAppend(ChecklistEntryMake("__item badge of authority", url, ChecklistSubentryMake(sheriffings + " Sheriff Authority free kill(s) BETA", description), -65).ChecklistEntrySetCombinationTag("daily free fight").ChecklistEntrySetIDTag("sheriff gear free fights"));
		}
	}
}