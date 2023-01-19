// MayDay Package
/*
RegisterResourceGenerationFunction("IOTMMayDayContractGenerateResource");
void IOTMMayDayContractGenerateResource(ChecklistEntry [int] resource_entries)
{
    if ($item[MayDay&trade; supply package].available_amount() > 0) #&& in_ronin() && $item[MayDay&trade; supply package].item_is_usable())
    {
        string [int] description;
	    string url = invSearch("MayDay");
		description.listAppend("Use for 30 advs of +100% init as well as useful seeded drops (formerly ten bucks)");
		resource_entries.listAppend(ChecklistEntryMake("__item MayDay&trade; supply package", url, ChecklistSubentryMake(pluralise($item[MayDay&trade; supply package]), "", description)));
    }
}
*/

// 2022 MayDay™ supply package
// MayDay Package
RegisterResourceGenerationFunction("IOTMMayDayContractGenerateResource");
void IOTMMayDayContractGenerateResource(ChecklistEntry [int] resource_entries)
{
    //if ($item[MayDay&trade; supply package].available_amount() > 0) #&& in_ronin() && $item[MayDay&trade; supply package].item_is_usable())
	string subnotesSizePercent = "75";
    if ( get_property_boolean("hasMaydayContract") )
    {
        string [int] description;
		if ($item[MayDay&trade; supply package].available_amount() > 0) {
			description.listAppend("You have a <b>MayDay&trade; supply package</b>");
			description.listAppend("Use for 30 advs of +100% init as well as useful seeded drops.");
		}
		//meltable equipment
		if ($item[survival knife].available_amount() > 0)
			description.listAppend("<span style='color:blue;'><b>survival knife</b></span>. <span style='font-size:"+subnotesSizePercent+"%;'>(+2% desert exploration)</span>");
		if ($item[crank-powered radio on a lanyard].available_amount() > 0)
			description.listAppend("<span style='color:blue;'><b>crank-powered radio on a lanyard</b></span>. <span style='font-size:"+subnotesSizePercent+"%;'>(accy, +15 ML)</span>");
		if ($item[headlamp].available_amount() > 0)
			description.listAppend("<span style='color:blue;'><b>headlamp</b></span>. <span style='font-size:"+subnotesSizePercent+"%;'>(hat, +15% items)</span>");
		if ($item[thermal blanket].available_amount() > 0)
			description.listAppend("<span style='color:blue;'><b>thermal blanket</b></span>. <span style='font-size:"+subnotesSizePercent+"%;'>(back, +5% CR, <span style='color:blue;'>+2 c.res</span>, <span style='color:gray;'>+1 sp.res</span>)</span>");
		if ($item[atlas of local maps].available_amount() > 0)
			description.listAppend("<span style='color:blue;'><b>atlas of local maps</b></span>. <span style='font-size:"+subnotesSizePercent+"%;'>(accy, -5% CR)</span>");
		//
		//potions, sellable
		if ($item[emergency glowstick].available_amount() > 0)
			description.listAppend(" <span style='color:red;'>"+$item[emergency glowstick].available_amount()+"</span> <b>emergency glowstick</b>. <span style='font-size:"+subnotesSizePercent+"%;'>(pot, +25% items, 20a)</span>");
		if ($item[spare battery].available_amount() > 0)
			description.listAppend(" <span style='color:red;'>"+$item[spare battery].available_amount()+"</span> <b>spare battery</b>. <span style='font-size:"+subnotesSizePercent+"%;'>(pot, +20-30 MP/a, 20a)</span>");
		if ($item[space blanket].available_amount() > 0)
			description.listAppend(" <span style='color:red;'>"+$item[space blanket].available_amount()+"</span> <b>space blanket</b>. <span style='font-size:"+subnotesSizePercent+"%;'>(sell, 5000 meat)</span>");
		if ($item[single-use dust mask].available_amount() > 0)
			description.listAppend(" <span style='color:red;'>"+$item[single-use dust mask].available_amount()+"</span> <b>single-use dust mask</b>. <span style='font-size:"+subnotesSizePercent+"%;'>(pot, <span style='color:green;'>+5 st.res</span>, 20a)</span>");
		if ($item[gaffer's tape].available_amount() > 0)
			description.listAppend(" <span style='color:red;'>"+$item[gaffer's tape].available_amount()+"</span> <b>emergency glowstick</b>. <span style='font-size:"+subnotesSizePercent+"%;'>(pot, +15 Mx, +50% Mx, 20a)</span>");
		//
		//foods
		if ($item[bar of freeze-dried water].available_amount() > 0)
			description.listAppend(" <span style='color:purple;'>"+$item[bar of freeze-dried water].available_amount()+"</span> <b>bar of freeze-dried water</b>. <span style='font-size:"+subnotesSizePercent+"%;'>(<span style='color:blue;'>awesome</span>, 1F, 4a, <span style='color:gray;'>Ultrahydrated for 10a</span>)</span>");
		if ($item[expired MRE].available_amount() > 0)
			description.listAppend(" <span style='color:purple;'>"+$item[expired MRE].available_amount()+"</span> <b>expired MRE</b>. <span style='font-size:"+subnotesSizePercent+"%;'>(<span style='color:blue;'>awesome</span>, 2F, 8a, <span style='color:gray;'>3 random effects for 10a ea.</span>)</span>");
		if ($item[20-lb can of rice and beans].available_amount() > 0)
			description.listAppend(" <span style='color:purple;'>"+$item[20-lb can of rice and beans].available_amount()+"</span> <b>20-lb can of rice and beans</b>. <span style='font-size:"+subnotesSizePercent+"%;'>(<span style='color:green;'>good</span>, 15F, 45a, <span style='color:gray;'>+100 HP for 100a</span>)</span>");
		if ($item[cool mint precipice bar].available_amount() > 0)
			description.listAppend(" <span style='color:purple;'>"+$item[cool mint precipice bar].available_amount()+"</span> <b>cool mint precipice bar</b>. <span style='font-size:"+subnotesSizePercent+"%;'>(<span style='color:green;'>good</span>, 1F, 3a, <span style='color:gray;'>+10 stats/fight +15% Mu/My/Mx for 30a</span>)</span>");
		if ($item[carrot cake precipice bar].available_amount() > 0)
			description.listAppend(" <span style='color:purple;'>"+$item[carrot cake precipice bar].available_amount()+"</span> <b>carrot cake precipice bar</b>. <span style='font-size:"+subnotesSizePercent+"%;'>(<span style='color:green;'>good</span>, 1F, 3a, <span style='color:gray;'>+10% items +20% meat +15% Mu/My/Mx for 30a</span>)</span>");
		resource_entries.listAppend(ChecklistEntryMake("__item MayDay&trade; supply package", "", ChecklistSubentryMake(pluralise($item[MayDay&trade; supply package]), "", description)));
    }
}
