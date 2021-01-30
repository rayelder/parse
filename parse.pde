Table data, filtered, parsed, sections;
String filename, domain;

void setup() {
  size(600,600);
  noLoop();
  // setup filtered and parsed tables
  filtered = new Table();
  parsed = new Table();
  sections = new Table();
  sections.addColumn("section");
  sections.addColumn("count");

  // 1. update CSV file
  filename = "cloud-hashicorp-com";
  
  // 2. update domain
  domain = "cloud.hashicorp.com";
  
  // load csv data into data table
  data = loadTable(filename + "-internal_html.csv", "header");
  

  // println("data Table: " + data.getRowCount());

  for(TableRow row : data.findRows("200", "Status")) {
    filtered.addRow(row);
  }

  // println("filtered Table: " + filtered.getRowCount());

  for(TableRow row : data.findRows("Status", 200)) {
    // find url
    String rawURL = row.getString("Address");
    println("HI");
    println(rawURL);
    
    // remove https:// or http://
    String[] procotolAndUrl = split(rawURL, "://");
    String[] domainAndUrl = split(procotolAndUrl[1], domain);
    String[] sectionAndUrl = split(domainAndUrl[1], "/");
     //println(folderAndUrl);

    // search for "?" or "."
    boolean hasPeriod = doesContain(sectionAndUrl[1], ".");
    boolean hasQuestionmark = doesContain(sectionAndUrl[1], "?");

    if (hasPeriod || hasQuestionmark){
      // println(procotolAndUrl[0] + ", " + domain + ", " + sectionAndUrl[1]);
    } else {
      TableRow parsedRow = parsed.addRow();
      parsedRow.setString("protocol", procotolAndUrl[0]);
      parsedRow.setString("domain", domain);
      parsedRow.setString("section", sectionAndUrl[1]);
    }
  }

  for(TableRow row : parsed.rows()) {
    String section = row.getString("section");
    // println("section is " + section);

    TableRow duplicateRow = sections.findRow(section, "section");

    if (duplicateRow == null) {
      // println("null");
      TableRow sectionRow = sections.addRow();
      sectionRow.setString("section", section);
      sectionRow.setString("count", "1");
    } else {
      // println("not null");
      String duplicateSection = duplicateRow.getString("section");
      TableRow currentSection = sections.findRow(duplicateSection, "section");
      String currentCount = currentSection.getString("count");
      int newCount = int(currentCount) + 1;
      currentSection.setString("count", str(newCount));
    }
  }
   saveTable(parsed, "data/parsed.csv");
  //saveTable(sections, "data/" + filename + "-folders.csv");
}

void draw() {
  background(255);
}

/* FUNCTIONS */

boolean doesContain(String str, String c) {
  boolean found = true;
  int index = str.indexOf(c);
  if (index < 0) {
    found = false;
  }
  return found;
}
