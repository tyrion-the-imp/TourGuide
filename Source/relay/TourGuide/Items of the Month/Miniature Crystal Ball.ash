RegisterTaskGenerationFunction("IOTMCrystalBallGenerateTasks");
void IOTMCrystalBallGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
        string title;
        title = "Miniature crystal ball monster prediction";
        int crystalBallPrediction = (get_property_int("crystalBallMonster"));
        int crystalBallZone = (get_property_int("crystalBallLocation"));
        string [int] description;
            if (!lookupItem("miniature crystal ball").equipped())
                description.listAppend("Next fight in " + crystalBallZone + " will be: ");
                description.listAppend(HTMLGenerateSpanFont(crystalBallPrediction, "blue"));
            else
            {
                description.listAppend("Next fight in " + crystalBallZone + " will be: ");
                description.listAppend(HTMLGenerateSpanFont(crystalBallPrediction, "blue"));
                task_entries.listAppend(ChecklistEntryMake("__item miniature crystal ball", "url", ChecklistSubentryMake(title, description), -11));
            }    
}