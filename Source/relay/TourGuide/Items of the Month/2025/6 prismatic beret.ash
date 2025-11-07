//prismatic beret
//RegisterResourceGenerationFunction("IOTMPrismaticBeretAlphaGenerateResource");
void IOTMPrismaticBeretAlphaGenerateResource(ChecklistEntry [int] resource_entries)
{
    if ($item[prismatic beret].available_amount() == 0) return;
    
    string url = "inventory.php?ftext=prismatic+beret";
    int busksLeft = clampi(5 - get_property_int("_beretBuskingUses"), 0, 5);
    string [int] description;
    string title = HTMLGenerateSpanFont(busksLeft + " Prismatic Beret Busks", "purple");
    
    int total;
    item thing;
    foreach it in $slots[] {
        thing = equipped_item(it);
        if (thing != $item[none])
        total += get_power(thing);
    }
    
    if (busksLeft > 0) 
    {
        description.listAppend("Gain buffs based on current equipment Power");
        description.listAppend("Currently " + (HTMLGenerateSpanFont(total, "blue")) + " Power");
        resource_entries.listAppend(ChecklistEntryMake("__item prismatic beret", url, ChecklistSubentryMake(title, "", description)));
    }
}