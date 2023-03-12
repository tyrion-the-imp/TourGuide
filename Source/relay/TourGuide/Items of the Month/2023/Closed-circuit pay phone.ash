//Shadow phone
RegisterResourceGenerationFunction("ClosedCircuitPayPhoneGenerateResource");
void ClosedCircuitPayPhoneGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (!__misc_state["in run"]) return;
    string [int] description;
    int shadowLodestones = available_amount($item[Rufus's shadow lodestone]);
    
    int RufusQuestItems;
    string url;
    for i from 1 to 6
    {
        RufusQuestItems += i*available_amount(to_item(11169+i));
    }
    if (RufusQuestItems > 0)
    {
        description.listAppend(HTMLGenerateSpanFont("Give Rufus that shadow quest item to get a lodestone!", "blue") + "");
        resource_entries.listAppend(ChecklistEntryMake("__item Rufus's shadow lodestone", url, ChecklistSubentryMake("Shadow lodestone usable", "", description), 5));
    }
    
    if ($item[Rufus's shadow lodestone].available_amount() > 0)
    {
        description.listAppend("30 advs of +100% init, +100% item, +200% meat, -10% combat.");
        description.listAppend("Triggers on next visit to any Shadow Rift.");
        resource_entries.listAppend(ChecklistEntryMake("__item Rufus's shadow lodestone", url, ChecklistSubentryMake("Shadow lodestone usable", "", description), 5));
    }
    
    if (!get_property_boolean("_shadowAffinityToday"))
    {
        description.listAppend("Call Rufus to get 11 free Shadow Rift combats.");
        resource_entries.listAppend(ChecklistEntryMake("__effect Shadow Affinity", "", ChecklistSubentryMake("Shadow Affinity free fights", "", description), 5).ChecklistEntrySetCombinationTag("daily free fight").ChecklistEntrySetIDTag("pay phone free fight"));
    }    
    
	if ( have_effect($effect[Shadow Affinity]) > 0 )
	{
		description.listAppend("Shadow Rift combats.");
		resource_entries.listAppend(ChecklistEntryMake("__effect Shadow Affinity", "", ChecklistSubentryMake(have_effect($effect[Shadow Affinity])+" Shadow Affinity free fights remain", "", description), 5).ChecklistEntrySetCombinationTag("daily free fight").ChecklistEntrySetIDTag("pay phone free fight"));
	}
	
}