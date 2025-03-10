import "relay/TourGuide/Support/Checklist.ash";
import "relay/TourGuide/QuestState.ash";

void generateMissingItems(Checklist [int] checklists)
{
    ChecklistEntry [int] items_needed_entries;
    
    if (!__misc_state["in run"])
        return;
    if (my_path().id == PATH_COMMUNITY_SERVICE)
        return;
    
    //thought about using getClickableURLForLocationIfAvailable for these, but our location detection is very poor, and there are corner cases regardless
    
    if (__misc_state["wand of nagamar needed"]) {
        ChecklistSubentry [int] subentries;
        
        subentries.listAppend(ChecklistSubentryMake("Wand of Nagamar", "", ""));
        
        Record WandComponentSource {
            item component;
            int drop_rate;
            monster monster_dropped_from;
            location location_dropped_from;
        };
        void listAppend(WandComponentSource [int] list, WandComponentSource entry) {
            int position = list.count();
            while (list contains position)
                position += 1;
            list[position] = entry;
        }
        
        WandComponentSource [int] component_sources;
        
        if (__misc_state_int["ruby w needed"] > 0) {
            WandComponentSource source;
            source.component = $item[ruby w];
            source.drop_rate = 30;
            source.monster_dropped_from = $monster[W imp];
            if (__quest_state["Level 6"].finished)
                source.location_dropped_from = $location[Pandamonium Slums];
            else
                source.location_dropped_from = $location[the dark neck of the woods];
            component_sources.listAppend(source);
        }
        
        if (__misc_state_int["metallic a needed"] > 0) {
            WandComponentSource source;
            source.component = $item[metallic a];
            source.drop_rate = 30;
            source.monster_dropped_from = $monster[MagiMechTech MechaMech];
            source.location_dropped_from = $location[The Penultimate Fantasy Airship];
            component_sources.listAppend(source);
        }
        
        if (__misc_state_int["lowercase n needed"] > 0 && __misc_state_int["lowercase n available"] == 0) {
            WandComponentSource source;
            source.component = $item[lowercase n];
            source.drop_rate = 30;
            source.monster_dropped_from = $monster[XXX pr0n];
            source.location_dropped_from = $location[The Valley of Rof L\'m Fao];
            component_sources.listAppend(source);
        }
        
        if (__misc_state_int["heavy d needed"] > 0) {
            WandComponentSource source;
            source.component = $item[heavy d];
            source.drop_rate = 40;
            source.monster_dropped_from = $monster[Alphabet Giant];
            source.location_dropped_from = $location[The Castle in the Clouds in the Sky (Basement)];
            component_sources.listAppend(source);
        }
        
        foreach key, source in component_sources {
            if (source.component.available_amount() > 0)
                continue;
            string modifier_text = "";
            if (!in_bad_moon())
                modifier_text = "Clover or ";
            if (source.drop_rate > 0 && source.drop_rate < 100) {
                int drop_rate_inverse = ceil(100.0 / source.drop_rate.to_float() * 100.0 - 100.0);
                modifier_text += "+" + drop_rate_inverse + "% item";
            }
            
            string [int] description;
            if (!in_bad_moon())
                description.listAppend("Clover the castle basement.");
            description.listAppend(source.monster_dropped_from + " - " + source.location_dropped_from + " - " + source.drop_rate + "% drop");
            subentries.listAppend(ChecklistSubentryMake(source.component, modifier_text, description));
        }
        
        if (subentries.count() == 1)
            subentries[0].entries.listAppend("Can create it.");
        else if (!__misc_state["can use clovers"])
            subentries[0].entries.listAppend("Either meatpaste together, or find after losing to the naughty sorceress. (" + (in_bad_moon() ? "probably faster" : "usually slower") + ")");
            
        ChecklistEntry entry = ChecklistEntryMake("__item wand of nagamar", $location[the castle in the clouds in the sky (basement)].getClickableURLForLocation(), subentries);
        entry.tags.id = "Wand of Nagamar reminder";
        entry.should_indent_after_first_subentry = true;
        
        items_needed_entries.listAppend(entry);
    }
    
    if (my_path().id != PATH_LOW_KEY_SUMMER) //keys are in their own section in this path
        SLevel13DoorGenerateMissingItems(items_needed_entries);
    
    if ($item[lord spookyraven\'s spectacles].available_amount() == 0 && __quest_state["Level 11 Manor"].state_boolean["Can use fast route"] && !__quest_state["Level 11 Manor"].finished)
        items_needed_entries.listAppend(ChecklistEntryMake("__item lord spookyraven's spectacles", $location[the haunted bedroom].getClickableURLForLocation(), ChecklistSubentryMake("Lord Spookyraven's spectacles", "", "Found in Haunted Bedroom")).ChecklistEntrySetIDTag("Lord spookyraven spectacles reminder"));
    
    if ($item[enchanted bean].available_amount() == 0 && !__quest_state["Level 10"].state_boolean["beanstalk grown"]) {
        items_needed_entries.listAppend(ChecklistEntryMake("__item enchanted bean", $location[The Beanbat Chamber].getClickableURLForLocation(), ChecklistSubentryMake("Enchanted bean", "", "Found in the beanbat chamber.")).ChecklistEntrySetIDTag("Enchanted bean reminder"));
    }
    
    if (__quest_state["Level 13"].state_boolean["shadow will need to be defeated"]) {
        //Let's see
        //5 gauze garters + filthy poultices
        //Or...
        //red pixel potion (not worth farming, but if they have it...)
        //red potion
        //extra-strength red potion (they might find it)
        
    }
    if (__quest_state["Level 11 Palindome"].state_boolean["Need instant camera"]) {
        item camera = 7266.to_item();
        if (camera != $item[none]) {
            items_needed_entries.listAppend(ChecklistEntryMake("__item " + camera, $location[the haunted bedroom].getClickableURLForLocation(), ChecklistSubentryMake("Disposable instant camera", "", "Found in the Haunted Bedroom.")).ChecklistEntrySetIDTag("Instant camera reminder"));
        }
    }
    
    if ($item[electric boning knife].available_amount() == 0 && __quest_state["Level 13"].state_boolean["wall of bones will need to be defeated"] && my_path().id != PATH_POCKET_FAMILIARS) {
        string [int] description;
        description.listAppend("Found from an NC on the ground floor of the castle in the clouds in the sky.");
        boolean can_towerkill = false;
        if ($skill[garbage nova].skill_is_usable()) {
            description.listAppend("Ignore this, you can towerkill with Garbage Nova.");
            can_towerkill = true;
        } else if (!in_bad_moon())
            description.listAppend("Or towerkill.");
        if (!can_towerkill && !__quest_state["Level 13"].state_boolean["past tower level 2"] && $location[the castle in the clouds in the sky (top floor)].locationAvailable())
            description.listAppend("Don't collect this right now; wait until you're at the wall of bones.|(probability of appearing increases)");
        items_needed_entries.listAppend(ChecklistEntryMake("__item electric boning knife", $location[the castle in the clouds in the sky (ground floor)].getClickableURLForLocation(), ChecklistSubentryMake("Electric boning knife", "-combat", description)).ChecklistEntrySetIDTag("Electric boning knife reminder"));
    }
    if ($item[beehive].available_amount() == 0 && __quest_state["Level 13"].state_boolean["wall of skin will need to be defeated"] && my_path().id != PATH_POCKET_FAMILIARS) {
        string [int] description;
        
        description.listAppend("Found from an NC in the black forest.");
        
        if (get_property_int("blackForestProgress") >= 1)
            description.listAppend(listMake("Head toward the blackberry patch", "Head toward the buzzing sound", "Keep going", "Almost... there...").listJoinComponents(__html_right_arrow_character));
        else
            description.listAppend("Not available yet.");
        if (!in_bad_moon())
            description.listAppend("Or towerkill.");
        
        items_needed_entries.listAppend(ChecklistEntryMake("__item beehive", $location[the black forest].getClickableURLForLocation(), ChecklistSubentryMake("Beehive", "-combat", description)).ChecklistEntrySetIDTag("Beehive reminder"));
    }
    
    if (!__quest_state["Level 13"].state_boolean["past races"]) {
        ChecklistSubentry subentry = ChecklistSubentryMake("Sources", "", "For the lair races.");
        string [int] sources;
        if (!__quest_state["Level 13"].state_boolean["Init race completed"]) {
            subentry.modifiers.listAppend("+init");
            sources.listAppend("init");
            //subentries.listAppend(ChecklistSubentryMake("+init sources", "+init", "For the lair races."));
        }
        if (!__quest_state["Level 13"].state_boolean["Stat race completed"] && __quest_state["Level 13"].state_string["Stat race type"] != "") {
            //
            subentry.modifiers.listAppend("+" + __quest_state["Level 13"].state_string["Stat race type"]);
            sources.listAppend(__quest_state["Level 13"].state_string["Stat race type"]);
        }
        if (!__quest_state["Level 13"].state_boolean["Elemental damage race completed"] && __quest_state["Level 13"].state_string["Elemental damage race type"] != "") {
            //
            string type = __quest_state["Level 13"].state_string["Elemental damage race type"];
            string type_class = "r_element_" + type + "_desaturated";
            subentry.modifiers.listAppend(HTMLGenerateSpanOfClass("+" + type + " damage", type_class));
            subentry.modifiers.listAppend(HTMLGenerateSpanOfClass("+" + type + " spell damage", type_class));
            sources.listAppend(type);
        }
        string [int] relevant_elements;
        foreach s in $strings[nsChallenge3,nsChallenge4,nsChallenge5] {
            element e = get_property_element(s);
            if (e == $element[none]) { continue; }
            if (numeric_modifier(e + " resistance") >= 7) { continue; }
            string type_class = "r_element_" + e;
            string type_class_desaturated = "r_element_" + e + "_desaturated";
            relevant_elements.listAppend(HTMLGenerateSpanOfClass("+" + e, type_class) + " resistance");
            subentry.modifiers.listAppend(HTMLGenerateSpanOfClass("+" + e, type_class_desaturated) + " res");
        }
        if (relevant_elements.count() > 0)
            subentry.entries.listAppend(relevant_elements.listJoinComponents(", ", "and").capitaliseFirstLetter() + " for the hedge maze.");
        
        subentry.header = sources.listJoinComponents(", ", "and").capitaliseFirstLetter() + " sources";
        if (subentry.modifiers.count() > 0)
            items_needed_entries.listAppend(ChecklistEntryMake("__item vial of patchouli oil", "", subentry).ChecklistEntrySetIDTag("NS lair pre-door challenges reminder"));
    }
    
    checklists.listAppend(ChecklistMake("Required Items", items_needed_entries));
}
