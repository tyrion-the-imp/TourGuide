//Library for checking if any given location is unlocked.
//Similar to canadv.ash, except there's no code for using items and no URLs are (currently) visited. This limits our accuracy.
//Currently, most locations are missing, sorry.
import "relay/TourGuide/Support/Error.ash"
import "relay/TourGuide/Support/List.ash"
import "relay/TourGuide/Support/Library.ash"
import "relay/TourGuide/Support/Campground.ash"
import "relay/TourGuide/Settings.ash"
import "relay/TourGuide/QuestState.ash"


boolean [location] __la_location_is_available;
boolean [string] __la_zone_is_unlocked;

boolean __la_commons_were_inited = false;
int __la_turncount_initialised_on = -1;


float [monster] appearance_rates_adjusted(location l, boolean account_for_queue)
{
    float [monster] source = l.appearance_rates(account_for_queue);
    
    boolean lawyers_relocated = get_property_ascension("relocatePygmyLawyer");
    boolean janitors_relocated = get_property_ascension("relocatePygmyJanitor");
    if (l == $location[the hidden park])
    {
        if (!janitors_relocated && source contains $monster[pygmy janitor])
            remove source[$monster[pygmy janitor]];
        if (!lawyers_relocated && source contains $monster[pygmy witch lawyer])
            remove source[$monster[pygmy witch lawyer]];
    }
    if (($locations[The Hidden Apartment Building,The Hidden Bowling Alley,The Hidden Hospital,The Hidden Office Building] contains l))
    {
        if (janitors_relocated && (source contains $monster[pygmy janitor]))
            remove source[$monster[pygmy janitor]];
        if (lawyers_relocated && (source contains $monster[pygmy witch lawyer]))
            remove source[$monster[pygmy witch lawyer]];
    }
    if ($locations[domed city of grimacia,domed city of ronaldus] contains l)
    {
        //appearance_rates() currently doesn't handle the relation between aliens and moonlight
        boolean [monster] aliens;
        boolean [monster] survivors;
        float actual_percent_aliens = 0.0;
        
        
        if (l == $location[domed city of grimacia])
        {
            aliens = $monsters[cat-alien,dog-alien,alielf];
            survivors = $monsters[unhinged survivor,grizzled survivor,whiny survivor];
            int grimace_phase = moon_phase() / 2;
            int grimace_darkness = abs(grimace_phase - 4);
            int grimace_light = 4 - grimace_darkness;
            if (grimace_light < 2)
                actual_percent_aliens = 0.0;
            else
                actual_percent_aliens = 8.0 * grimace_light;
        }
        else
        {
            aliens = $monsters[dogcat,hamsterpus,ferrelf];
            survivors = $monsters[unlikely survivor,overarmed survivor,primitive survivor];
            int ronald_phase = moon_phase() % 8;
            int ronald_darkness = abs(ronald_phase - 4);
            int ronald_light = 4 - ronald_darkness;
            if (ronald_light < 2)
                actual_percent_aliens = 0.0;
            else
                actual_percent_aliens = 8.0 * ronald_light;
        }
        //Readjust:
        if (actual_percent_aliens == 0.0)
        {
            foreach m, rate in source
            {
                if (aliens contains m)
                    remove source[m];
            }
        }
        else
        {
            float source_percent_aliens = 0.0;
            float source_percent_survivors = 0.0;
            foreach m, rate in source
            {
                if (aliens contains m)
                    source_percent_aliens += rate;
                if (survivors contains m)
                    source_percent_survivors += rate;
            }
            foreach m, rate in source
            {
                if (aliens contains m && source_percent_aliens != 0.0)
                    source[m] = rate / source_percent_aliens * actual_percent_aliens;
                if (survivors contains m && source_percent_survivors != 0.0)
                    source[m] = rate / source_percent_survivors * (100.0 - actual_percent_aliens);
            }
        }
        
    }
    if (l == $location[The Nemesis' Lair])
    {
        boolean [monster] all_monsters_to_remove = $monsters[hellseal guardian,Gorgolok\, the Infernal Seal (Inner Sanctum),warehouse worker,Stella\, the Turtle Poacher (Inner Sanctum),evil spaghetti cult zealot,Spaghetti Elemental (Inner Sanctum),security slime,Lumpy\, the Sinister Sauceblob (Inner Sanctum),daft punk,Spirit of New Wave (Inner Sanctum),mariachi bruiser,Somerset Lopez\, Dread Mariachi (Inner Sanctum)];
        
        boolean [monster] monsters_not_to_remove;
        if (my_class() == $class[seal clubber])
            monsters_not_to_remove = $monsters[hellseal guardian,Gorgolok\, the Infernal Seal (Inner Sanctum)];
        else if (my_class() == $class[turtle tamer])
            monsters_not_to_remove = $monsters[warehouse worker,Stella\, the Turtle Poacher (Inner Sanctum)];
        else if (my_class() == $class[pastamancer])
            monsters_not_to_remove = $monsters[evil spaghetti cult zealot,Spaghetti Elemental (Inner Sanctum)];
        else if (my_class() == $class[sauceror])
            monsters_not_to_remove = $monsters[security slime,Lumpy\, the Sinister Sauceblob (Inner Sanctum)];
        else if (my_class() == $class[disco bandit])
            monsters_not_to_remove = $monsters[daft punk,Spirit of New Wave (Inner Sanctum)];
        else if (my_class() == $class[accordion thief])
            monsters_not_to_remove = $monsters[mariachi bruiser,Somerset Lopez\, Dread Mariachi (Inner Sanctum)];
        foreach m in all_monsters_to_remove
        {
            if (monsters_not_to_remove contains m)
                continue;
            remove source[m];
        }
    }
    
    
    //change the NC rate manually when we suspect mafia got it wrong
    float original_combat_rate = 100.0 - source[$monster[none]];
    float new_combat_rate = -1.0;
    
    if (l == $location[the sleazy back alley]) //FIXME is mafia's data files incorrect, or the wiki's?
        new_combat_rate = clampf(80.0 + combat_rate_modifier(), 0, 100);
    
    // @todo Update this once mafia is fixed.
    if ($locations[The Dark Elbow of the Woods,The Dark Heart of the Woods,The Dark Neck of the Woods] contains l)
        new_combat_rate = clampf(95.0 + combat_rate_modifier(), 0, 100);
    
    if (l == $location[Inside the Palindome])
        if (!questPropertyPastInternalStepNumber("questL11Palindome", 3))
            new_combat_rate = 100.0;
    
    //Readjust:
    if (new_combat_rate == 0.0)
    {
        foreach m, rate in source
            if (rate > 0.0)
                source[m] = 0.0;
        source[$monster[none]] = 100.0;
    }
    else if (original_combat_rate != new_combat_rate && new_combat_rate > 0.0 && original_combat_rate > 0.0)
    {
        source[$monster[none]] = 100.0 - new_combat_rate;
        
        float ratio = new_combat_rate / original_combat_rate;
        foreach m, rate in source
        {
            if (m == $monster[none])
                continue;
            if (rate > 0.0)
                source[m] = rate * ratio;
        }
    }
    
    //for monsters which always appear every X adventures, which mafia returns as 0 when not about to get them.
    //Currently doesn't support cases when mafia is not aware that the encounter is periodically scheduled. Currently "peanut" from the calaginous abyss
    void averagePediodicSuperlikely(monster superlikely_monster, int frequency)
    {
        float combat_rate = clampf(100.0 - source[$monster[none]], 0.0, 100.0);
        if (combat_rate == 0.0) return;
        if (source[superlikely_monster] != 0) return;
        
        float superlikely_average_occurence = 1.0 / frequency;
        source[superlikely_monster] = superlikely_average_occurence * combat_rate;
        //If, let's say, we have 4 monsters (25% occurence), with a superlikely occuring every 2 turns (1 / 2 = 50%)
        //the 4 monsters' 25% (obviously giving 100%) + the SL's 50% give 150% combat chance: 3/2 the combat rate.
        //if we divide the 4 monsters' rate by 3/2, we get 16.6. Not quite.
        //To get them to 12.5% (which, when *4, gives 50%, which, when added the SL's rate, equals the combat rate),
        //we say that the ratio is 1 + (1 / (x-1))
        //here this gives 1 + (1 / (2-1)) = 200% = 2/1 the combat rate
        //25% (the 4 monsters' appearance rate) / (2/1) = 12.5%
        float excess_ratio = 1.0 + 1.0 / (frequency - 1);
        
        foreach m, v in source
        {
            if (m == $monster[none] || m == superlikely_monster)
                continue;
            if (v > 0.0)
                source[m] = v / excess_ratio * combat_rate / 100.0;
        }
    }

    if ($locations[Guano Junction,the Batrat and Ratbat Burrow,the Beanbat Chamber] contains l)
        $monster[screambat].averagePediodicSuperlikely(8);
    
    if (l == $location[kokomo resort])
        $monster[Brick Mulligan, the Bartender].averagePediodicSuperlikely(25);
    
    if (l == $location[The Post-Mall])
        $monster[sentient ATM].averagePediodicSuperlikely(11);
    
    
    return source;
}

float [monster] appearance_rates_adjusted(location l)
{
    return appearance_rates_adjusted(l, false);
}


float [monster] appearance_rates_cancel_nc(float [monster] base_rates)
{
    if (base_rates[$monster[none]] == 100.0) return base_rates;
    
    float combat_rate_sum = 0.0;
    foreach m, rate in base_rates
    {
        if (m == $monster[none])
            continue;
        if (rate > 0.0)
            combat_rate_sum += rate;
    }
    if (combat_rate_sum != 100.0 && combat_rate_sum != 0.0)
    {
        float divisor = combat_rate_sum / 100.0;
        
        foreach m, rate in base_rates
        {
            if (m == $monster[none])
                continue;
            if (rate > 0.0)
                base_rates[m] /= divisor;
        }
    }
    
    return base_rates;
}

float [monster] appearance_rates_adjusted_cancel_nc(location l)
{
    float [monster] base_rates = appearance_rates_adjusted(l);
    return base_rates.appearance_rates_cancel_nc();
}

//Do not call - internal implementation detail.
boolean locationAvailablePrivateCheck(location loc, Error able_to_find)
{
	string zone = loc.zone;
	
	if (zone == "KOL High School")
	{
		if (my_path().id == PATH_KOLHS)
			return true;
		return false;
	}
	if (zone == "Mothership")
	{
		if (my_path().id == PATH_BUGBEAR_INVASION)
			return true;
		return false;
	}
	if (zone == "BadMoon")
	{
		if (in_bad_moon())
			return true;
		return false;
	}
    if ($strings[Crimbo05,Crimbo14,Crimbo15,Crimbo16] contains zone)
        return false;
    if (zone == "Woods" && !__la_zone_is_unlocked["Woods"])
        return false;
    if (loc.parentdesc == "Batfellow Area")
        return limit_mode() == "batman";
    if (zone == "Spelunky Area")
        return limit_mode() == "spelunky";
    if (zone == "Twitch")
        return get_property_boolean("timeTowerAvailable");
    if (zone == "The Prince's Ball")
        return get_property("grimstoneMaskPath").to_lower_case() == "stepmother" && get_property_int("cinderellaMinutesToMidnight") > 0;
    
    if (loc == $location[hippy camp])
    {
    	//FIXME we don't know who won the war, do we? so only give information if the war hasn't started 
    	if (get_property_ascension("lastIslandUnlock"))
        {
            if (!QuestState("questL12War").started) return true;
        }
        else
        	return false;
    }
	
	switch (loc)
	{
		case $location[The Castle in the Clouds in the Sky (Ground floor)]:
			return get_property_ascension("lastCastleGroundUnlock");
		case $location[The Castle in the Clouds in the Sky (Top floor)]:
			return get_property_ascension("lastCastleTopUnlock");
		case $location[The Haunted Kitchen]:
		case $location[The Haunted Conservatory]:
            return questPropertyPastInternalStepNumber("questM20Necklace", 1);
		case $location[The Haunted Billiards Room]:
            if ($item[7301].available_amount() > 0)
                return true;
            else
                return false;
			//return get_property_ascension("lastManorUnlock");
		case $location[The Haunted Bedroom]:
		case $location[The Haunted Bathroom]:
        case $location[the haunted gallery]:
			return get_property_ascension("lastSecondFloorUnlock") && QuestState("questM21Dance").started;
        case $location[the haunted ballroom]:
            return questPropertyPastInternalStepNumber("questM21Dance", 4);
        case $location[The Haunted Laboratory]:
        case $location[The Haunted Nursery]:
        case $location[The Haunted Storage Room]:
            return questPropertyPastInternalStepNumber("questM17Babies", 1);
        case $location[The Haunted Boiler Room]:
        case $location[The Haunted Laundry Room]:
        case $location[The Haunted Wine Cellar]:
            return questPropertyPastInternalStepNumber("questL11Manor", 2);
        case $location[summoning chamber]:
            return get_property("questL11Manor") == "finished";
        case $location[the batrat and ratbat burrow]:
            return questPropertyPastInternalStepNumber("questL04Bat", 2);
        case $location[the beanbat chamber]:
            return questPropertyPastInternalStepNumber("questL04Bat", 3);
        case $location[The Unquiet Garves]:
            return true;
        case $location[The VERY Unquiet Garves]:
            return get_property("questL07Cyrptic") == "finished";
        case $location[The Wreck of the Edgar Fitzsimmons]:
            return questPropertyPastInternalStepNumber("questS02Monkees", 2);
        case $location[the boss bat\'s lair]:
        	if (get_property("questL04Bat") == "finished") return false; //area closes
            if ($location[the boss bat\'s lair].combatTurnsAttemptedInLocation() > 0)
                return true;
            return questPropertyPastInternalStepNumber("questL04Bat", 4);
		case $location[cobb\'s knob barracks]:
		case $location[cobb\'s knob kitchens]:
		case $location[cobb\'s knob harem]:
		case $location[cobb\'s knob treasury]:
			string quest_value = get_property("questL05Goblin");
			if (quest_value == "finished")
				return true;
			else if (questPropertyPastInternalStepNumber("questL05Goblin", 1))
			{
				//Inference - quest is started. If map is missing, area must be unlocked
				if ($item[cobb\'s knob map].available_amount() > 0)
					return false;
				else //no map, must be available
					return true;
			}
			//unstarted, impossible
            return false;
		case $location[Vanya\'s Castle Chapel]:
			if ($item[map to Vanya\'s Castle].available_amount() > 0)
				return true;
			return false;
		case $location[lair of the ninja snowmen]:
		case $location[the extreme slope]:
			return questPropertyPastInternalStepNumber("questL08Trapper", 3);
		case $location[the hidden park]:
			return questPropertyPastInternalStepNumber("questL11Worship", 4);
        case $location[the hidden temple]:
            return get_property_ascension("lastTempleUnlock");
		case $location[the spooky forest]:
			return __la_zone_is_unlocked["Woods"];
		case $location[The Smut Orc Logging Camp]:
			return questPropertyPastInternalStepNumber("questL09Topping", 1);
		case $location[the black forest]:
			return questPropertyPastInternalStepNumber("questL11MacGuffin", 1);
		case $location[guano junction]:
		case $location[the bat hole entrance]:
			return questPropertyPastInternalStepNumber("questL04Bat", 1);
		case $location[itznotyerzitz mine]:
			return questPropertyPastInternalStepNumber("questL08Trapper", 2);
        case $location[the arid, extra-dry desert]:
			return (questPropertyPastInternalStepNumber("questL11MacGuffin", 3) || $item[your father\'s MacGuffin diary].available_amount() > 0);
        case $location[the oasis]:
			return (get_property_int("desertExploration") > 0) && (questPropertyPastInternalStepNumber("questL11MacGuffin", 3) || $item[your father\'s MacGuffin diary].available_amount() > 0);
        case $location[the defiled alcove]:
			return questPropertyPastInternalStepNumber("questL07Cyrptic", 1) && get_property_int("cyrptAlcoveEvilness") > 0;
        case $location[the defiled cranny]:
			return questPropertyPastInternalStepNumber("questL07Cyrptic", 1) && get_property_int("cyrptCrannyEvilness") > 0;
        case $location[the defiled niche]:
			return questPropertyPastInternalStepNumber("questL07Cyrptic", 1) && get_property_int("cyrptNicheEvilness") > 0;
        case $location[the defiled nook]:
			return questPropertyPastInternalStepNumber("questL07Cyrptic", 1) && get_property_int("cyrptNookEvilness") > 0;
		case $location[south of the border]:
        case $location[The Shore\, Inc. Travel Agency]:
			return get_property_ascension("lastDesertUnlock");
        case $location[Portal to Terrible Parents]:
        case $location[Rumpelstiltskin\'s Workshop]:
        case $location[Ye Olde Medievale Villagee]:
            return (get_property("grimstoneMaskPath") == "gnome");
        case $location[the mansion of dr. weirdeaux]:
        case $location[the secret government laboratory]:
        case $location[the deep dark jungle]:
            return $item[airplane charter: Conspiracy Island].is_unrestricted() && (get_property_boolean("_spookyAirportToday") || get_property_boolean("spookyAirportAlways"));
        case $location[the fun-guy mansion]:
        case $location[sloppy seconds diner]:
        case $location[the sunken party yacht]:
            return $item[airplane charter: Spring Break Beach].is_unrestricted() && (get_property_boolean("_sleazeAirportToday") || get_property_boolean("sleazeAirportAlways"));
        case $location[Pirates of the Garbage Barges]:
        case $location[Barf Mountain]:
        case $location[The Toxic Teacups]:
        case $location[Uncle Gator\'s Country Fun-Time Liquid Waste Sluice]:
            return $item[airplane charter: Dinseylandfill].is_unrestricted() && (get_property_boolean("_stenchAirportToday") || get_property_boolean("stenchAirportAlways"));
        case $location[The SMOOCH Army HQ]:
        case $location[The Velvet / Gold Mine]:
        case $location[LavaCo&trade; Lamp Factory]:
        case $location[The Bubblin\' Caldera]:
            return $item[airplane charter: That 70s Volcano].is_unrestricted() && (get_property_boolean("_hotAirportToday") || get_property_boolean("hotAirportAlways"));
        case $location[The Ice Hotel]:
        case $location[VYKEA]:
        case $location[The Ice Hole]:
            return $item[airplane charter: The Glaciest].is_unrestricted() && (get_property_boolean("_coldAirportToday") || get_property_boolean("coldAirportAlways"));
        case $location[Kokomo Resort]:
            return $effect[Tropical Contact High].have_effect() > 0;
        case $location[Dreadsylvanian Woods]:
        case $location[Dreadsylvanian Village]:
        case $location[Dreadsylvanian Castle]:
            //FIXME not correct - does not take account whether the dungeon is open and the areas are unlocked
            return get_clan_id() > 0 && my_level() >= 15;
        case $location[A Barroom Brawl]:
            return questPropertyPastInternalStepNumber("questL03Rat", 1);
        case $location[The Laugh Floor]:
        case $location[Pandamonium Slums]:
        case $location[Infernal Rackets Backstage]:
            return get_property("questL06Friar") == "finished";
        case $location[The Degrassi Knoll Restroom]:
        case $location[The Degrassi Knoll Bakery]:
        case $location[The Degrassi Knoll Gym]:
        case $location[The Degrassi Knoll Garage]:
            return !knoll_available();
        case $location[Thugnderdome]:
            return gnomads_available() && my_basestat(my_primestat()) >= 25;
        case $location[outskirts of camp logging camp]:
        case $location[camp logging camp]:
            return canadia_available();
        ///FIXME test grimstone masks against their progress?
        case $location[Sweet-Ade Lake]:
        case $location[Eager Rice Burrows]:
        case $location[Gumdrop Forest]:
            return get_property("grimstoneMaskPath") == "witch";
        case $location[The Inner Wolf Gym]:
        case $location[Unleash Your Inner Wolf]:
            return get_property("grimstoneMaskPath") == "wolf";
        case $location[A Deserted Stretch of I-911]:
            return get_property("grimstoneMaskPath") == "hare";
        case $location[A-Boo Peak]:
        case $location[Twin Peak]:
        case $location[Oil Peak]:
            return questPropertyPastInternalStepNumber("questL09Topping", 2);
        case $location[The Icy Peak]:
            return get_property("questL08Trapper") == "finished"; //FIXME is it finished, or after defeating groar?
        case $location[the bugbear pen]:
            return knoll_available() && questPropertyPastInternalStepNumber("questM03Bugbear", 1) && get_property("questM03Bugbear") != "finished";
        case $location[post-quest bugbear pens]:
            return knoll_available() && get_property("questM03Bugbear") == "finished";
        case $location[the thinknerd warehouse]:
            return questPropertyPastInternalStepNumber("questM22Shirt", 1);
        case $location[The Overgrown Lot]:
            return questPropertyPastInternalStepNumber("questM24Doc", 1);
        case $location[The Skeleton Store]:
            if (questPropertyPastInternalStepNumber("questM23Meatsmith", 1))
                return true;
            //otherwise, don't know
            break;
        case $location[the old landfill]:
            return questPropertyPastInternalStepNumber("questM19Hippy", 1);
        case $location[The Hidden Apartment Building]:
            return get_property_int("hiddenApartmentProgress") >= 1;
        case $location[The Hidden Bowling Alley]:
            return get_property_int("hiddenBowlingAlleyProgress") >= 1;
        case $location[The Hidden Hospital]:
            return get_property_int("hiddenHospitalProgress") >= 1;
        case $location[The Hidden Office Building]:
            return get_property_int("hiddenOfficeProgress") >= 1;
        case $location[The Enormous Greater-Than Sign]:
            return my_basestat(my_primestat()) >= 45 && !get_property_ascension("lastPlusSignUnlock");
        case $location[The dungeons of doom]:
            return my_basestat(my_primestat()) >= 45 && get_property_ascension("lastPlusSignUnlock");
        case $location[The "Fun" House]:
            return questPropertyPastInternalStepNumber("questG04Nemesis", 6); //FIXME 6 is wrong, but I don't know the right value
        case $location[The Dark Neck of the Woods]:
        case $location[The Dark Heart of the Woods]:
        case $location[The Dark Elbow of the Woods]:
            return QuestState("questL06Friar").in_progress;
        case $location[The Goatlet]:
            return questPropertyPastInternalStepNumber("questL08Trapper", 1);
        case $location[The Penultimate Fantasy Airship]:
            return questPropertyPastInternalStepNumber("questL10Garbage", 2);
        case $location[anger man\'s level]:
        case $location[fear man\'s level]:
        case $location[doubt man\'s level]:
        case $location[regret man\'s level]:
            return __campground[$item[jar of psychoses (The Crackpot Mystic)]] > 0;
        case $location[the gourd!]:
            return __campground[$item[jar of psychoses (The Captain of the Gourd)]] > 0;
        case $location[The Nightmare Meatrealm]:
            return __campground[$item[jar of psychoses (The Meatsmith)]] > 0;
        case $location[A Kitchen Drawer]:
        case $location[A Grocery Bag]:
            return __campground[$item[jar of psychoses (The Pretentious Artist)]] > 0;
        case $location[Chinatown Shops]: //needs tracking for the quest? maybe use the items?
            return __campground[$item[jar of psychoses (The Suspicious-Looking Guy)]] > 0 && $item[strange goggles].available_amount() == 0;
        case $location[Triad Factory]:
            return $item[zaibatsu lobby card].available_amount() > 0 && $item[strange goggles].available_amount() == 0 && __campground[$item[jar of psychoses (The Suspicious-Looking Guy)]] > 0;
        //case $location[1st Floor, Shiawase-Mitsuhama Building]:
        //case $location[2nd Floor, Shiawase-Mitsuhama Building]:
        //case $location[3rd Floor, Shiawase-Mitsuhama Building]:
        case $location[Chinatown Tenement]:
            return $item[test site key].available_amount() > 0 && __campground[$item[jar of psychoses (The Suspicious-Looking Guy)]] > 0;
        case $location[whitey\'s grove]:
            return questPropertyPastInternalStepNumber("questG02Whitecastle", 1) || questPropertyPastInternalStepNumber("questL11Palindome", 4); //FIXME what step for questL11Palindome?
        case $location[The Road to the White Citadel]:
            return questPropertyPastInternalStepNumber("questG02Whitecastle", 2) && !questPropertyPastInternalStepNumber("questG02Whitecastle", 11); // the road closes when the White Citadel is found
        case $location[the Obligatory pirate\'s cove]:
            return get_property_ascension("lastIslandUnlock") && !(QuestState("questL12War").mafia_internal_step >= 2 && !QuestState("questL12War").finished);
        case $location[Inside the Palindome]:
            return $item[talisman o\' namsilat].equipped_amount() > 0; //technically
        case $location[The Valley of Rof L\'m Fao]:
            return QuestState("questL09Topping").finished;
        case $location[Swamp Beaver Territory]:
            return get_property_boolean("maraisBeaverUnlock");
        case $location[The Corpse Bog]:
            return get_property_boolean("maraisCorpseUnlock");
        case $location[The Dark and Spooky Swamp]:
            return get_property_boolean("maraisDarkUnlock");
        case $location[The Weird Swamp Village]:
            return get_property_boolean("maraisVillageUnlock");
        case $location[The Wildlife Sanctuarrrrrgh]:
            return get_property_boolean("maraisWildlifeUnlock");
        case $location[The Ruined Wizard Tower]:
            return get_property_boolean("maraisWizardUnlock");
        case $location[The Edge of the Swamp]:
            return QuestState("questM18Swamp").started;
        case $location[madness bakery]:
            return QuestState("questM25Armorer").started;
        case $location[sonofa beach]:
            return QuestState("questL12War").mafia_internal_step >= 2;
        case $location[the spooky gravy burrow]:
        	return QuestState("questM03Bugbear").mafia_internal_step >= 3;
        case $location[The Copperhead Club]:
            return QuestState("questL11MacGuffin").mafia_internal_step >= 3; //FIXME no idea, diary?
        case $location[A mob of zeppelin protesters]:
            return QuestState("questL11MacGuffin").mafia_internal_step >= 3; //FIXME no idea, diary?
        case $location[The Red Zeppelin]:
            return QuestState("questL11MacGuffin").mafia_internal_step >= 3 && get_property_int("zeppelinProtestors") >= 80; //FIXME not quite right, diary?; also NC needs to be visited first
		case $location[The F\'c\'le]:
            return QuestState("questM12Pirate").mafia_internal_step >= 6;
        case $location[Belowdecks]:
            return QuestState("questM12Pirate").finished;
        default:
			break;
	}
	
	ErrorSet(able_to_find, "");
	return false;
}

void locationAvailablePrivateInit()
{
	if (__la_commons_were_inited && __la_turncount_initialised_on == my_turncount())
		return;
        
    if (__la_location_is_available.count() > 0)
    {
        foreach key in __la_location_is_available
        {
            remove __la_location_is_available[key];
        }
    }
    if (__la_zone_is_unlocked.count() > 0)
    {
        foreach key in __la_zone_is_unlocked
        {
            remove __la_zone_is_unlocked[key];
        }
    }
	
	boolean [location] locations_always_available = $locations[the haunted pantry,the sleazy back alley,the outskirts of cobb's knob,the limerick dungeon,The Haiku Dungeon,The Daily Dungeon,noob cave,the dire warren];
	foreach loc in locations_always_available
	{
		if (loc == $location[none])
			continue;
		__la_location_is_available[loc] = true;
	}
    
    if (questPropertyPastInternalStepNumber("questL02Larva", 1) || questPropertyPastInternalStepNumber("questG02Whitecastle", 1))
        __la_zone_is_unlocked["Woods"] = true;
		
	string zones_never_accessible_string = "Gyms,Crimbo06,Crimbo07,Crimbo08,Crimbo09,Crimbo10,The Candy Diorama,Crimbo12,WhiteWed";
	
	item [location] locations_unlocked_by_item;
	effect [location] locations_unlocked_by_effect;
	
	item [string] zones_unlocked_by_item;
	effect [string] zones_unlocked_by_effect;
	
	locations_unlocked_by_item[$location[Cobb\'s Knob Laboratory]] = $item[Cobb\'s Knob lab key];
    locations_unlocked_by_item[$location[The Knob Shaft]] = $item[Cobb\'s Knob lab key];
	locations_unlocked_by_item[$location[Cobb\'s Knob Menagerie\, Level 1]] = $item[Cobb\'s Knob Menagerie key];
	locations_unlocked_by_item[$location[Cobb\'s Knob Menagerie\, Level 2]] = $item[Cobb\'s Knob Menagerie key];
	locations_unlocked_by_item[$location[Cobb\'s Knob Menagerie\, Level 3]] = $item[Cobb\'s Knob Menagerie key];
	
	locations_unlocked_by_item[$location[The Haunted Library]] = $item[7302]; //library key
	locations_unlocked_by_item[$location[The Castle in the Clouds in the Sky (Basement)]] = $item[S.O.C.K.];
	locations_unlocked_by_item[$location[the hole in the sky]] = $item[steam-powered model rocketship];
    if (my_path().id == PATH_EXPLOSION)
    {
        locations_unlocked_by_item[$location[The Castle in the Clouds in the Sky (Basement)]] = $item[none];
        locations_unlocked_by_item[$location[the hole in the sky]] = $item[none];
    }
	
	locations_unlocked_by_item[$location[Vanya\'s Castle Foyer]] = $item[map to Vanya\'s Castle];
	
	zones_unlocked_by_item["Magic Commune"] = $item[map to the Magic Commune];
	zones_unlocked_by_item["Landscaper"] = $item[Map to The Landscaper\'s Lair];
	zones_unlocked_by_item["Kegger"] = $item[map to the Kegger in the Woods];
	zones_unlocked_by_item["Ellsbury's Claim"] = $item[Map to Ellsbury\'s Claim];
	zones_unlocked_by_item["Memories"] = $item[empty agua de vida bottle];
	zones_unlocked_by_item["Casino"] = $item[casino pass];
	
	zones_unlocked_by_effect["Astral"] = $effect[Half-Astral];
	zones_unlocked_by_effect["Spaaace"] = $effect[Transpondent];
	zones_unlocked_by_effect["RabbitHole"] = $effect[Down the Rabbit Hole];
	zones_unlocked_by_effect["Wormwood"] = $effect[Absinthe-Minded];	
	zones_unlocked_by_effect["Suburbs"] = $effect[Dis Abled];
	
	string [int] zones_never_accessible = split_string_alternate(zones_never_accessible_string, ",");
	
	boolean [string] zone_accessibility_status = zones_never_accessible.listInvert();
    foreach s in zone_accessibility_status //invert
    {
        zone_accessibility_status[s] = false;
    }
	
	
	foreach loc in $locations[Shivering Timbers,A Skeleton Invasion!,The Cannon Museum,A Swarm of Yeti-Mounted Skeletons,The Bonewall,A Massive Flying Battleship,A Supply Train,The Bone Star,Grim Grimacite Site,A Pile of Old Servers,The Haunted Sorority House,Fightin' Fire,Super-Intense Mega-Grassfire,Fierce Flying Flames,Lord Flameface's Castle Entryway,Lord Flameface's Castle Belfry,Lord Flameface's Throne Room,A Stinking Abyssal Portal,A Scorching Abyssal Portal,A Terrifying Abyssal Portal,A Freezing Abyssal Portal,An Unsettling Abyssal Portal,A Yawning Abyssal Portal,The Space Odyssey Discotheque,The Spirit World,The Crimbonium Mining Camp,WarBear Fortress (First Level),WarBear Fortress (Second Level),WarBear Fortress (Third Level)]
	{
		__la_location_is_available[loc] = false;
	}
	
	foreach loc in locations_unlocked_by_item
	{
		if (locations_unlocked_by_item[loc].available_amount() > 0 || locations_unlocked_by_item[loc] == $item[none])
			__la_location_is_available[loc] = true;
		else
			__la_location_is_available[loc] = false;
	}
	foreach loc in locations_unlocked_by_effect
	{
		if (locations_unlocked_by_effect[loc].have_effect() > 0)
			__la_location_is_available[loc] = true;
		else
			__la_location_is_available[loc] = false;
	}
	
	foreach zone in zones_unlocked_by_item
	{
		if (zones_unlocked_by_item[zone].available_amount() > 0)
			zone_accessibility_status[zone] = true;
		else
			zone_accessibility_status[zone] = false;
	}
	foreach zone in zones_unlocked_by_effect
	{
		if (zones_unlocked_by_effect[zone].have_effect() > 0)
			zone_accessibility_status[zone] = true;
		else
			zone_accessibility_status[zone] = false;
	}
	
	
	
	
	foreach loc in $locations[]
	{
		if (zone_accessibility_status contains (loc.zone))
			__la_location_is_available[loc] = zone_accessibility_status[loc.zone];
	}
		
		
	__la_commons_were_inited = true;
    __la_turncount_initialised_on = my_turncount();
}

boolean locationAvailable(location loc, Error able_to_find)
{
    locationAvailablePrivateInit();
	if ((__la_location_is_available contains loc))
		return __la_location_is_available[loc];
	
	boolean [int] could_find;
	boolean is_available = locationAvailablePrivateCheck(loc, able_to_find);
	if (able_to_find.was_error)
		return false;
	__la_location_is_available[loc] = is_available;
	
	return is_available;
}

boolean locationAvailable(location loc)
{
	return locationAvailable(loc, ErrorMake());
}

void locationAvailableResetCache()
{
    __la_commons_were_inited = false;
}



string [location] LAConvertLocationLookupToLocations(string [string] lookup_map)
{
    string [location] result;
    foreach location_name in lookup_map
    {
        location l = location_name.to_location();
        if (l == $location[none])
        {
            if (__setting_debug_mode)
                print_html("Location \"" + location_name + "\" does not appear to exist anymore.");
            continue;
        }
        result[l] = lookup_map[location_name];
    }
    
    return result;
}
static
{
    string [location] __constant_clickable_urls;
    void initialiseConstantClickableURLs()
    {
        string [string] lookup_map;
        
        lookup_map["Pump Up Muscle"] = "place.php?whichplace=knoll_friendly&action=dk_gym";
        lookup_map["Richard's Hobo Mysticality"] = "clan_hobopolis.php?place=3";
        lookup_map["Richard's Hobo Moxie"] = "clan_hobopolis.php?place=3";
        lookup_map["Richard's Hobo Muscle"] = "clan_hobopolis.php?place=3";
        lookup_map["South of the Border"] = "place.php?whichplace=desertbeach";
        lookup_map["The Oasis"] = "place.php?whichplace=desertbeach";
        lookup_map["The Arid, Extra-Dry Desert"] = "place.php?whichplace=desertbeach";
        lookup_map["The Shore, Inc. Travel Agency"] = "place.php?whichplace=desertbeach";
        lookup_map["The Upper Chamber"] = "pyramid.php";
        lookup_map["The Middle Chamber"] = "pyramid.php";
        lookup_map["The Lower Chambers"] = "pyramid.php";
        lookup_map["Goat Party"] = "casino.php";
        lookup_map["Pirate Party"] = "casino.php";
        lookup_map["Lemon Party"] = "casino.php";
        lookup_map["The Roulette Tables"] = "casino.php";
        lookup_map["The Poker Room"] = "casino.php";
        lookup_map["The Haiku Dungeon"] = "da.php";
        lookup_map["The Limerick Dungeon"] = "da.php";
        lookup_map["The Enormous Greater-Than Sign"] = "da.php";
        lookup_map["The Dungeons of Doom"] = "da.php";
        lookup_map["The Daily Dungeon"] = "da.php";
        lookup_map["Video Game Level 1"] = "place.php?whichplace=faqdungeon";
        lookup_map["Video Game Level 2"] = "place.php?whichplace=faqdungeon";
        lookup_map["Video Game Level 3"] = "place.php?whichplace=faqdungeon";
        lookup_map["A Maze of Sewer Tunnels"] = "clan_hobopolis.php";
        lookup_map["Hobopolis Town Square"] = "clan_hobopolis.php?place=2";
        lookup_map["Burnbarrel Blvd."] = "clan_hobopolis.php?place=4";
        lookup_map["Exposure Esplanade"] = "clan_hobopolis.php?place=5";
        lookup_map["The Heap"] = "clan_hobopolis.php?place=6";
        lookup_map["The Ancient Hobo Burial Ground"] = "clan_hobopolis.php?place=7";
        lookup_map["The Purple Light District"] = "clan_hobopolis.php?place=8";
        lookup_map["The Slime Tube"] = "clan_slimetube.php";
        lookup_map["Dreadsylvanian Woods"] = "clan_dreadsylvania.php";
        lookup_map["Dreadsylvanian Village"] = "clan_dreadsylvania.php";
        lookup_map["Dreadsylvanian Castle"] = "clan_dreadsylvania.php";
        lookup_map["The Briny Deeps"] = "place.php?whichplace=thesea";
        lookup_map["The Brinier Deepers"] = "place.php?whichplace=thesea";
        lookup_map["The Briniest Deepests"] = "place.php?whichplace=thesea";
        lookup_map["An Octopus's Garden"] = "seafloor.php";
        lookup_map["The Wreck of the Edgar Fitzsimmons"] = "seafloor.php";
        lookup_map["Madness Reef"] = "seafloor.php";
        lookup_map["The Mer-Kin Outpost"] = "seafloor.php";
        lookup_map["The Skate Park"] = "seafloor.php";
        lookup_map["The Marinara Trench"] = "seafloor.php";
        lookup_map["Anemone Mine"] = "seafloor.php";
        lookup_map["The Dive Bar"] = "seafloor.php";
        lookup_map["The Coral Corral"] = "seafloor.php";
        lookup_map["Mer-kin Elementary School"] = "sea_merkin.php?seahorse=1";
        lookup_map["Mer-kin Library"] = "sea_merkin.php?seahorse=1";
        lookup_map["Mer-kin Gymnasium"] = "sea_merkin.php?seahorse=1";
        lookup_map["Mer-kin Colosseum"] = "sea_merkin.php?seahorse=1";
        lookup_map["The Caliginous Abyss"] = "seafloor.php";
        lookup_map["Anemone Mine (Mining)"] = "seafloor.php";
        lookup_map["The Sleazy Back Alley"] = "place.php?whichplace=town_wrong";
        lookup_map["The Copperhead Club"] = "place.php?whichplace=town_wrong";
        lookup_map["The Haunted Kitchen"] = "place.php?whichplace=manor1";
        lookup_map["The Haunted Conservatory"] = "place.php?whichplace=manor1";
        lookup_map["The Haunted Library"] = "place.php?whichplace=manor1";
        lookup_map["The Haunted Billiards Room"] = "place.php?whichplace=manor1";
        lookup_map["The Haunted Pantry"] = "place.php?whichplace=manor1";
        lookup_map["The Haunted Gallery"] = "place.php?whichplace=manor2";
        lookup_map["The Haunted Bathroom"] = "place.php?whichplace=manor2";
        lookup_map["The Haunted Bedroom"] = "place.php?whichplace=manor2";
        lookup_map["The Haunted Ballroom"] = "place.php?whichplace=manor2";
        lookup_map["The Haunted Boiler Room"] = "place.php?whichplace=manor4";
        lookup_map["The Haunted Laundry Room"] = "place.php?whichplace=manor4";
        lookup_map["The Haunted Wine Cellar"] = "place.php?whichplace=manor4";
        lookup_map["The Haunted Laboratory"] = "place.php?whichplace=manor3";
        lookup_map["The Haunted Nursery"] = "place.php?whichplace=manor3";
        lookup_map["The Haunted Storage Room"] = "place.php?whichplace=manor3";
        lookup_map["Summoning Chamber"] = "place.php?whichplace=manor4";
        lookup_map["The Hidden Apartment Building"] = "place.php?whichplace=hiddencity";
        lookup_map["The Hidden Hospital"] = "place.php?whichplace=hiddencity";
        lookup_map["The Hidden Office Building"] = "place.php?whichplace=hiddencity";
        lookup_map["The Hidden Bowling Alley"] = "place.php?whichplace=hiddencity";
        lookup_map["The Hidden Park"] = "place.php?whichplace=hiddencity";
        lookup_map["An Overgrown Shrine (Northwest)"] = "place.php?whichplace=hiddencity";
        lookup_map["An Overgrown Shrine (Southwest)"] = "place.php?whichplace=hiddencity";
        lookup_map["An Overgrown Shrine (Northeast)"] = "place.php?whichplace=hiddencity";
        lookup_map["An Overgrown Shrine (Southeast)"] = "place.php?whichplace=hiddencity";
        lookup_map["A Massive Ziggurat"] = "place.php?whichplace=hiddencity";
        lookup_map["The Typical Tavern Cellar"] = "cellar.php";
        lookup_map["The Spooky Forest"] = "place.php?whichplace=woods";
        lookup_map["The Hidden Temple"] = "place.php?whichplace=woods";
        lookup_map["A Barroom Brawl"] = "tavern.php";
        lookup_map["8-Bit Realm"] = "place.php?whichplace=woods";
        lookup_map["Whitey's Grove"] = "place.php?whichplace=woods";
        lookup_map["The Road to the White Citadel"] = "place.php?whichplace=woods";
        lookup_map["The Black Forest"] = "place.php?whichplace=woods";
        lookup_map["The Old Landfill"] = "place.php?whichplace=woods";
        lookup_map["The Bat Hole Entrance"] = "place.php?whichplace=bathole";
        lookup_map["Guano Junction"] = "place.php?whichplace=bathole";
        lookup_map["The Batrat and Ratbat Burrow"] = "place.php?whichplace=bathole";
        lookup_map["The Beanbat Chamber"] = "place.php?whichplace=bathole";
        lookup_map["The Boss Bat's Lair"] = "place.php?whichplace=bathole";
        lookup_map["The Red Queen's Garden"] = "place.php?whichplace=rabbithole";
        lookup_map["The Clumsiness Grove"] = "suburbandis.php";
        lookup_map["The Maelstrom of Lovers"] = "suburbandis.php";
        lookup_map["The Glacier of Jerks"] = "suburbandis.php";
        lookup_map["The Degrassi Knoll Restroom"] = "place.php?whichplace=knoll_hostile";
        lookup_map["The Degrassi Knoll Bakery"] = "place.php?whichplace=knoll_hostile";
        lookup_map["The Degrassi Knoll Gym"] = "place.php?whichplace=knoll_hostile";
        lookup_map["The Degrassi Knoll Garage"] = "place.php?whichplace=knoll_hostile";
        lookup_map["The \"Fun\" House"] = "place.php?whichplace=plains";
        lookup_map["The Unquiet Garves"] = "place.php?whichplace=cemetery";
        lookup_map["The VERY Unquiet Garves"] = "place.php?whichplace=cemetery";
        lookup_map["Tower Ruins"] = "fernruin.php";
        lookup_map["Fernswarthy's Basement"] = "basement.php";
        lookup_map["Cobb's Knob Barracks"] = "cobbsknob.php";
        lookup_map["Cobb's Knob Kitchens"] = "cobbsknob.php";
        lookup_map["Cobb's Knob Harem"] = "cobbsknob.php";
        lookup_map["Cobb's Knob Treasury"] = "cobbsknob.php";
        lookup_map["Throne Room"] = "cobbsknob.php";
        lookup_map["Cobb's Knob Laboratory"] = "cobbsknob.php?action=tolabs";
        lookup_map["The Knob Shaft"] = "cobbsknob.php?action=tolabs";
        lookup_map["The Knob Shaft (Mining)"] = "cobbsknob.php?action=tolabs";
        lookup_map["Cobb's Knob Menagerie, Level 1"] = "cobbsknob.php?action=tomenagerie";
        lookup_map["Cobb's Knob Menagerie, Level 2"] = "cobbsknob.php?action=tomenagerie";
        lookup_map["Cobb's Knob Menagerie, Level 3"] = "cobbsknob.php?action=tomenagerie";
        lookup_map["The Dark Neck of the Woods"] = "friars.php";
        lookup_map["The Dark Heart of the Woods"] = "friars.php";
        lookup_map["The Dark Elbow of the Woods"] = "friars.php";
        lookup_map["Friar Ceremony Location"] = "friars.php";
        lookup_map["Pandamonium Slums"] = "pandamonium.php";
        lookup_map["The Laugh Floor"] = "pandamonium.php?action=beli";
        lookup_map["Infernal Rackets Backstage"] = "pandamonium.php?action=infe";
        lookup_map["The Defiled Nook"] = "crypt.php";
        lookup_map["The Defiled Cranny"] = "crypt.php";
        lookup_map["The Defiled Alcove"] = "crypt.php";
        lookup_map["The Defiled Niche"] = "crypt.php";
        lookup_map["Haert of the Cyrpt"] = "crypt.php";
        lookup_map["Frat House"] = "island.php";
        lookup_map["Frat House In Disguise"] = "island.php";
        lookup_map["Frat House (frat disguise)"] = "island.php";
        lookup_map["The Frat House (Bombed Back to the Stone Age)"] = "island.php";
        lookup_map["Hippy Camp"] = "island.php";
        lookup_map["Hippy Camp In Disguise"] = "island.php";
        lookup_map["Hippy Camp (hippy disguise)"] = "island.php";
        lookup_map["The Hippy Camp (Bombed Back to the Stone Age)"] = "island.php";
        lookup_map["The Obligatory Pirate's Cove"] = "island.php";
        lookup_map["Barrrney's Barrr"] = "place.php?whichplace=cove";
        lookup_map["The F'c'le"] = "place.php?whichplace=cove";
        lookup_map["The Poop Deck"] = "place.php?whichplace=cove";
        lookup_map["Belowdecks"] = "place.php?whichplace=cove";
        lookup_map["Post-War Junkyard"] = "island.php";
        lookup_map["McMillicancuddy's Farm"] = "island.php";
        lookup_map["The Battlefield (Frat Uniform)"] = "bigisland.php";
        lookup_map["The Battlefield (Hippy Uniform)"] = "bigisland.php";
        lookup_map["Wartime Frat House"] = "island.php";
        lookup_map["Wartime Frat House (Hippy Disguise)"] = "island.php";
        lookup_map["Wartime Hippy Camp"] = "island.php";
        lookup_map["Wartime Hippy Camp (Frat Disguise)"] = "island.php";
        lookup_map["Next to that Barrel with Something Burning in it"] = "bigisland.php?place=junkyard";
        lookup_map["Near an Abandoned Refrigerator"] = "bigisland.php?place=junkyard";
        lookup_map["Over Where the Old Tires Are"] = "bigisland.php?place=junkyard";
        lookup_map["Out by that Rusted-Out Car"] = "bigisland.php?place=junkyard";
        lookup_map["Sonofa Beach"] = "bigisland.php?place=lighthouse";
        lookup_map["The Themthar Hills"] = "bigisland.php?place=nunnery";
        lookup_map["McMillicancuddy's Barn"] = "bigisland.php?place=farm";
        lookup_map["McMillicancuddy's Pond"] = "bigisland.php?place=farm";
        lookup_map["McMillicancuddy's Back 40"] = "bigisland.php?place=farm";
        lookup_map["McMillicancuddy's Other Back 40"] = "bigisland.php?place=farm";
        lookup_map["McMillicancuddy's Granary"] = "bigisland.php?place=farm";
        lookup_map["McMillicancuddy's Bog"] = "bigisland.php?place=farm";
        lookup_map["McMillicancuddy's Family Plot"] = "bigisland.php?place=farm";
        lookup_map["McMillicancuddy's Shady Thicket"] = "bigisland.php?place=farm";
        lookup_map["The Hatching Chamber"] = "bigisland.php?place=orchard";
        lookup_map["The Feeding Chamber"] = "bigisland.php?place=orchard";
        lookup_map["The Royal Guard Chamber"] = "bigisland.php?place=orchard";
        lookup_map["The Filthworm Queen's Chamber"] = "bigisland.php?place=orchard";
        lookup_map["Noob Cave"] = "tutorial.php";
        lookup_map["The Dire Warren"] = "tutorial.php";
        lookup_map["The Valley of Rof L'm Fao"] = "place.php?whichplace=mountains";
        lookup_map["Mt. Molehill"] = "place.php?whichplace=mountains";
        lookup_map["The Barrel Full of Barrels"] = "barrel.php";
        lookup_map["The Smut Orc Logging Camp"] = "place.php?whichplace=orc_chasm";
        lookup_map["The Thinknerd Warehouse"] = "place.php?whichplace=mountains";
        lookup_map["A Mob of Zeppelin Protesters"] = "place.php?whichplace=zeppelin";
        lookup_map["The Red Zeppelin"] = "place.php?whichplace=zeppelin";
        lookup_map["A-Boo Peak"] = "place.php?whichplace=highlands";
        lookup_map["Twin Peak"] = "place.php?whichplace=highlands";
        lookup_map["Oil Peak"] = "place.php?whichplace=highlands";
        lookup_map["Itznotyerzitz Mine"] = "place.php?whichplace=mclargehuge";
        lookup_map["The Goatlet"] = "place.php?whichplace=mclargehuge";
        lookup_map["Lair of the Ninja Snowmen"] = "place.php?whichplace=mclargehuge";
        lookup_map["The eXtreme Slope"] = "place.php?whichplace=mclargehuge";
        lookup_map["Mist-Shrouded Peak"] = "place.php?whichplace=mclargehuge";
        lookup_map["The Icy Peak"] = "place.php?whichplace=mclargehuge";
        lookup_map["Itznotyerzitz Mine (in Disguise)"] = "place.php?whichplace=mclargehuge";
        lookup_map["The Penultimate Fantasy Airship"] = "place.php?whichplace=beanstalk";
        lookup_map["The Castle in the Clouds in the Sky (Basement)"] = "place.php?whichplace=giantcastle";
        lookup_map["The Castle in the Clouds in the Sky (Ground Floor)"] = "place.php?whichplace=giantcastle";
        lookup_map["The Castle in the Clouds in the Sky (Top Floor)"] = "place.php?whichplace=giantcastle";
        lookup_map["The Hole in the Sky"] = "place.php?whichplace=beanstalk";
        lookup_map["The Broodling Grounds"] = "volcanoisland.php";
        lookup_map["The Outer Compound"] = "volcanoisland.php";
        lookup_map["The Temple Portico"] = "volcanoisland.php";
        lookup_map["Convention Hall Lobby"] = "volcanoisland.php";
        lookup_map["Outside the Club"] = "volcanoisland.php";
        lookup_map["The Island Barracks"] = "volcanoisland.php";
        lookup_map["The Nemesis' Lair"] = "volcanoisland.php";
        lookup_map["The Bugbear Pen"] = "place.php?whichplace=knoll_friendly";
        lookup_map["The Spooky Gravy Burrow"] = "place.php?whichplace=knoll_friendly";
        lookup_map["The Stately Pleasure Dome"] = "place.php?whichplace=wormwood";
        lookup_map["The Mouldering Mansion"] = "place.php?whichplace=wormwood";
        lookup_map["The Rogue Windmill"] = "place.php?whichplace=wormwood";
        lookup_map["The Primordial Soup"] = "place.php?whichplace=memories";
        lookup_map["The Jungles of Ancient Loathing"] = "place.php?whichplace=memories";
        lookup_map["Seaside Megalopolis"] = "place.php?whichplace=memories";
        lookup_map["Domed City of Ronaldus"] = "place.php?whichplace=spaaace";
        lookup_map["Domed City of Grimacia"] = "place.php?whichplace=spaaace";
        lookup_map["Hamburglaris Shield Generator"] = "place.php?whichplace=spaaace";
        lookup_map["The Arrrboretum"] = "place.php?whichplace=woods";
        lookup_map["Spectral Pickle Factory"] = "place.php?whichplace=plains";
        lookup_map["Lollipop Forest"] = "";
        lookup_map["Fudge Mountain"] = "";
        lookup_map["WarBear Fortress (First Level)"] = "";
        lookup_map["WarBear Fortress (Second Level)"] = "";
        lookup_map["WarBear Fortress (Third Level)"] = "";
        lookup_map["Elf Alley"] = "";
        lookup_map["CRIMBCO cubicles"] = "";
        lookup_map["CRIMBCO WC"] = "";
        lookup_map["Crimbo Town Toy Factory (2005)"] = "";
        lookup_map["The Don's Crimbo Compound"] = "";
        lookup_map["Atomic Crimbo Toy Factory"] = "";
        lookup_map["Crimbo Town Toy Factory (2007)"] = "";
        lookup_map["Sinister Dodecahedron"] = "";
        lookup_map["Crimbo Town Toy Factory (2009)"] = "";
        lookup_map["Simple Tool-Making Cave"] = "";
        lookup_map["Spooky Fright Factory"] = "";
        lookup_map["Crimborg Collective Factory"] = "";
        lookup_map["Crimbo Town Toy Factory (2012)"] = "";
        lookup_map["Market Square, 28 Days Later"] = "";
        lookup_map["The Mall of Loathing, 28 Days Later"] = "";
        lookup_map["Wrong Side of the Tracks, 28 Days Later"] = "";
        lookup_map["The Icy Peak in The Recent Past"] = "";
        lookup_map["Shivering Timbers"] = "";
        lookup_map["A Skeleton Invasion!"] = "";
        lookup_map["The Cannon Museum"] = "";
        lookup_map["A Swarm of Yeti-Mounted Skeletons"] = "";
        lookup_map["The Bonewall"] = "";
        lookup_map["A Massive Flying Battleship"] = "";
        lookup_map["A Supply Train"] = "";
        lookup_map["The Bone Star"] = "";
        lookup_map["Grim Grimacite Site"] = "";
        lookup_map["A Pile of Old Servers"] = "";
        lookup_map["The Haunted Sorority House"] = "";
        lookup_map["Fightin' Fire"] = "";
        lookup_map["Super-Intense Mega-Grassfire"] = "";
        lookup_map["Fierce Flying Flames"] = "";
        lookup_map["Lord Flameface's Castle Entryway"] = "";
        lookup_map["Lord Flameface's Castle Belfry"] = "";
        lookup_map["Lord Flameface's Throne Room"] = "";
        lookup_map["A Stinking Abyssal Portal"] = "";
        lookup_map["A Scorching Abyssal Portal"] = "";
        lookup_map["A Terrifying Abyssal Portal"] = "";
        lookup_map["A Freezing Abyssal Portal"] = "";
        lookup_map["An Unsettling Abyssal Portal"] = "";
        lookup_map["A Yawning Abyssal Portal"] = "";
        lookup_map["The Space Odyssey Discotheque"] = "";
        lookup_map["The Spirit World"] = "";
        lookup_map["Some Scattered Smoking Debris"] = "place.php?whichplace=crashsite";
        lookup_map["Anger Man's Level"] = "place.php?whichplace=junggate_3";
        lookup_map["Fear Man's Level"] = "place.php?whichplace=junggate_3";
        lookup_map["Doubt Man's Level"] = "place.php?whichplace=junggate_3";
        lookup_map["Regret Man's Level"] = "place.php?whichplace=junggate_3";
        lookup_map["The Nightmare Meatrealm"] = "place.php?whichplace=junggate_6";
        lookup_map["A Kitchen Drawer"] = "place.php?whichplace=junggate_5";
        lookup_map["A Grocery Bag"] = "place.php?whichplace=junggate_5";
        lookup_map["Chinatown Shops"] = "place.php?whichplace=junggate_1";
        lookup_map["Triad Factory"] = "place.php?whichplace=junggate_1";
        lookup_map["1st Floor, Shiawase-Mitsuhama Building"] = "place.php?whichplace=junggate_1";
        lookup_map["2nd Floor, Shiawase-Mitsuhama Building"] = "place.php?whichplace=junggate_1";
        lookup_map["3rd Floor, Shiawase-Mitsuhama Building"] = "place.php?whichplace=junggate_1";
        lookup_map["Chinatown Tenement"] = "place.php?whichplace=junggate_1";
        lookup_map["The Gourd!"] = "place.php?whichplace=junggate_2";
        lookup_map["A Deserted Stretch of I-911"] = "place.php?whichplace=ioty2014_hare";
        lookup_map["The Prince's Restroom"] = "place.php?whichplace=ioty2014_cindy";
        lookup_map["The Prince's Dance Floor"] = "place.php?whichplace=ioty2014_cindy";
        lookup_map["The Prince's Kitchen"] = "place.php?whichplace=ioty2014_cindy";
        lookup_map["The Prince's Balcony"] = "place.php?whichplace=ioty2014_cindy";
        lookup_map["The Prince's Lounge"] = "place.php?whichplace=ioty2014_cindy";
        lookup_map["The Prince's Canapes table"] = "place.php?whichplace=ioty2014_cindy";
        lookup_map["The Inner Wolf Gym"] = "place.php?whichplace=ioty2014_wolf";
        lookup_map["Unleash Your Inner Wolf"] = "place.php?whichplace=ioty2014_wolf";
        lookup_map["The Crimbonium Mining Camp"] = "place.php?whichplace=desertbeach";
        lookup_map["Kokomo Resort"] = "place.php?whichplace=desertbeach";
        lookup_map["The Crimbonium Mine"] = "mining.php?mine=5";
        lookup_map["The Secret Council Warehouse"] = "tutorial.php";
        lookup_map["The Skeleton Store"] = "place.php?whichplace=town_market";
        lookup_map["Madness Bakery"] = "place.php?whichplace=town_right";
        lookup_map["Investigating a Plaintive Telegram"] = "place.php?whichplace=town_right";
        lookup_map["The Fungal Nethers"] = "place.php?whichplace=nemesiscave";
        lookup_map["Thugnderdome"] = "gnomes.php";
        lookup_map["The Overgrown Lot"] = "place.php?whichplace=town_wrong";
        lookup_map["The Canadian Wildlife Preserve"] = "place.php?whichplace=mountains";
        foreach s in $strings[The Hallowed Halls,Shop Class,Chemistry Class,Art Class]
            lookup_map[s] = "place.php?whichplace=KOLHS";
        foreach s in $strings[The Edge of the Swamp,The Dark and Spooky Swamp,The Corpse Bog,The Ruined Wizard Tower,The Wildlife Sanctuarrrrrgh,Swamp Beaver Territory,The Weird Swamp Village]
            lookup_map[s] = "place.php?whichplace=marais";
        foreach s in $strings[Ye Olde Medievale Villagee,Portal to Terrible Parents,Rumpelstiltskin's Workshop]
            lookup_map[s] = "place.php?whichplace=ioty2014_rumple";
            
        foreach s in $strings[The Cave Before Time,An Illicit Bohemian Party,Moonshiners' Woods,The Roman Forum,The Post-Mall,The Rowdy Saloon,The Spooky Old Abandoned Mine,Globe Theatre Main Stage,Globe Theatre Backstage,12 West Main,KoL Con Clan Party House]
            lookup_map[s] = "place.php?whichplace=twitch";
        foreach s in $strings[The Fun-Guy Mansion,Sloppy Seconds Diner,The Sunken Party Yacht]
            lookup_map[s] = "place.php?whichplace=airport_sleaze";
        foreach s in $strings[The Mansion of Dr. Weirdeaux,The Deep Dark Jungle,The Secret Government Laboratory]
            lookup_map[s] = "place.php?whichplace=airport_spooky";
        foreach s in $strings[Pirates of the Garbage Barges,Barf Mountain,The Toxic Teacups,Uncle Gator's Country Fun-Time Liquid Waste Sluice]
            lookup_map[s] = "place.php?whichplace=airport_stench";
        foreach s in $strings[The SMOOCH Army HQ,The Velvet / Gold Mine,LavaCo&trade; Lamp Factory,The Bubblin' Caldera]
            lookup_map[s] = "place.php?whichplace=airport_hot";
        foreach s in $strings[The Ice Hotel,VYKEA,The Ice Hole]
            lookup_map[s] = "place.php?whichplace=airport_cold";
        lookup_map["The Velvet / Gold Mine (Mining)"] = "mining.php?mine=6";
        foreach s in $strings[The Mines,The Jungle,The Ice Caves,The Temple Ruins,Hell,The Snake Pit,The Spider Hole,The Ancient Burial Ground,The Beehive,the crashed u. f. o.,The City of Goooold,LOLmec's Lair,Yomama's Throne]
            lookup_map[s] = "place.php?whichplace=spelunky";
        
        foreach s in $strings[Medbay,Waste Processing,Sonar,Science Lab,Morgue,Special Ops,Engineering,Navigation,Galley]
            lookup_map[s] = "place.php?whichplace=bugbearship";
        foreach s in $strings[Sweet-Ade Lake,Eager Rice Burrows,Gumdrop Forest]
            lookup_map[s] = "place.php?whichplace=ioty2014_candy";
        foreach s in $strings[Gingerbread Industrial Zone,Gingerbread Train Station,Gingerbread Sewers,Gingerbread Upscale Retail District]
            lookup_map[s] = "place.php?whichplace=gingerbreadcity";
            
        foreach s in $strings[Fastest Adventurer Contest,Strongest Adventurer Contest,Smartest Adventurer Contest,Smoothest Adventurer Contest,A Crowd of (Stat) Adventurers,Hottest Adventurer Contest,Coldest Adventurer Contest,Spookiest Adventurer Contest,Stinkiest Adventurer Contest,Sleaziest Adventurer Contest,A Crowd of (Element) Adventurers,The Hedge Maze,Tower Level 1,Tower Level 2,Tower Level 3,Tower Level 4,Tower Level 5,The Naughty Sorceress' Chamber]
            lookup_map[s] = "place.php?whichplace=nstower";
            
        lookup_map["Trick-or-treating"] = "place.php?whichplace=town&action=town_trickortreat";
        lookup_map["The Deep Machine Tunnels"] = "place.php?whichplace=dmt";
        
        lookup_map["The Ruins of the Fully Automated Crimbo Factory"] = "place.php?whichplace=crimbo2015";
        lookup_map["The X-32-F Combat Training Snowman"] = "place.php?whichplace=snojo";
        foreach s in $strings[Your Bung Chakra,Your Guts Chakra,Your Liver Chakra,Your Nipple Chakra,Your Nose Chakra,Your Hat Chakra]
            lookup_map[s] = "place.php?whichplace=crimbo2016m";
        foreach s in $strings[Crimbo's Sack,Crimbo's Boots,Crimbo's Jelly,Crimbo's Reindeer,Crimbo's Beard,Crimbo's Hat]
            lookup_map[s] = "place.php?whichplace=crimbo2016c";
        foreach s in $strings[The Cheerless Spire (Level 1), The Cheerless Spire (Level 2), The Cheerless Spire (Level 3), The Cheerless Spire (Level 4), The Cheerless Spire (Level 5)]
        	lookup_map[s] = "place.php?whichplace=crimbo17_silentnight";
        foreach s in $strings[The Bandit Crossroads,The Putrid Swamp,Near the Witch's House,The Troll Fortress,The Sprawling Cemetery,The Cursed Village,The Foreboding Cave,The Faerie Cyrkle,The Evil Cathedral,The Towering Mountains,The Mystic Wood,The Druidic Campsite,The Old Rubee Mine]
        	lookup_map[s] = "place.php?whichplace=realm_fantasy";
        foreach s in $strings[PirateRealm Island,Sailing the PirateRealm Seas]
            lookup_map[s] = "place.php?whichplace=realm_pirate";
        lookup_map["An Eldritch Horror"] = "place.php?whichplace=town";
        lookup_map["The Neverending Party"] = "place.php?whichplace=town_wrong";
        lookup_map["Through the Spacegate"] = "place.php?whichplace=spacegate";
        lookup_map["The Exploaded Battlefield"] = "place.php?whichplace=exploathing";
        __constant_clickable_urls = LAConvertLocationLookupToLocations(lookup_map);
    }
    initialiseConstantClickableURLs();
}

string [location] __variable_clickable_urls;
string getClickableURLForLocation(location l, Error unable_to_find_url)
{
    if (l == $location[none])
        return "";
    if (__constant_clickable_urls contains l)
        return __constant_clickable_urls[l];
        
    if (__variable_clickable_urls.count() == 0)
    {
        //Initialize:
        //We use to_location() lookups here because $location[] will halt the script if the location name changes.
        //Probably could move this to an external data file.
        string [string] lookup_map;
            
        //Conditionals only:
        if ($location[cobb\'s knob barracks].locationAvailable())
            lookup_map["The Outskirts of Cobb's Knob"] = "cobbsknob.php";
        else
            lookup_map["The Outskirts of Cobb's Knob"] = "place.php?whichplace=plains";
            
        if (knoll_available())
            lookup_map["Post-Quest Bugbear Pens"] = "place.php?whichplace=knoll_friendly";
        else
            lookup_map["Post-Quest Bugbear Pens"] =  "place.php?whichplace=knoll_hostile";
            
        if ($item[talisman o\' namsilat].equipped_amount() > 0)
            lookup_map["Inside the Palindome"] = "place.php?whichplace=palindome";
        else
            lookup_map["Inside the Palindome"] = "inventory.php?ftext=talisman+o\'+namsilat";
        //antique maps are weird:
        lookup_map["The Electric Lemonade Acid Parade"] = "inv_use.php?pwd=" + my_hash() + "&whichitem=4613";
        foreach s in $strings[Professor Jacking's Small-O-Fier,Professor Jacking's Huge-A-Ma-tron]
            lookup_map[s] = "inv_use.php?pwd=" + my_hash() + "&whichitem=4560";
            
        //Parse into locations:
        __variable_clickable_urls = LAConvertLocationLookupToLocations(lookup_map);
    }
    if (__variable_clickable_urls contains l)
        return __variable_clickable_urls[l];

    ErrorSet(unable_to_find_url);
    return "";
}

string getClickableURLForLocation(location l)
{
    return l.getClickableURLForLocation(ErrorMake());
}

string getClickableURLForLocationIfAvailable(location l)
{
    Error able_to_find;
    boolean found = l.locationAvailable(able_to_find);
    if (able_to_find.was_error) //assume it's available, since we don't know
        found = true;
    if (found)
        return l.getClickableURLForLocation();
    else
        return "";
}



void locationAvailableRunDiagnostics()
{
    location [string][int] unknown_locations_by_zone;
    
    foreach loc in $locations[]
    {
        Error able_to_find;
        locationAvailable(loc, able_to_find);
        if (!able_to_find.was_error)
            continue;
        if (!(unknown_locations_by_zone contains (loc.zone)))
            unknown_locations_by_zone[loc.zone] = listMakeBlankLocation();
        unknown_locations_by_zone[loc.zone].listAppend(loc);
    }
    if (unknown_locations_by_zone.count() > 0)
    {
        print_html("Unknown locations in location availability tester:");
        foreach zone in unknown_locations_by_zone
        {
            print(zone + ":");
            foreach key in unknown_locations_by_zone[zone]
            {
                location loc = unknown_locations_by_zone[zone][key];
                print_html("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + loc);
            }
        }
    }
    /*print_html("<strong>Missing URLs:</strong>");
    foreach loc in $locations[]
    {
    	if (loc.parent == "Removed") continue;
    	if (loc.getClickableURLForLocation() == "")
        	print_html(loc.parent + ": " + loc.zone + ": " + loc);
    }*/
}

/*void main()
{
    locationAvailableRunDiagnostics();
}*/
