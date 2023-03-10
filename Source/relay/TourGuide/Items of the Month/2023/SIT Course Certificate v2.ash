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

    if (!get_property_boolean("_sitCourseCompleted")) {
        title = HTMLGenerateSpanFont("Enroll in a SIT course!", "black");
        description.listAppend("" + HTMLGenerateSpanOfClass("", "r_bold") + "Insectology (meat)");
        description.listAppend("" + HTMLGenerateSpanOfClass("", "r_bold") + "Cryptobotany (items)");
        task_entries.listAppend(ChecklistEntryMake("__item S.I.T. Course Completion Certificate", url, ChecklistSubentryMake(title, description), -11));
    }
}