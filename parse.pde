Table data, filtered, parsed;
String domain;
String[] duplicates;

void setup() {
  size(600,600);
  noLoop();
  // setup filtered and parsed tables
  filtered = new Table();
  parsed = new Table();

  // load csv data into data table
  data = loadTable("cleaned-hashicorp_internal_all.csv","header");

  domain = "www.hashicorp.com";

  duplicates = new String[1];
  duplicates[0] = "homepage";

  // println("data Table: " + data.getRowCount());

  for(TableRow row : data.findRows("200", "status")) {
    filtered.addRow(row);
  }

  // println("filtered Table: " + filtered.getRowCount());

  for(TableRow row : data.findRows("200", "status")) {
    // find url
    String rawURL = row.getString("url");
    // remove https:// or http://
    String[] procotolAndUrl = split(rawURL, "://");
    // println(procotolAndUrl);

    String[] domainAndUrl = split(procotolAndUrl[1], domain);
    // println(domainAndUrl);

    String[] sectionAndUrl = split(domainAndUrl[1], "/");
    // println(folderAndUrl);

    // search for "?" or "."
    boolean hasPeriod = doesContain(sectionAndUrl[1], ".");
    boolean hasQuestionmark = doesContain(sectionAndUrl[1], "?");

    if (hasPeriod || hasQuestionmark){
      // println(procotolAndUrl[0] + ", " + domain + ", " + sectionAndUrl[1]);
    } else {

      /*
      for (int i = 0; i < duplicates.length; i++){
        if (duplicates[i] == sectionAndUrl[1]) {
          println(sectionAndUrl[1] + ": duplicate");
        } else {
          println(sectionAndUrl[1] + ": not duplicate");
          // duplicates = splice(duplicates, sectionAndUrl[1], 1);
        }
      }
      */

      TableRow parsedRow = parsed.addRow();
      parsedRow.setString("protocol", procotolAndUrl[0]);
      parsedRow.setString("domain", domain);

      // only add if not duplicate
      parsedRow.setString("section", sectionAndUrl[1]);

    }
  }

  saveTable(parsed, "data/parsed.csv");
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
