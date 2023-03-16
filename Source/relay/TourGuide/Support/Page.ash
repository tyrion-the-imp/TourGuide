import "relay/TourGuide/Support/HTML.ash"
import "relay/TourGuide/Settings.ash"

record CSSEntry
{
    string tag;
    string class_name;
    string definition;
    int importance;
};

CSSEntry CSSEntryMake(string tag, string class_name, string definition, int importance)
{
    CSSEntry entry;
    entry.tag = tag;
    entry.class_name = class_name;
    entry.definition = definition;
    entry.importance = importance;
    return entry;
}

record CSSBlock
{
    CSSEntry [int] defined_css_classes;
    string identifier;
};

CSSBlock CSSBlockMake(string identifier)
{
    CSSBlock result;
    result.identifier = identifier;
    return result;
}

buffer CSSBlockGenerate(CSSBlock block)
{
    buffer result;
    
    if (block.defined_css_classes.count() > 0)
    {
        boolean output_identifier = (block.identifier != "");
        if (output_identifier)
        {
            result.append("\t\t\t");
            result.append(block.identifier);
            result.append(" {\n");
        }
        sort block.defined_css_classes by value.importance;
    
        foreach key in block.defined_css_classes
        {
            CSSEntry entry = block.defined_css_classes[key];
            result.append("\t\t\t");
            if (output_identifier)
                result.append("\t");
        
            if (entry.class_name == "")
                result.append(entry.tag + " { " + entry.definition + " }");
            else
            {
                result.append(entry.tag + ( entry.class_name.char_at(0) != "#" && entry.class_name.char_at(0) != "." ? "." : "") + entry.class_name + " { " + entry.definition + " }");
            }
            result.append("\n");
        }
        if (output_identifier)
            result.append("\n\t\t\t}\n");
    }
    return result;
}

