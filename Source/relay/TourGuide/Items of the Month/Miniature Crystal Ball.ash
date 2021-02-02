RegisterTaskGenerationFunction("IOTMCrystalBallGenerateTasks");
void IOTMCrystalBallGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
        string title;
		string url = "inventory.php?ftext=miniature crystal";
		if	( lookupItem("miniature crystal ball").equipped() ) {
			url = "inventory.php?which=2";
		}
        title = "crystal ball monster";
        string crystalBallPrediction = get_property("crystalBallMonster");
        string crystalBallLoc = get_property("crystalBallLocation");
		if	( crystalBallLoc == "" ) { crystalBallLoc = "unknown?"; }
		if	( crystalBallPrediction == "" ) { crystalBallPrediction = "no prediction?"; }
        string [int] description;
		description.listAppend("<a href='familiar.php' target='mainpane'><span style='color:green; font-size:100%; font-weight:normal;'>familiar.php</span></a>");
		description.listAppend("Equipped? <b>" + lookupItem("miniature crystal ball").equipped() + "</b>");
		description.listAppend("Next fight in <span style='color:fuchsia; font-size:100%; font-weight:bold;'>" + crystalBallLoc + "</span>");
		description.listAppend(HTMLGenerateSpanFont(crystalBallPrediction, "blue"));
		task_entries.listAppend(ChecklistEntryMake("__item miniature crystal ball", url, ChecklistSubentryMake(title, description), -11));
}