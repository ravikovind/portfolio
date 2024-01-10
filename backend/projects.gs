function doGet(request){
  // open Google Sheet using ID
  var sheet = SpreadsheetApp.openById("YOUR_SHEET_ID");
  // get all values in active sheet
  var values = sheet.getActiveSheet().getDataRange().getValues();
  var data = [];
  // iterate values in descending order 
  for (var i = values.length - 1; i >= 0; i--) {
    // get each row
    var row = values[i];
    // create object
    var map = {};
    map['name'] = row[0];
    map['description'] = row[1];
    map['web_url'] = row[2];
    map['app_url'] = row[3];
    map['demo_url'] = row[4];
    map['tags'] = row[5];
    // push each row object in data
    data.push(map);
  }

  // console.log(JSON.stringify(data));
  // return result
  return ContentService
  .createTextOutput(JSON.stringify(data))
  .setMimeType(ContentService.MimeType.JSON);
}
