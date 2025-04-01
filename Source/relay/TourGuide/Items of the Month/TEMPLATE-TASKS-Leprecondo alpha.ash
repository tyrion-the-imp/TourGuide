//Leprecondo alpha.ash		2025.04.01
/* 
https://github.com/loathers/yorick/blob/231403626c3d60cf4faad072559efc0a6665ab0c/src/sections/resources/2025/Leprecondo.tsx

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




*/

RegisterTaskGenerationFunction("IOTMLeprecondoGenerateTasks");
void IOTMLeprecondoGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{




return;
}
