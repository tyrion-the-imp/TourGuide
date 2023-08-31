boolean hasAnySkillOf(string [int] skillNames) {
    foreach i in skillNames {
        string skillName = skillNames[i];
        if (lookupSkill(skillName).have_skill()) {
            return true;
        }
    }
    return false;
}

RegisterTaskGenerationFunction("IOTMSITCertificateGenerateTasks");
void IOTMSITCertificateGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries) {
    // Don't generate a tile if the user doesn't have SIT.
    if (!lookupItem("S.I.T. Course Completion Certificate").have()) return;

    // Cannot use S.I.T. in G-Lover    
    if (my_path().id == PATH_G_LOVER) return;

    // Nag if we haven't picked a skill during this ascension   or haven't changed it today
    string [int] skillNames = {"Psychogeologist", "Insectologist", "Cryptobotanist"};
    if ( hasAnySkillOf(skillNames) && get_property_boolean("_sitCourseCompleted") ) {
        return;
    }

    string [int] description;
    string url = "inv_use.php?pwd=" + my_hash() + "&which=3&whichitem=11116";
    string main_title = "S.I.T. Course Enrollment";    
    string subtitle = "";

    string [int] miscPhrases = {
        "Don't play hooky!",
        "You already paid for it.",
        "This one time, at band camp,...",
        "This one time in college...",
        "Bright college days, oh, carefree days that fly.", // <3 tom lehrer
        "No child of mine is leaving here without a degree!",
        "Make like a tree and leaf (through your papers).",
    };

    string miscPhrase = miscPhrases[random(count(miscPhrases))];
    description.listAppend(HTMLGenerateSpanFont(miscPhrase + " Take your S.I.T. course!", "red"));
	description.listAppend("<a href='https://kol.coldfront.net/thekolwiki/index.php/Examine_S.I.T._Course_Certificate#Notes' target='_blank'><span style='color:blue; font-size:100%; font-weight:normal;'>Notes table</span></a>");
	description.listAppend("Current: " + HTMLGenerateSpanOfClass(get_property("currentSITSkill"), "r_fuchsia"));
    description.listAppend(HTMLGenerateSpanFont("Psych: L1-7 = +30% M3, +3 sl.res, +3 sp.res", "black"));
    description.listAppend(HTMLGenerateSpanFont("Psych: L8+ = +30 ML, booze, +5 lb. & +10 fam.dmg", "black"));
	description.listAppend(HTMLGenerateSpanFont("Insect: L1-7 = +25 st.dmg, delevel, +10 h.dmg", "blue"));
    description.listAppend(HTMLGenerateSpanFont("Insect: L8+ = +6 stats/fight, +100% meat, booze (D1 awesome)", "blue"));
	description.listAppend(HTMLGenerateSpanFont("Crypto: L1-7 = +15 mp regen, +50% item, +25 hp regen", "green"));
    description.listAppend(HTMLGenerateSpanFont("Crypto: L8+ = +10 spell & h.dmg, +100% init (S1), food (F1 awesome)", "green"));
    //task_entries.listAppend(ChecklistEntryMake("__item S.I.T. Course Completion Certificate", url, ChecklistSubentryMake(main_title, description), -11).ChecklistEntrySetIDTag("S.I.T. Course Completion Certificate"));
    
    if (hasAnySkillOf(skillNames)) {
        if (lookupSkill("Psychogeologist").have_skill())    subtitle = "you have ML; consider <b>Insectology</b>, for meat?";
        if (lookupSkill("Insectologist").have_skill())      subtitle = "you have Meat; consider <b>Psychogeology</b>, for ML?";
        if (lookupSkill("Cryptobotanist").have_skill())     subtitle = "you have Init; consider <b>Insectology</b>, for meat?";
        
        if (__misc_state["in run"]) {
            // If in-run, generate a supernag
            description.listAppend("Try changing your S.I.T. course to accumulate different items.");
            task_entries.listAppend(ChecklistEntryMake("__item S.I.T. Course Completion Certificate", url, ChecklistSubentryMake(main_title, subtitle, description), -11).ChecklistEntrySetIDTag("S.I.T. Course Completion Certificate"));
        } 
        else {
            // If not, generate an optional task
            main_title = "Could change your S.I.T. skill, for new items...";
            optional_task_entries.listAppend(ChecklistEntryMake("__item S.I.T. Course Completion Certificate", url, ChecklistSubentryMake(main_title, subtitle, description), 1).ChecklistEntrySetIDTag("S.I.T. Course Completion Certificate"));
        }
    } 
    else {
        // If they don't have a skill, generate a supernag.
        string miscPhrase = miscPhrases[random(count(miscPhrases))];
        description.listAppend(HTMLGenerateSpanFont(miscPhrase + " Take your S.I.T. course!", "red"));
        task_entries.listAppend(ChecklistEntryMake("__item S.I.T. Course Completion Certificate", url, ChecklistSubentryMake(main_title, subtitle, description), -11).ChecklistEntrySetIDTag("S.I.T. Course Completion Certificate"));
    }

}