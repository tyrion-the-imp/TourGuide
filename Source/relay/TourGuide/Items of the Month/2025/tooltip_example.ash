	buffer tooltip;
	tooltip.append(HTMLGenerateTagWrap("div", "Well, you asked for it!", mapMake("class", "r_bold r_centre", "style", "padding-bottom:0.25em;")));
	tooltip.append(HTMLGenerateSimpleTableLines(allSkills));
	string tooltipEnumerated = HTMLGenerateSpanOfClass(HTMLGenerateSpanOfClass(tooltip, "r_tooltip_inner_class r_tooltip_inner_class_margin") + "No, TourGuide, show me ALL the skills.", "r_tooltip_outer_class");
	description.listAppend(tooltipEnumerated);

    resource_entries.listAppend(ChecklistEntryMake("__item August Scepter", "skillz.php", ChecklistSubentryMake(title, subtitle, description), -7).ChecklistEntrySetIDTag("August Scepter resource"));
