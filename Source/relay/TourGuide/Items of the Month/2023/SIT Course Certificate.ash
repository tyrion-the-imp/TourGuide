boolean hasAnySkillOf(string [int] skillNames) {
    foreach i in skillNames {
        string skillName = skillNames[i];
        if (lookupSkill(skillName).have_skill()) {
            return true;
        }
    }
    return false;
}

// Prompt to register which SIT course you took
RegisterTaskGenerationFunction("IOTMSITCertificateGenerateTasks");
void IOTMSITCertificateGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries) {
    if (!lookupItem("S.I.T. Course Completion Certificate").have())
        return;

    // Nag if we haven't picked a skill during this ascension    
    string [int] skillNames = {"Psychogeologist", "Insectologist", "Cryptobotanist"};
    if ( hasAnySkillOf(skillNames) ) {
        return;
    }

    string [int] description;
    string url = "inv_use.php?pwd=" + my_hash() + "&which=3&whichitem=11116";
    string main_title = "S.I.T. Course Enrollment";

    string [int] miscPhrases = {
        "Don't play hooky!",
        "You already paid for it.",
        "This one time in college...",
        "This one time, at band camp,...",
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
    task_entries.listAppend(ChecklistEntryMake("__item S.I.T. Course Completion Certificate", url, ChecklistSubentryMake(main_title, description), -11).ChecklistEntrySetIDTag("S.I.T. Course Completion Certificate"));
}
