// wrap string in h3 tags
String h3(String headerString) {
  return "<h3>" + headerString + "</h3>";
}

// wrap string in p tags
String p(String pText) {
  return "<p>" + pText + "</p>";
}

// Render a StringDict as a table
String table(StringDict table) {
  String htmlString = "No values";

  if (table.keyArray().length > 0) {
    htmlString =  "<table border=1>";

    for (String paramKey : table.keys ())
      htmlString += "<tr><td>" + paramKey + "</td><td>" + table.get(paramKey) + "</td></tr>";

    htmlString += "</table>";
  }
  return htmlString;
}

// render a stringdict as a form with text inputs
String form(StringDict params) {
  String htmlString = "No Values";

  if (params.keyArray().length > 0) {
    htmlString = "<form action=\"/\" method=\"GET\"><table>";
    for (String paramKey : params.keys ()) {
      htmlString += "<tr><td>" 
        + paramKey           
        + "</td><td>"
        + "<input name=\""+paramKey+"\" type=\"text\"/>"
        +"</td></tr>";
    }
    htmlString += "<input type=\"submit\" value=\"submit\"/></form></table>";
  }
  
  return htmlString;
}

