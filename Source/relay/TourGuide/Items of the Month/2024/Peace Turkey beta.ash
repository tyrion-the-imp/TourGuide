RegisterResourceGenerationFunction("IOTMPeaceTurkeyGenerateResourceBeta");
void IOTMPeaceTurkeyGenerateResourceBeta(ChecklistEntry [int] resource_entries)
{
    if (!lookupFamiliar("Peace Turkey").familiar_is_usable()) return;

    // Purkey Title
    int turkeyProc = 24 + sqrt(effective_familiar_weight($familiar[peace turkey]) + weight_adjustment());
    float PeasCount = available_amount($item[whirled peas]) + available_amount($item[handful of split pea soup])*2;
    string [int] description;
    string url = "familiar.php";
    {
        description.listAppend("" + PeasCount/2 + " peabanishers available (paste peas + peas)");
        description.listAppend("percentage is Peace Turkey post-combat activation rate");
        resource_entries.listAppend(ChecklistEntryMake("__familiar peace turkey", url, ChecklistSubentryMake(HTMLGenerateSpanFont("A "+turkeyProc +"% active Peace Turkey", "black"), "", description), -502));
    }
}