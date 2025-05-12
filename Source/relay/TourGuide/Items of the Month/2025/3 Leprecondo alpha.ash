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


Leprecondo, usable, Mar 2025, 2025.03

> ppp condo

user:
_leprecondoFurniture
0
_leprecondoRearrangements
0
leprecondoCurrentNeed
food
leprecondoDiscovered
1,2,3,4,5,6,13,20,21,23
leprecondoInstalled
21,1,23,20
leprecondoLastNeedChange
31
leprecondoNeedOrder
food,mental stimulation,exercise,sleep,dumb entertainment,booze
Loading "inventory.php?which=f3".

[All props backed up.] |||since rollover: hrs 19 | mins 1168 |||12-hr: hrs 5 | mins 58
after msgs only

Preference leprecondoInstalled changed from 21,1,23,20 to 20,23,1,21
Preference _leprecondoRearrangements changed from 0 to 1
after msgs only

> ppp lepre

user:
_leprecondoFurniture
0
_leprecondoRearrangements
0
leprecondoCurrentNeed
food
leprecondoDiscovered
1,2,3,4,5,6,12,13,20,21,23
leprecondoInstalled
0,0,0,0
leprecondoLastNeedChange
236
leprecondoNeedOrder
sleep,mental stimulation,exercise,booze,food,dumb entertainment
Preference leprecondoInstalled changed from 0,0,0,0 to 21,23,1,5
after msgs only

> help lepr

leprecondo blank | furnish [a,b,c,d] | available | missing - deal with your Leprecondo
(also 'condo' user-script)

> leprecondo available

(this is a nice table in the cli)
FurnitureNeed 1Need 2buckets of concreteexercisethrift store oil paintingmental stimulationboxes of old comic booksdumb entertainmentsecond-hand hot platefoodbeer coolerboozefree mattresssleepinternet-connected laptopdumb entertainmentmental stimulationsous vide laboratorymental stimulationfoodfine upholstered dining table setfoodsleepwhiskeybedboozesleepcomplete classics librarymental stimulation

ch#1556
	.1	Lock in your Interior Decoration		(only choice)		can walk away
	4X <select> for furniture items 	need to capture a link with all params

use leprecondo (to choice 1556)
inv_use.php?pwd=cced219382855f26674146eeaee0fd30&which=f3&whichitem=11861


*/

RegisterTaskGenerationFunction("IOTMLeprecondoGenerateTasks");
void IOTMLeprecondoGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
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

#11861 Leprecondo

item this_item = $item[Leprecondo];
string url = "inventory.php?ftext=Leprecondo";
string info_url = "https://kol.coldfront.net/thekolwiki/index.php/Leprechaun%27s_Condo#Notes";
string [int] these_modifiers;
string[int] these_entries;
int implev = 10;
if	( !get_property_boolean("kingLiberated") ) { implev = 10; }
if	( !is_unrestricted(this_item) ) { return; }
if	( get_property_int("_leprecondoRearrangements") >= 3 ) { implev = 10; }


//these_modifiers.listAppend("hosebag");

foreach s in $strings[
_leprecondoFurniture,
_leprecondoRearrangements,
leprecondoCurrentNeed,
leprecondoDiscovered,
leprecondoInstalled,
leprecondoLastNeedChange,
leprecondoNeedOrder,
] {
	//_leprecondoFurniture = checks how many furniture pieces found today
	//all furniture is discovered by AR & MB
	if	( s == "leprecondoDiscovered" || s == "_leprecondoFurniture" ) { continue; }
	these_entries.listAppend("<b>"+s+"</b> = "+get_property(s));
	if	( s == "leprecondoLastNeedChange" ) {
		these_entries.listAppend("<span style='color:red;'><b>Current Turn</b> = "+turns_played()+"</span>");
		these_entries.listAppend("<span style='color:orange;'><b>Next Change</b> = "+(get_property_int("leprecondoLastNeedChange") + 6 )+"</span>");
	}
}

string url_for_use = "inv_use.php?pwd="+my_hash()+"&whichitem=11861";
these_entries.listAppend("<span style='color:blue; font-weight:bold;'>use leprecondo (to choice 1556)</span>: <a href='"+url_for_use+"' target='mainpane'><span style='color:red; font-size:100%; font-weight:normal;'>use item</span></a>");
these_entries.listAppend("<span style='color:blue; font-weight:bold;'>leprecondo</span>: <a href='"+info_url+"' target='_blank'><span style='color:red; font-size:100%; font-weight:normal;'>info</span></a>");

if	( implev == 10 ) {
	implev = -11;
	optional_task_entries.listAppend(ChecklistEntryMake("Leprecondo", url, ChecklistSubentryMake("Leprecondo[2025.03]", these_modifiers, these_entries), implev).ChecklistEntrySetIDTag("Leprecondo tasks tile"));
} else {
	//https://kol.coldfront.net/thekolwiki/index.php/Leprechaun%27s_Condo#Notes

	//resource_entries.listAppend(ChecklistEntryMake(entry.image_lookup_name, entry.url, ChecklistSubentryMake(pluralise(free_fights_remaining, "free elf fight", "free elf fights"), modifiers, description), importance_level).ChecklistEntrySetCombinationTag("daily free fight").ChecklistEntrySetIDTag("Machine elf free fights"));

	//task_entries.listAppend(ChecklistEntryMake("Leprecondo", url, ChecklistSubentryMake("boogey down", "", these_entries), -11).ChecklistEntrySetIDTag("Council L12 quest exploathing path"));
	task_entries.listAppend(ChecklistEntryMake("Leprecondo", url, ChecklistSubentryMake("Leprecondo[2025.03]", these_modifiers, these_entries), implev).ChecklistEntrySetIDTag("Leprecondo tasks tile"));

	//	optional_task_entries.listAppend(ChecklistEntryMake("__item inflatable duck", "", ChecklistSubentryMake("The Old Man's Bathtime Adventure", modifiers, description),$locations[The Old Man's Bathtime Adventures]).ChecklistEntrySetIDTag("Psychoanalytic jar old man"));

	//	future_task_entries
}


return;
}