void listAppend(CSSEntry [int] list, CSSEntry entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

record Page
{
	string title;
	buffer head_contents;
	buffer body_contents;
	string [string] body_attributes; //[attribute_name] -> attribute_value
	
    CSSBlock [string] defined_css_blocks; //There is always an implicit "" block.
};


Page __global_page;



Page Page()
{
	return __global_page;
}

buffer PageGenerateBodyContents(Page page_in)
{
    return page_in.body_contents;
}

buffer PageGenerateBodyContents()
{
    return Page().PageGenerateBodyContents();
}

buffer PageGenerateStyle(Page page_in)
{
    buffer result;
    
    if (page_in.defined_css_blocks.count() > 0)
    {
        if (true)
        {
            result.append("\t\t");
            result.append(HTMLGenerateTagPrefix("style", mapMake("type", "text/css")));
            result.append("\n");
        }
        result.append(page_in.defined_css_blocks[""].CSSBlockGenerate()); //write first
        foreach identifier in page_in.defined_css_blocks
        {
            CSSBlock block = page_in.defined_css_blocks[identifier];
            if (identifier == "") //skip, already written
                continue;
            result.append(block.CSSBlockGenerate());
        }
        if (true)
        {
            result.append("\t\t</style>\n");
        }
    }
    return result;
}

buffer PageGenerateStyle()
{
    return Page().PageGenerateStyle();
}

buffer PageGenerate(Page page_in)
{
	buffer result;
	
	result.append("<!DOCTYPE html>\n"); //HTML 5 target
	result.append("<html>\n");
	
	//Head:
	result.append("\t<head>\n");
	result.append("\t\t<title>");
	result.append(page_in.title);
	result.append("</title>\n");
	if (page_in.head_contents.length() != 0)
	{
        result.append("\t\t");
		result.append(page_in.head_contents);
		result.append("\n");
	}
	//Write CSS styles:
    result.append(PageGenerateStyle(page_in));
    result.append("\t</head>\n");
	
	//Body:
	result.append("\t");
	result.append(HTMLGenerateTagPrefix("body", page_in.body_attributes));
	result.append("\n\t\t");
	result.append(page_in.body_contents);
	result.append("\n");
		
	result.append("\t</body>\n");
	

	result.append("</html>");
	
	return result;
}

void PageGenerateAndWriteOut(Page page_in)
{
	write(PageGenerate(page_in));
}

void PageSetTitle(Page page_in, string title)
{
	page_in.title = title;
}

void PageAddCSSClass(Page page_in, string tag, string class_name, string definition, int importance, string block_identifier)
{
    //print_html("Adding block_identifier \"" + block_identifier + "\"");
    if (!(page_in.defined_css_blocks contains block_identifier))
        page_in.defined_css_blocks[block_identifier] = CSSBlockMake(block_identifier);
    page_in.defined_css_blocks[block_identifier].defined_css_classes.listAppend(CSSEntryMake(tag, class_name, definition, importance));
}

void PageAddCSSClass(Page page_in, string tag, string class_name, string definition, int importance)
{
    PageAddCSSClass(page_in, tag, class_name, definition, importance, "");
}

void PageAddCSSClass(Page page_in, string tag, string class_name, string definition)
{
    PageAddCSSClass(page_in, tag, class_name, definition, 0);
}


void PageWriteHead(Page page_in, string contents)
{
	page_in.head_contents.append(contents);
}

void PageWriteHead(Page page_in, buffer contents)
{
	page_in.head_contents.append(contents);
}


void PageWrite(Page page_in, string contents)
{
	page_in.body_contents.append(contents);
}

void PageWrite(Page page_in, buffer contents)
{
	page_in.body_contents.append(contents);
}

void PageSetBodyAttribute(Page page_in, string attribute, string value)
{
	page_in.body_attributes[attribute] = value;
}


//Global:

buffer PageGenerate()
{
	return PageGenerate(Page());
}

void PageGenerateAndWriteOut()
{
	write(PageGenerate());
}

void PageSetTitle(string title)
{
	PageSetTitle(Page(), title);
}

void PageAddCSSClass(string tag, string class_name, string definition)
{
	PageAddCSSClass(Page(), tag, class_name, definition);
}

void PageAddCSSClass(string tag, string class_name, string definition, int importance)
{
	PageAddCSSClass(Page(), tag, class_name, definition, importance);
}

void PageAddCSSClass(string tag, string class_name, string definition, int importance, string block_identifier)
{
	PageAddCSSClass(Page(), tag, class_name, definition, importance, block_identifier);
}

void PageWriteHead(string contents)
{
	PageWriteHead(Page(), contents);
}

void PageWriteHead(buffer contents)
{
	PageWriteHead(Page(), contents);
}

//Writes to body:

void PageWrite(string contents)
{
	PageWrite(Page(), contents);
}

void PageWrite(buffer contents)
{
	PageWrite(Page(), contents);
}

void PageSetBodyAttribute(string attribute, string value)
{
	PageSetBodyAttribute(Page(), attribute, value);
}


void PageInit()
{
	PageAddCSSClass("a", "r_a_undecorated", "text-decoration:none;color:inherit;");
	PageAddCSSClass("", "r_centre", "margin-left:auto; margin-right:auto;text-align:center;");
	PageAddCSSClass("", "r_bold", "font-weight:bold;");
	PageAddCSSClass("", "r_end_floating_elements", "clear:both;");

	PageAddCSSClass("", "r_element_important", "color: red;");
	
	PageAddCSSClass("", "r_element_good", "color: rgb(0, 128, 0);");
	PageAddCSSClass("", "r_element_awesome", "color: rgb(0, 0, 255);");
	PageAddCSSClass("", "r_element_epic", "color: rgb(138, 43, 226);");

	PageAddCSSClass("", "r_element_stench", "color:green;");
	PageAddCSSClass("", "r_element_hot", "color:red;");
	PageAddCSSClass("", "r_element_cold", "color:blue;");
	PageAddCSSClass("", "r_element_sleaze", "color:purple;");
	PageAddCSSClass("", "r_element_spooky", "color:gray;");
	
	
	PageAddCSSClass("", "r_fuchsia", "color:fuchsia;");
    
    //50% desaturated versions of above:
	PageAddCSSClass("", "r_element_stench_desaturated", "color:#427F40;");
	PageAddCSSClass("", "r_element_hot_desaturated", "color:#FF7F81;");
	PageAddCSSClass("", "r_element_cold_desaturated", "color:#6B64FF;");
	PageAddCSSClass("", "r_element_sleaze_desaturated", "color:#7F407F;");
	PageAddCSSClass("", "r_element_spooky_desaturated", "color:gray;");
	
	PageAddCSSClass("", "r_indention", "margin-left:" + __setting_indention_width + ";");
	
	//Simple table lines:
	PageAddCSSClass("div", "r_stl_container", "display:table;");
	PageAddCSSClass("div", "r_stl_container_row", "display:table-row;");
    PageAddCSSClass("div", "r_stl_entry", "padding:0px;margin:0px;display:table-cell;");
    PageAddCSSClass("div", "r_stl_spacer", "width:1em;");
}



string HTMLGenerateIndentedText(string text, string width)
{
	return HTMLGenerateDivOfClass(text, "r_indention");
}

string HTMLGenerateIndentedText(string [int] text)
{

	buffer building_text;
	foreach key in text
	{
		string line = text[key];
		building_text.append(HTMLGenerateDiv(line));
	}
	
	return HTMLGenerateIndentedText(to_string(building_text), __setting_indention_width);
}

string HTMLGenerateIndentedText(string text)
{
	return HTMLGenerateIndentedText(text, __setting_indention_width);
}


string HTMLGenerateSimpleTableLines(string [int][int] lines, boolean dividers_are_visible)
{
	buffer result;
	
	int max_columns = 0;
	foreach i in lines
	{
		max_columns = max(max_columns, lines[i].count());
	}
	
    //div-based layout:
    int intra_i = 0;
    int last_cell_count = 0;
    result.append(HTMLGenerateTagPrefix("div", mapMake("class", "r_stl_container")));
    foreach i in lines
    {
        if (intra_i > 0)
        {
            result.append(HTMLGenerateTagPrefix("div", mapMake("class", "r_stl_container_row")));
            for i from 1 to last_cell_count //no colspan with display:table, generate extra (zero-padding, zero-margin) cells:
            {
                string separator = "";
                if (dividers_are_visible)
                    separator = "<hr>";
                else
                    separator = "<hr style=\"opacity:0\">"; //laziness - generate an invisible HR, so there's still spacing
                result.append(HTMLGenerateDivOfClass(separator, "r_stl_entry"));
            }
            result.append("</div>");
            last_cell_count = 0;
        }
        result.append(HTMLGenerateTagPrefix("div", mapMake("class", "r_stl_container_row")));
        int intra_j = 0;
        foreach j in lines[i]
        {
            string entry = lines[i][j];
            if (intra_j > 0)
            {
                result.append(HTMLGenerateDivOfClass("", "r_stl_entry r_stl_spacer"));
                last_cell_count += 1;
            }
            result.append(HTMLGenerateDivOfClass(entry, "r_stl_entry"));
            last_cell_count += 1;
            
            intra_j += 1;
        }
        
        result.append("</div>");
        intra_i += 1;
    }
    result.append("</div>");
	return result.to_string();
}

string HTMLGenerateSimpleTableLines(string [int][int] lines)
{
    return HTMLGenerateSimpleTableLines(lines, true);
}

string HTMLGenerateElementSpan(element e, string additional_text, boolean desaturated)
{
    string line = e;
    if (additional_text != "")
        line += " " + additional_text;
    return HTMLGenerateSpanOfClass(line, "r_element_" + e + (desaturated ? "_desaturated" : ""));
}

string HTMLGenerateElementSpan(element e, string additional_text)
{
    return HTMLGenerateElementSpan(e, additional_text, false);
}
string HTMLGenerateElementSpanDesaturated(element e, string additional_text)
{
    return HTMLGenerateElementSpan(e, additional_text, true);
}
string HTMLGenerateElementSpanDesaturated(element e)
{
    return HTMLGenerateElementSpanDesaturated(e, "");
}
