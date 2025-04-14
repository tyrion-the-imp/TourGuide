//Leprecondo alpha.ash		2025.04.01
/* 
https://github.com/loathers/yorick/blob/231403626c3d60cf4faad072559efc0a6665ab0c/src/sections/resources/2025/Leprecondo.tsx

refer to: C:\github\TourGuide\Source\relay\TourGuide\Support\Checklist.ash


record ChecklistSubentry
{
	string header;
	string [int] modifiers;
	string [int] entries;
};


//combo tags combination tags
record TagGroup
{
    string id; //For the "minimize" feature to keep track of the entries. Uses 'combination' instead if present. Uses the first entry's header if empty.
    string combination; //Entries with identical combination tags will be combined into one, with the "first" taking precedence.
};



int CHECKLIST_DEFAULT_IMPORTANCE = 0;
record ChecklistEntry
{
	string image_lookup_name;
	string url;
    string [string] container_div_attributes;
	ChecklistSubentry [int] subentries;
    TagGroup tags; //meta-informations about the entry
	boolean should_indent_after_first_subentry;
    
    boolean should_highlight;
	
	int importance_level; //Entries will be resorted by importance level before output, ascending order. Default importance is 0. Convention is to vary it from [-11, 11] for reasons that are clear and well supported in the narrative.
    boolean only_show_as_extra_important_pop_up; //only valid if -11 importance or lower - only shows up as a pop-up, meant to inform the user they can scroll up to see something else (semi-rares)
    ChecklistSubentry [int] subentries_on_mouse_over; //replaces subentries
};


record Checklist
{
	string title;
	ChecklistEntry [int] entries;
    
    boolean disable_generating_id; //disable generating checklist anchor and title-based div identifier
};


Record ChecklistCollection
{
    Checklist [string] checklists;
};


RegisterTaskGenerationFunction("IOTMLeprecondoGenerateTasks");
void IOTMLeprecondoGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)



//RegisterResourceGenerationFunction("IOTMSugarGenerateResource");
//void IOTMSugarGenerateResource(ChecklistEntry [int] resource_entries)



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

RegisterTaskGenerationFunction("IOTMtemplatetasksGenerateTasks");
void IOTMtemplatetasksGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
/*
//ChecklistEntry
string image_lookup_name;
string url;
string [string] container_div_attributes;
ChecklistSubentry [int] subentries;
TagGroup tags; //meta-informations about the entry
boolean should_indent_after_first_subentry;
boolean should_highlight;
int importance_level; //Entries will be resorted by importance level before output, ascending order. Default importance is 0. Convention is to vary it from [-11, 11] for reasons that are clear and well supported in the narrative.
boolean only_show_as_extra_important_pop_up; //only valid if -11 importance or lower - only shows up as a pop-up, meant to inform the user they can scroll up to see something else (semi-rares)
ChecklistSubentry [int] subentries_on_mouse_over; //replaces subentries
*/

/*
//ChecklistSubentry
string header;
string [int] modifiers;
string [int] entries;
*/

item this_item = $item[none];
string url = "inventory.php?ftext=Leprecondo";
string [int] these_modifiers;
string[int] these_entries;
int implev = -10;
#if	( !get_property_boolean("kingLiberated") ) { implev = -10; }
#if	( !is_unrestricted(this_item) ) { return; }


these_modifiers.listAppend("hosebag");
these_entries.listAppend("testing");

//resource_entries.listAppend(ChecklistEntryMake(entry.image_lookup_name, entry.url, ChecklistSubentryMake(pluralise(free_fights_remaining, "free elf fight", "free elf fights"), modifiers, description), importance_level).ChecklistEntrySetCombinationTag("daily free fight").ChecklistEntrySetIDTag("Machine elf free fights"));

//task_entries.listAppend(ChecklistEntryMake("Leprecondo", url, ChecklistSubentryMake("boogey down", "", these_entries), -11).ChecklistEntrySetIDTag("Council L12 quest exploathing path"));
task_entries.listAppend(ChecklistEntryMake("Leprecondo", url, ChecklistSubentryMake("boogey down", these_modifiers, these_entries), 25).ChecklistEntrySetIDTag("Leprecondo tasks tile"));

//	optional_task_entries.listAppend(ChecklistEntryMake("__item inflatable duck", "", ChecklistSubentryMake("The Old Man's Bathtime Adventure", modifiers, description),$locations[The Old Man's Bathtime Adventures]).ChecklistEntrySetIDTag("Psychoanalytic jar old man"));

//	future_task_entries


return;
}
