//glaciest tasks
RegisterTaskGenerationFunction("IOTMGlaciestGenerateTasks");
void IOTMGlaciestGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (!__misc_state["cold airport available"])
        return;
    string [int] description;
    string url = "place.php?whichplace=airport_cold";
    {
        if (($locations[vykea] contains __last_adventure_location) && (!get_property_boolean("_VYKEALoungeRaided"))) {
            description.listAppend("+3 Wal-Mart Gift Certificates");
            task_entries.listAppend(ChecklistEntryMake("__monster VYKEA viking (male)", url, ChecklistSubentryMake("VYKEA gift certificates available", "", description), -11));
        }
        if (($locations[the ice hotel] contains __last_adventure_location) && (!get_property_boolean("_iceHotelRoomsRaided"))) {
            description.listAppend("+3 Wal-Mart Gift Certificates");
            task_entries.listAppend(ChecklistEntryMake("__monster ice clerk", url, ChecklistSubentryMake("Ice Hotel gift certificates available", "", description), -11));
        }
    }
}