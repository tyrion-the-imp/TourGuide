//Backup Camera
RegisterTaskGenerationFunction("IOTMBackupCameraGenerateTasks");
void IOTMBackupCameraGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	if (!lookupItem("backup camera").have()) return;
    string main_title = "Last monster?";
    string url = "";
    string [int] description;
	monster lcm = (get_property_monster("lastCopyableMonster"));
	int backup_camera_snapsUsed = get_property_int("_backUpUses");
	int backup_camera_uses_remaining = 11 - backup_camera_snapsUsed;
	int emotionNostalgic = clampi(3 - get_property_int("_feelNostalgicUsed"), 0, 3);
	if ( !skill_is_usable($skill[Feel Nostalgic]) ) emotionNostalgic = 0;
	description.listAppend("<span style='color:blue; font-size:90%; font-weight:bold;'>"+lcm.to_string()+"</span>");
	description.listAppend(backup_camera_uses_remaining + " backup camera snaps left");
	if ( emotionNostalgic > 0 )
		description.listAppend(emotionNostalgic + " Nostalgias left. Item copying. ");
	if (!lookupItem("backup camera").have_equipped())
		description.listAppend("<span style='color:red; font-size:100%; font-weight:bold;'>Equip backup camera!!</span>");
	if (lcm.to_string() != "" && lcm.to_string() != "none" && ( emotionNostalgic > 0 || backup_camera_uses_remaining > 0 ) )
		task_entries.listAppend(ChecklistEntryMake("__effect twist and an eye", url, ChecklistSubentryMake(main_title, "", description), -11).ChecklistEntrySetIDTag("Backup camera skill task"));
}

RegisterResourceGenerationFunction("IOTMBackupCameraGenerateResource");
void IOTMBackupCameraGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (!lookupItem("backup camera").have()) return;
		// Title
        string main_title = "Back It Up, Back It Up";
		string [int] description;

	
		// Entries
		int backup_camera_snapsUsed = get_property_int("_backUpUses");
        int totalBackupCameras = 11;
        if (my_path().id == PATH_YOU_ROBOT) {
            totalBackupCameras = 16;
			//for whatever awful reason, this is buggy and will miscount when you break prism until you relog
        }
		
		string url = "inventory.php?ftext=backup+camera";
		int backup_camera_uses_remaining = totalBackupCameras - backup_camera_snapsUsed;
		if (backup_camera_uses_remaining > 0)
		{
			string [int] description;
			monster nostalgicMonster = (get_property_monster("lastCopyableMonster"));
			description.listAppend(HTMLGenerateSpanFont(nostalgicMonster, "blue") + " is currently in your camera.");
			
			if (!lookupItem("backup camera").equipped())
				description.listAppend(HTMLGenerateSpanFont("Equip the backup camera first", "red"));
			else
				description.listAppend("Back up and fight your backup monster!");
			resource_entries.listAppend(ChecklistEntryMake("__item backup camera", url, ChecklistSubentryMake(backup_camera_uses_remaining + " backup camera snaps left", "", description)).ChecklistEntrySetIDTag("Backup camera skill resource"));
		}
}
