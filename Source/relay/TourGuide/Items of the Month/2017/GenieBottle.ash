RegisterResourceGenerationFunction("IOTMGenieBottleGenerateResource");
void IOTMGenieBottleGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (lookupItem("genie bottle").item_amount() + lookupItem("pocket wish").item_amount() + lookupItem("replica genie bottle").item_amount() == 0) return;

    // Detect replica versus genie classic for the purposes of the URL
    string activeGenieID = lookupItem("replica genie bottle").available_amount() > 0 ? "11234" : "9529";
    
    int wishes_left = 0;

    // Add up all possible wish sources; pocket wishes, replicas, and genie bottles
    if (__misc_state["in run"] && in_ronin())
        wishes_left += lookupItem("pocket wish").item_amount();
    if (lookupItem("genie bottle").item_amount() > 0 && mafiaIsPastRevision(18219) && my_path().id != PATH_BEES_HATE_YOU)
        wishes_left += clampi(3 - get_property_int("_genieWishesUsed"), 0, 3);
    if (lookupItem("replica genie bottle").item_amount() > 0)
        wishes_left += clampi(3 - get_property_int("_genieWishesUsed"), 0, 3);

    string [int] description;
    
    if (wishes_left > 0)
    {

        activeGenieID = get_property_int("_genieWishesUsed") >= 3 ? "9537" : activeGenieID;
        
        // URL to the correct genie as per activeGenieID
        string url = "inv_use.php?pwd=" + my_hash() + "&whichitem=" + activeGenieID;

        boolean [monster] invalid_monsters = $monsters[ninja snowman assassin, modern zmobie, giant swarm of ghuol whelps, screambat, monstrous boiler];
        string potential_monsters = SFaxGeneratePotentialFaxes(true, invalid_monsters).listJoinComponents("|<hr>");
        if (potential_monsters != "")
	        description.listAppend("Could fight a monster:<br>" + potential_monsters);
		description.listAppend("pocket wishes = "+available_amount($item[pocket wish])+"");
		description.listAppend("_genieFightsUsed = "+get_property("_genieFightsUsed")+" / 3");
        resource_entries.listAppend(ChecklistEntryMake("__item genie bottle", url, ChecklistSubentryMake(pluralise(wishes_left, "wish", "wishes"), "", description), -79).ChecklistEntrySetIDTag("Genie bottle resource"));
		//-50 level is copyings stuff
    }
}
