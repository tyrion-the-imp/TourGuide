//2021
//Miniature Crystal ball
RegisterResourceGenerationFunction("IOTMCrystalBallGenerateTasks");
void IOTMCrystalBallGenerateTasks(ChecklistEntry [int] resource_entries)
{
	if (lookupItem("miniature crystal ball").available_amount() == 0)
		return;
	string title = "Miniature crystal ball monster prediction";
	string image_name = "__item miniature crystal ball";
	monster crystalBallPrediction = (get_property_monster("crystalBallMonster"));
	location crystalBallZone = (get_property_location("crystalBallLocation"));
	image_name = "__monster " + crystalBallPrediction;
	string [int] description;
	string url = invSearch("miniature crystal ball");
	if (!lookupItem("miniature crystal ball").equipped())
	{
		if (crystalBallPrediction != $monster[none])
		{
			description.listAppend("Next fight in " + HTMLGenerateSpanFont(crystalBallZone, "black") + " will be: " + HTMLGenerateSpanFont(crystalBallPrediction, "black"));
			description.listAppend("" + HTMLGenerateSpanFont("Equip the miniature crystal ball first!", "red") + "");
			resource_entries.listAppend(ChecklistEntryMake(image_name, url, ChecklistSubentryMake(title, description), -11));
		}
		else
		{
			description.listAppend("Equip the miniature crystal ball to predict a monster!");
			resource_entries.listAppend(ChecklistEntryMake("__item miniature crystal ball", url, ChecklistSubentryMake(title, description)));
		}
	}
	else
	{
		if (crystalBallPrediction != $monster[none])
		{
			description.listAppend("Next fight in " + HTMLGenerateSpanFont(crystalBallZone, "blue") + " will be: " + HTMLGenerateSpanFont(crystalBallPrediction, "blue"));
			resource_entries.listAppend(ChecklistEntryMake(image_name, url, ChecklistSubentryMake(title, description), -11));
		}
		else
		{
			description.listAppend("Adventure in a snarfblat to predict a monster!");
			resource_entries.listAppend(ChecklistEntryMake("__item quantum of familiar", url, ChecklistSubentryMake(title, description)));
		}	
	}
}

// Miniature crystal ball
RegisterTaskGenerationFunction("IOTMCrystalBallGenerateTasks");
void IOTMCrystalBallGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	string title = "Next monster?";
	string [int] description; // No general orb description yet.
	string [int] orb_predictions = get_property("crystalBallPredictions").split_string("[|]"); // Breaks mafia's orb tracking propterty down into a map of individual predictions.
	int orbimp = -10;
	if ( __iotms_usable[$item[miniature crystal ball]] ) // Only do things if we have the orb.
	{
		if (orb_predictions[0] != "") { // If the prediction property isn't empty:
            description.listAppend(HTMLGenerateSpanFont("Miniature crystal ball monster prediction. These predictions may not be accurate, the crystal ball is very fiddly.", "grey"));
			foreach x in orb_predictions { // For every indidivual prediction,
                string [int] split_predictions = orb_predictions[x].split_string(":"); // break down the prediciton into turn/zone/monster
				description.listAppend("Monster: " + split_predictions[2] + " | Zone: "+ split_predictions[1] + " | " + (split_predictions[0].to_int() + 2 - my_turncount() > 0 ? ("Turns left: " + (split_predictions[0].to_int() + 2 - my_turncount()).to_string()) : "Expired")); // then format and add the prediction substrings to the crystal ball tile.
			}

            string tile_image = count(orb_predictions) == 1 ? "__monster " + orb_predictions[0].split_string(":")[2] : "__item quantum of familiar";
            if (!have_equipped($item[miniature crystal ball])) { // If we don't have the crystal ball equipped, add a reminder.
                description.listAppend(HTMLGenerateSpanFont("Equip your miniature crystal ball if you want to encounter your predictions!", "red"));
                optional_task_entries.listAppend(ChecklistEntryMake(tile_image, "familiar.php", ChecklistSubentryMake(title, description), -10)); // Optional task if not equipped.
                //task_entries.listAppend(ChecklistEntryMake(tile_image, "familiar.php", ChecklistSubentryMake(title, description), orbimp));
            }
			else {
            	task_entries.listAppend(ChecklistEntryMake(tile_image, "familiar.php", ChecklistSubentryMake(title, description), orbimp));
			}
        }
        else { // If we don't have any predictions, let us know.
            description.listAppend("The crystal ball will predict the next monster in a zone. Adventure in the zone again to encounter the monster, or elsewhere to reset the prediction.");
 			description.listAppend("You currently have no predicitons.");
            if (!have_equipped($item[miniature crystal ball]))
            {							
                description.listAppend(HTMLGenerateSpanFont("Equip the miniature crystal ball to predict a monster!", "red"));
            }
			optional_task_entries.listAppend(ChecklistEntryMake("__item miniature crystal ball", "familiar.php", ChecklistSubentryMake(title, description), -1));
			//task_entries.listAppend(ChecklistEntryMake("__item miniature crystal ball", "familiar.php", ChecklistSubentryMake(title, description), orbimp));
        }
    }
}