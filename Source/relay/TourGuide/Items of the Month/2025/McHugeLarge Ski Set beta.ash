//McHugeLarge deluxe ski set		McHugeLarge duffel bag
/* 
_mcHugeLargeAvalancheUses
0
_mcHugeLargeSkiPlowUses
0
_mcHugeLargeSlashUses
0

_mcHugeLargeAvalancheUses
0
_mcHugeLargeSkiPlowUses
0
_mcHugeLargeSlashUses
3

TourGuide Resources Tiles - Use importance level for sorting by types
Importance Level			Tile type
-999						Lucky!
-100						Grimace Maps
-79							copies
-70							sneaks
-69							banish(es|ers)
-65							free fights & instakills
-60							yellow rays
-55							runaways
-50							familiars
-46							combat items
-41							familiar gear
-40							gear
-30							misc things to use....skills, items, weird, whatever
 */
RegisterResourceGenerationFunction("IOTMSkiSetGenerateResourceBeta");
void IOTMSkiSetGenerateResourceBeta(ChecklistEntry [int] resource_entries)
{
	if ($item[McHugeLarge duffel bag].available_amount() < 1) return;
        
	if ($item[McHugeLarge duffel bag].available_amount() > 0 && $item[McHugeLarge right ski].available_amount() == 0)
	{
		resource_entries.listAppend(ChecklistEntryMake("__item McHugeLarge duffel bag", "inventory.php?ftext=McHugeLarge+duffel+bag", ChecklistSubentryMake("McHugeLarge duffel bag", "", "Open it!"), -999).ChecklistEntrySetIDTag("McHugeLarge duffel bag resource"));
    }
	
	int skiAvalanchesLeft = clampi(3 - get_property_int("_mcHugeLargeAvalancheUses"), 0, 3);			//left ski: sneak (force non-com)
	int skiSlashesLeft = clampi(3 - get_property_int("_mcHugeLargeSlashUses"), 0, 3);					//left pole: olfact
	int skiPlowsLeft = clampi(3 - get_property_int("_mcHugeLargeSkiPlowUses"), 0, 11);				//right ski: delevel ~ 50
	//int skiSlashesLeft = clampi(3 - get_property_int("_mcHugeLargeSlashUses"), 0, 3);		//left ski: once per fight
	string [int] description;
	string url = "inventory.php?ftext=McHugeLarge";
	boolean[item] McHugeLargeSkiGear() {
		return $items[McHugeLarge duffel bag,McHugeLarge left pole,McHugeLarge right pole,McHugeLarge left ski,McHugeLarge right ski];
	}

	
	if (skiAvalanchesLeft > 0)
	{
		description.listAppend(HTMLGenerateSpanOfClass(skiAvalanchesLeft + " avalanches", "r_bold") + " left. Sneak!");
    //fixme: currently not supported by sneako tile
		if (lookupItem("McHugeLarge left ski").equipped_amount() == 1)
		{
			description.listAppend(HTMLGenerateSpanFont("LEFT SKI equipped!<br>(accy, sneak/forced noncom)", "green"));
		}
		else if (lookupItem("McHugeLarge left ski").equipped_amount() == 0)
		{
			description.listAppend(HTMLGenerateSpanFont("Equip the LEFT SKI first.<br>(accy, sneak/forced noncom)", "red"));
		}
	}
	
	//adds 3 copies to the cue...basically another olfact
	if (skiSlashesLeft > 0)
	{
		description.listAppend(HTMLGenerateSpanOfClass(skiSlashesLeft + " slashes", "r_bold") + " left. Track a monster.");
		if (lookupItem("McHugeLarge left pole").equipped_amount() == 1)
		{
			description.listAppend(HTMLGenerateSpanFont("LEFT POLE equipped!<br>(offhand, slash = olfact)", "green"));
		}
		else if (lookupItem("McHugeLarge left pole").equipped_amount() == 0)
		{
			description.listAppend(HTMLGenerateSpanFont("Equip the LEFT POLE first.<br>(offhand, slash = olfact)", "red"));
		}
	}
	
	if (skiPlowsLeft > 0)
	{
		description.listAppend(HTMLGenerateSpanOfClass(skiPlowsLeft + " plows", "r_bold") + " left. Delevel a monster ~ 50?");
		if (lookupItem("McHugeLarge right ski").equipped_amount() == 1)
		{
			description.listAppend(HTMLGenerateSpanFont("RIGHT SKI equipped!<br>(accy, plow = delevel)", "green"));
		}
		else if (lookupItem("McHugeLarge right ski").equipped_amount() == 0)
		{
			description.listAppend(HTMLGenerateSpanFont("Equip the RIGHT SKI first.<br>(accy, plow = delevel)", "red"));
		}
	}
	
	
	description.listAppend(HTMLGenerateSpanOfClass("1x / fight. ~50 slz.dmg + ~50 ohys.dmg", "r_bold") + "");
	if (lookupItem("McHugeLarge right pole").equipped_amount() == 1)
	{
		description.listAppend(HTMLGenerateSpanFont("RIGHT POLE equipped!<br>(weap, stab = phys/slz dmg)", "green"));
	}
	else if (lookupItem("McHugeLarge right pole").equipped_amount() == 0)
	{
		description.listAppend(HTMLGenerateSpanFont("Equip the RIGHT POLE first.<br>(weap, stab = phys/slz dmg)", "red"));
	}
	
	//https://kol.coldfront.net/thekolwiki/index.php/McHugeLarge_duffel_bag
	description.listAppend(HTMLGenerateSpanOfClass("DUFFEL BAG: ", "r_bold") + "|*<span style='color:blue;'>+15%it, MaxHP +20, c.res (+X)</span>|*<span style='color:blue;'>+5X h.dmg, +10X%init</span>|*<span style='color:blue;'>equipped with all = <span style='color:red; font-size:100%; font-weight:bold;'>eXtreme!</span></span>|*<span style='color:blue;'>(X=1 to 5=# of ski set items equipped?)</span>");
	if (lookupItem("McHugeLarge duffel bag").equipped_amount() == 1)
	{
		description.listAppend(HTMLGenerateSpanFont("DUFFEL BAG equipped!<br>(back)", "green"));
	}
	else if (lookupItem("McHugeLarge duffel bag").equipped_amount() == 0)
	{
		description.listAppend(HTMLGenerateSpanFont("Equip the DUFFEL BAG first.<br>(back)", "red"));
	}
	
	int importance_num = -42;
	boolean wearing_gear() {
		foreach i in McHugeLargeSkiGear() {
			if	( have_equipped(i) ) { return true; }
		}
		return false;
	}
	if	( wearing_gear() ) { importance_num = -542; }
	
	resource_entries.listAppend(ChecklistEntryMake("__item McHugeLarge duffel bag", url, ChecklistSubentryMake("McHugeLarge ski set skills BETA", description), importance_num));
}