//SIT course certificate
RegisterTaskGenerationFunction("IOTMSITCertificateGenerateTasks2");
void IOTMSITCertificateGenerateTasks2(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    //if (!__misc_state["in run"]) return;
    if (!lookupItem("S.I.T. Course Completion Certificate").have()) return;
    string SITCourse = get_property_int("currentSITSkill");
    string url = "inv_use.php?pwd=" + my_hash() + "&which=3&whichitem=11116";
    string title;
    string [int] description;

    if (my_level() == 8 || !get_property_boolean("_sitCourseCompleted")) {
        title = HTMLGenerateSpanFont("Enroll in a SIT course!", "black");
        description.listAppend("<a href='https://kol.coldfront.net/thekolwiki/index.php/Examine_S.I.T._Course_Certificate#Notes' target='_blank'><span style='color:blue; font-size:100%; font-weight:normal;'>Notes table</span></a>");
        description.listAppend("Current: " + HTMLGenerateSpanOfClass(get_property("currentSITSkill"), "r_fuchsia"));
        description.listAppend("" + HTMLGenerateSpanOfClass("", "r_bold") + "Psychogeologist (ML, lbs, L8 up)");
        description.listAppend("" + HTMLGenerateSpanOfClass("", "r_bold") + "Insectology (meat, L8 up)");
        description.listAppend("" + HTMLGenerateSpanOfClass("", "r_bold") + "Cryptobotany (items, to L7)");
        task_entries.listAppend(ChecklistEntryMake("__item S.I.T. Course Completion Certificate", url, ChecklistSubentryMake(title, description), -11));
    }
}