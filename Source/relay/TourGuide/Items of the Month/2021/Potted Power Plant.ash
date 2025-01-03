//Power Plant
RegisterResourceGenerationFunction("IOTMPowerPlantGenerateResource");
void IOTMPowerPlantGenerateResource(ChecklistEntry [int] resource_entries)
{
  if (!lookupItem("potted power plant").have())
    return;
  
  // cannot use plant batteries in g-lover. if the user is at d7 of g-lover they probably
  //   should pick them but i don't want to enable this tile only if it's >d7.
  if (my_path().id == PATH_G_LOVER) return; 

  // Title
  string [int] description;
  string batteriesToHarvest = (get_property("_pottedPowerPlant"));
  // Entries
  if (batteriesToHarvest != "0,0,0,0,0,0,0")
  {
    string main_title = "Power plant batteries";
    string [int] harvest;
    harvest.listAppend("Harvest your potted power plant batteries.");
    resource_entries.listAppend(ChecklistEntryMake("__item potted power plant", "inv_use.php?pwd=" + my_hash() + "&whichitem=10738", ChecklistSubentryMake(main_title, "", harvest), -29));
  }

  int batteryTotalCharge;
  string url;
  url = "inventory.php?ftext=battery+(";
  for i from 1 to 6
  {
    batteryTotalCharge += i*available_amount(to_item(10738+i));
  }
  if (batteriesToHarvest != "0,0,0,0,0,0,0") {
    description.listAppend("(Harvest your batteries for a more accurate count.)");
  }
  if (batteryTotalCharge > 3)
  {
    description.listAppend("Make " + HTMLGenerateSpanOfClass(batteryTotalCharge / 4, "r_bold") + " 9-volt batteries to Shockingly Lick.");
    description.listAppend("Alternatively, make " + HTMLGenerateSpanOfClass(batteryTotalCharge / 5, "r_bold") + " lantern batteries for a Lick and +100% item drops.");
    description.listAppend("Alternatively, make " + HTMLGenerateSpanOfClass(batteryTotalCharge / 6, "r_bold") + " car batteries for a Lick and +100% item and meat drops.");
  }
  else if (__misc_state["in run"])
  {
    description.listAppend("Can't do much with so few batteries, but you can still use them as expensive potions. Maybe save them?");
  }
  int shockingLicksAvailable = get_property_int("shockingLickCharges");
  if (shockingLicksAvailable > 0) {
    string title;
    title = HTMLGenerateSpanFont((get_property_int("shockingLickCharges")) + " Shocking Licks available", "orange");
    description.listAppend(HTMLGenerateSpanFont("This free kill is also a yellow ray!", "orange"));
    description.listAppend("Still have " + HTMLGenerateSpanOfClass(batteryTotalCharge, "r_bold") + " charge worth of batteries.");
    resource_entries.listAppend(ChecklistEntryMake("__item eternal car battery", url, ChecklistSubentryMake(title, "", description), -59).ChecklistEntrySetCombinationTag("batteries available").ChecklistEntrySetIDTag("Shocking lick free kill"));
  }
  else if (shockingLicksAvailable == 0 && batteryTotalCharge > 0)
  {
    resource_entries.listAppend(ChecklistEntryMake("__item battery (aaa)", url, ChecklistSubentryMake("Power plant battery charge: " + (batteryTotalCharge), "", description), -29).ChecklistEntrySetCombinationTag("batteries available").ChecklistEntrySetIDTag("Shocking lick free kill"));
  }

}