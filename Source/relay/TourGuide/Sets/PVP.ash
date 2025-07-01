import "relay/TourGuide/Support/Campground.ash"

void SPVPGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (!hippy_stone_broken())
        return;
    if (pvp_attacks_left() > 0 && today_is_pvp_season_end())
    {
        optional_task_entries.listAppend(ChecklistEntryMake("__effect Swordholder", "peevpee.php?place=fight", ChecklistSubentryMake("Run all of your fights", "", listMake("Season ends today.", "Make sure to get the seasonal item if you haven't, as well."))).ChecklistEntrySetIDTag("PVP season end"));
    }
    
    int [string] mini_names = current_pvp_stances();
    
    ChecklistEntry entry;
    
    
    string [int] attacking_description;
    string [int] attacking_modifiers;
    
    string [int] overall_modifiers;
    string [int] overall_description;
    foreach mini in mini_names
    {
    	string [int] modifiers;
        string [int] description;
        if (mini == "Maul Power")
        {
            if ($skill[Kung Fu Hustler].have_skill() && $effect[Kung Fu Fighting].have_effect() == 0)
                attacking_description.listPrepend("run a combat without a weapon first");
            attacking_modifiers.listAppend("weapon damage");
            continue;
        }
        else if (mini == "15 Minutes of Fame" || mini == "Beary Famous" || mini == "Upward Mobility Contest" || mini == "Optimal PvP")
        {
            //attacking_description.listAppend("hit for fame");
            attacking_description.listAppend("maximise fightgen and hit for fame");
            continue;
        }
        else if (mini == "80 Days and Counting")
        {
            description.listAppend("Drink Around the Worlds.");
            if (have_outfit_components("Hodgman's Regal Frippery"))
            {
            	if (get_property_int("_hoboUnderlingSummons") < 5)
	            	description.listAppend("Equip Hodgman's Regal Frippery, summon hobo underling, ask for a drink."); 
            }
            else if (QuestState("questL12War").mafia_internal_step == 2)
            {
            	description.listAppend("Finish the war.");
            }
            else if ($item[Spanish fly trap].available_amount() == 0)
            {
            	modifiers.listAppend("-combat");
                if ($location[The Orcish Frat House].noncombat_queue.contains_text("I Just Wanna Fly") || $location[The Orcish Frat House (Bombed Back to the Stone Age)].noncombat_queue.contains_text("Me Just Want Fly"))
                {
                    description.listAppend("Run -combat in The Obligatory Pirate's Cove, acquire Spanish fly trap.");
                }
            	else
             	   description.listAppend("Adventure in the Orcish Frat House until you meet the I Just Wanna Fly adventure.|Then run -combat in The Obligatory Pirate's Cove, acquire Spanish fly trap.");
            }
            else
            {
                string [int] tasks;
            	if ($item[Spanish fly trap].equipped_amount() == 0)
                {
                	tasks.listAppend("equip Spanish fly trap");
                }
                modifiers.listAppend("+item");
                tasks.listAppend("adventure in the Hippy Camp, collecting spanish flies");// + (my_level() >= 9 ? " (+combat)" : ""));
                if ($item[Spanish fly].available_amount() >= 5)
                	tasks.listAppend("turn in " + pluralise($item[Spanish fly]) + " in the orcish frat house (-combat)");
                description.listAppend(tasks.listJoinComponents(", ", "and").capitaliseFirstLetter() + ".");
            }
        }
        else if (mini == "Totally Optimal")
        {
        	if (__quest_state["Level 11 Ron"].state_int["protestors remaining"] > 0)
                description.listAppend("Fight zeppelin protestors, and don't try to speed them up.");
            else
        		description.listAppend("Ascend to fight more Zeppelin Protestors.");
        }
        else if (mini == "Optimal Drinking")
        {
        	if (inebriety_limit() == 0)
            	description.listAppend("Ascend a path you can drink on.");
            else
	        	description.listAppend("When drinking, prefer drinks that have effects.");
        }
        else if (mini == "Familiar Rotation")
        {
        	if (in_ronin())
	        	description.listAppend("Pick a different familiar than your last ascensions this season.");
            else
                description.listAppend("Ascend to rotate your familiar.");
        }
        else if (mini == "Foreigner Reference")
        {
            description.listAppend("Drink ice-cold Sir Schlitzs or ice-cold Willers." + (in_ronin() ? "|The Orcish Frat House has them. Run +400% item" + (my_level() >= 9 ? " and +15% combat." : "") : ""));
        }
        else if (mini == "Best Served Repeatedly")
        {
            description.listAppend("Attack the same target repeatedly. Ideally, lose.");
        }
        else if (mini == "Burrowing Deep" || mini == "Obviously Optimal")
        {
        	if (__misc_state_int["Basement Floor"] > 400)
            {
            	description.listAppend("Ascend to basement more.");
            }
            else if (__misc_state_int["Basement Floor"] <= 1) //this test could be better
            {
            	description.listAppend("Unlock Fernswarthy's basement via your guild.");
            }
            else
            {
            	int floors_remaining = 200 - __misc_state_int["Basement Floor"];
                if (floors_remaining < 0)
                	floors_remaining = 400 - __misc_state_int["Basement Floor"];
	            description.listAppend("Collect a Pan-Dimensional Gargle Blaster from Fernswarthy's basement. " + pluraliseWordy(floors_remaining, "floor", "floors") + " to go.");
            }
        }
        else if (mini == "Frostily Ephemeral" || mini == "Newest Born" || mini == "SELECT asc_time FROM zzz_players WHERE player_id=%playerid%" || mini == "Optimal Ascension")
        {
            description.listAppend("Ascend to reset timer.");
        }
        else if (mini == "Karrrmic Battle" || mini == "Karmic Battle")
        {
            description.listAppend("Ascend to gain more karma.");
        }
        else if (mini == "Back to Square One")
        {
            description.listAppend("Ascend.");
        }
        else if (mini == "Baker's Dozen")
        {
            description.listAppend("Adventure as often as possible in Madness Bakery.");
        }
        else if (mini == "Fahrenheit 451")
        {
            attacking_modifiers.listAppend("hot damage");
            attacking_modifiers.listAppend("hot spell damage");
            continue;
        }
        else if (mini == "I Like Pi")
        {
            description.listAppend("Eat key lime pies.");
        }
        else if (mini == "HTTP 301 Moved Permanently")
        {
            description.listAppend("Adventure in as many different locations as you can.");
        }
        else if (mini == "Quality Assurance")
        {
            description.listAppend("Defeat bug-phylum monsters.");
        }
        else if (mini == "Free.Willy.1993.1080p.BRRip.x265.torrent")
        {
            description.listAppend("Fight dolphins.|Farm sand dollars, turn them into dolphin whistles, and use them.");
        }
        else if (mini == "Installation Wizard")
        {
            modifiers.listAppend("+item");
            if (!canadia_available())
            {
                description.listAppend("Farm dilapidated wizard hats from copied swamp owls.|Or ascend canadia moon sign.");
            }
            else
            {
            	description.listAppend("Farm dilapidated wizard hats from swamp owls in The Weird Swamp Village.");
            }
        }
        else if (mini == "Illegal Operation")
        {
            description.listAppend("Buy goofballs from the suspicious-looking guy. If they're too expensive, ascend to reset the price.");
        }
        else if (mini == "Fotoshop.CS11.Keygen.exe [legit]")
        {
            description.listAppend("Eat digital key lime pies.");
        }
        else if (mini == "Most Murderous" || mini == "Icy Revenge")
        {
        	//FIXME list
            description.listAppend("Defeat once/ascension bosses.");
        }
        else if (mini == "Grave Robbery" || mini == "Bear Hunter")
        {
        	if ($item[wand of nagamar].available_amount() > 0)
				description.listAppend("Ascend.");
            else
                description.listAppend("Avoid making the wand of nagamar, lose to the naughty sorceress (3), and look for the wand in the very unquiet garves");
        }
        else if (mini == "Basket Reaver")
        {
        	if (my_level() < 11)
            {
            	description.listAppend("Level up.");
            }
            else
            {
                modifiers.listAppend("+5% combat");
                modifiers.listAppend("olfact black widow");
                modifiers.listAppend("+item");
                description.listAppend("Run +item% and farm black widows in the black forest.");
            }
        }
        else if (mini == "Rule 42")
        {
        	if ($location[the Haunted Bathroom].noncombat_queue.contains_text("Off the Rack")) //not perfect
         		continue;   
        	modifiers.listAppend("-combat");
            if ($location[the Haunted Bathroom].locationAvailable())
	            description.listAppend("Collect a towel in the Haunted Bathroom.");
            else
                description.listAppend("Unlock the Haunted Bathroom in Spookyraven Manor.");
        }
        else if (mini == "Tea for 2, 3, 4 or More")
        {
        	boolean [item] tea = $items[Corpse Island iced tea,cup of lukewarm tea,cup of &quot;tea&quot;,hippy herbal tea,Ice Island Long Tea,New Zealand iced tea];
            //description.listAppend("Drink tea.|" + );
            
            string tooltip_text = tea.listInvert().listJoinComponents(", ", "or").capitaliseFirstLetter() + ".";
            tooltip_text += "<hr>Cheapest is cup of lukewarm tea.<hr>Hippy herbal tea is guano coffee cup (bat guano, batrat, batrat burrow) + herbs (hippy store).";
            
            string title = HTMLGenerateSpanOfClass(HTMLGenerateSpanOfClass(tooltip_text, "r_tooltip_inner_class") + "Drink tea.", "r_tooltip_outer_class");
            description.listAppend(title);
        }
        else if (mini == "Scurvy Challenge")
        {
            boolean [item] fruit = $items[grapefruit,kumquat,lemon,lime,orange,pixel lemon,sea tangelo,tangerine,vinegar-soaked lemon slice];
            //description.listAppend("Drink tea.|" + );
            
            string tooltip_text = fruit.listInvert().listJoinComponents(", ", "or").capitaliseFirstLetter() + ".";
            tooltip_text += "<hr>Check the hippy store, on the island.";
            
            string title = HTMLGenerateSpanOfClass(HTMLGenerateSpanOfClass(tooltip_text, "r_tooltip_inner_class") + "Eat fruit.", "r_tooltip_outer_class");
            description.listAppend(title);
        }
        else if (mini == "Raw Carnivorery")
        {
        	//FIXME This could be dynamic, I bet the game is dynamic.
            boolean [item] meat = $items[beefy fish meat, glistening fish meat, slick fish meat, &quot;meat&quot; stick, raw mincemeat, alien meat, dead meat bun, consummate meatloaf, VYKEA meatballs];
            
            string [int] entries;
            foreach it in meat
            {
            	string entry = it;
                if (entries.count() == 0) entry = entry.capitaliseFirstLetter();
            	if (it.fullness == 1)
                	entry = HTMLGenerateSpanOfClass(entry, "r_bold");
                entries.listAppend(entry);
            }
            
            string tooltip_text = entries.listJoinComponents(", ", "or") + ".";
            
            string title = HTMLGenerateSpanOfClass(HTMLGenerateSpanOfClass(tooltip_text, "r_tooltip_inner_class") + "Eat meat.", "r_tooltip_outer_class");
            description.listAppend(title);
        }
        else if (mini == "That Britney Spears Number")
        {
        	string [int] tasks;
            if ($item[wooden stakes].available_amount() == 0)
            {
                description.listAppend("Adventure in the Spooky Forest, collect wooden stakes from the noncombat.");
                description.listAppend("Follow the old road " + __html_right_arrow_character + " Knock on the cottage door.");
                modifiers.listAppend("-combat");
            }
            else
            {
                if ($item[wooden stakes].equipped_amount() == 0)
                {
                    tasks.listAppend("equip wooden stakes");
                }
                modifiers.listAppend("olfact spooky vampire");
                tasks.listAppend("fight vampires in the Spooky Forest");
                description.listAppend(tasks.listJoinComponents(", ", "and").capitaliseFirstLetter() + ".");
            }
        }
        else if (mini == "The Purity is Right" || mini == "Polar Envy" || mini == "Purity")
        {
            attacking_description.listAppend("run zero effects");
            continue;
        }
        else if (mini == "Purrrity")
        {
            attacking_description.listAppend("run zero effects with R in their name");
            continue;
        }
        else if (mini == "The Optimal Stat")
        {
            attacking_modifiers.listAppend("+item drop");
            continue;
        }
        else if (mini == "A Nice Cold One" || mini == "Thirrrsty forrr Booze")
        {
            attacking_modifiers.listAppend("+booze drop");
            continue;
        }
        else if (mini == "Smellin' Like a Stinkin' Rose")
        {
            attacking_modifiers.listAppend("-combat");
            continue;
        }
        else if (mini == "Ready to Melt")
        {
            attacking_modifiers.listAppend("hot damage");
            attacking_modifiers.listAppend("hot spell damage");
            continue;
        }
        else if (mini == "Zero Tolerance")
        {
        	description.listAppend("Don't drink booze.");
        }
        else if (mini == "Visiting the Cousins" || mini == "Visiting The Co@^&$`~")
        {
        	if (knoll_available())
                description.listAppend("Adventure in the bugbear pens.");
            else
				description.listAppend("Ascend knoll moon sign.");
        }
        else if (mini == "Craft Brew is Optimal")
        {
            if (gnomads_available())
                description.listAppend("Drink from the Gnomish Microbrewery.");
            else
                description.listAppend("Ascend Gnomish moon sign.");
        }
        else if (mini == "Who Runs Bordertown?")
        {
        	if (gnomads_available())
                description.listAppend("Adventure in the Thugnderdome.");
            else
                description.listAppend("Ascend Gnomish moon sign.");
        }
        else if (mini == "Pirate Wars!")
        {
        	description.listAppend("Fight pirates, but not too many; the count resets every day.");
        }
        else if (mini == "Bilge Hunter")
        {
            description.listAppend("Run +300 ML and +combat, and fight drunken rat kings in the Typical Tavern basement.");
            modifiers.listAppend("+300 ML");
            modifiers.listAppend("+combat");
        }
        else if (mini == "Death to Ninja!")
        {
        	string [int] tasks;
            if (!is_wearing_outfit("Swashbuckling Getup"))
            	tasks.listAppend("equip swashbuckling getup");
            tasks.listAppend("fight ninja");
            description.listAppend(tasks.listJoinComponents(", ", "and").capitaliseFirstLetter() + ".");
        }
        else if (mini == "Swimming with the Fishes")
        {
            description.listAppend("Spend turns underwater.");
        }
        else if (mini == "(Fur) Shirts and Skins")
        {
            description.listAppend("Collect furs and skins from monsters. (+item)|The icy peak? Olfact yeti.");
        }
        else if (mini == "With Your Bare Hands")
        {
            description.listAppend("Fight beast-type monsters without a weapon equipped.|The icy peak (olfact yeti) or the dire warren?");
        }
        else if (mini == "Northern Digestion" || mini == "Frozen Dinners")
        {
        	if (canadia_available())
            {
            	if (availableFullness() > 0)
	                description.listAppend("Eat in Chez Snoteé.");
            }
            else
                description.listAppend("Ascend canadia moon sign.");
        }
        else if (mini == "ERR_VOLUME_FULL")
        {
            description.listAppend("Don't eat anything.");
        }
        else if (mini == "Really Bloody")
        {
        	if (inebriety_limit() == 0)
    	        description.listAppend("Ascend to drink Bloody Mary.");
            else
	            description.listAppend("Drink Bloody Mary.");
        }
        else if (mini == "System Clock Reset: It's 2006 again!")
        {
            if (inebriety_limit() == 0)
                description.listAppend("Ascend to drink White Canadians.");
            else
                description.listAppend("Drink White Canadians.");
        }
        else if (mini == "Liver of the Damned")
        {
            if (inebriety_limit() == 0)
                description.listAppend("Ascend to drink cursed bottles of rum.");
            else
                description.listAppend("Drink cursed bottles of rum.");
            description.listAppend("Run -combat at the Poop Deck, set an open course to 1,1, open the cursed chests.");
            modifiers.listAppend("-combat");
        }
        else if (mini == "Beast Master")
        {
            attacking_modifiers.listAppend("familiar weight");
            continue;
        }
        else if (mini == "Letter of the Moment")
        {
            attacking_modifiers.listAppend("letter of the moment");
            continue;
        }
        else if (mini == "ASCII-7 of the moment")
        {
            attacking_modifiers.listAppend("letter <strong>a</strong> in equipment");
            continue;
        }
        else if (mini == "Barely Dressed")
        {
            attacking_description.listAppend("do not equip equipment");
            continue;
        }
        else if (mini == "DEFACE")
        {
            attacking_description.listAppend("wear equipment with A/B/C/D/E/F/numbers in them");
            continue;
        }
        else if (mini == "Dressed to the 9s")
        {
            attacking_description.listAppend("wear equipment with numbers in them");
            continue;
        }
        else if (mini == "Optimal Dresser")
        {
            attacking_description.listAppend("wear low-power shirt/hat/pants");
            continue;
        }
        else if (mini == "Dressed in Rrrags" || mini == "Outfit Compression")
        {
            attacking_description.listAppend("wear short-named equipment");
            continue;
        }
        else if (mini == "Hibernation Ready" || mini == "All Bundled Up")
        {
            attacking_modifiers.listAppend("cold resistance");
            continue;
        }
        else if (mini == "Loot Hunter" || mini == "The Optimal Stat")
        {
            attacking_modifiers.listAppend("+item");
            continue;
        }
        else if (mini == "Safari Chic")
        {
            attacking_modifiers.listAppend("equipment autosell value");
            continue;
        }
        else if (mini == "Checking It Twice")
        {
            attacking_description.listAppend("target players you haven't fought twice");
            continue;
        }
        else if (mini == "Ice Hunter")
        {
            description.listAppend("Fight ice skates. Either fax/wish/copy them, or olfact them in the The Skate Park underwater.");
        }
        else if (mini == "Bear Hugs All Around" || mini == "Sharing the Love (to stay warm)" || mini == "Fair Game")
        {
            description.listAppend("Maximise fightgen, attack as many unique opponents as possible.");
        }
        else if (mini == "Most Things Eaten")
        {
        	string line = "Eat as many one-fullness foods as possible.";
            if (__campground[$item[portable mayo clinic]] > 0 && availableDrunkenness() > 0)
                line += "|Also use mayodiol.";
            description.listAppend(line);
        }
        else if (mini == "Beta Tester" || mini == "Optimal War")
        {
            if (__quest_state["Level 12"].finished)
            {
                description.listAppend("Ascend to fight in war.");
            }
            else if (!__quest_state["Level 12"].started)
            {
                description.listAppend("Start the war.");
            }
            else
            {
                description.listAppend("Finish the war for the frat side, with five sidequests completed. (iron beta of industry reward)");
            }
        }
        else if (mini == "Snow Patrol")
        {
        	if (__quest_state["Level 12"].finished)
            {
                description.listAppend("Ascend to fight in war.");
            }
            else if (!__quest_state["Level 12"].started)
            {
                description.listAppend("Start the war.");
            }
            else
            {
            	modifiers.listAppend("+4 cold res");
                string line = "Fight on the battlefield";
                if (numeric_modifier("cold resistance") < 4)
                	line += HTMLGenerateSpanFont(" with +4 cold resistance", "red");
                line += ".";
                description.listAppend(line);
            }
        }
        else
        {
        	if (my_id() == 1557284)
	        	description.listAppend(HTMLGenerateSpanFont("Unhandled mini \"" + mini + "\".", "red"));
            else
        		continue;
        }
        overall_modifiers.listAppendList(modifiers);
        if (description.count() > 0)
	        overall_description.listAppend(description.listJoinComponents("|*"));
        //entry.subentries.listAppend(ChecklistSubentryMake(mini, modifiers, description));
    }
    if (overall_description.count() > 0)
    {
    	entry.subentries.listAppend(ChecklistSubentryMake("Work on PVP minis", overall_modifiers, overall_description));
    }
    if (attacking_modifiers.count() > 0)
    	attacking_description.listAppend("maximise " + attacking_modifiers.listJoinComponents(" / "));
    if (attacking_description.count() > 0)
    {
        entry.subentries.listAppend(ChecklistSubentryMake("When attacking", attacking_modifiers, attacking_description.listJoinComponents(", ", "and ").capitaliseFirstLetter() + "."));
    }
    
    if (entry.subentries.count() > 0)
    {
        entry.image_lookup_name = "__effect Swordholder";
        entry.url = "peevpee.php";
        entry.tags.id = "PVP suggestions";
        entry.importance_level = 6;
        optional_task_entries.listAppend(entry);
    }
}
