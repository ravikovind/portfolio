function doPost(request) {
  // Open Google Sheet using ID
  var sheet = SpreadsheetApp.openById("YOUR_SHEET_ID");
  var result = { "status": "SUCCESS" };
  try {
    // Get all Parameters
    var name = request.parameter.name;
    var email = request.parameter.email;
    var message = request.parameter.message;
    var date_time = request.parameter.date_time;
    // Append data on Google Sheet
    var rowData = sheet.appendRow([name, email, message, date_time]);
    // email == 'email' means some one Anonymus is visiting web.
    if (email != "email") {
      var htmlTemplate = HtmlService.createTemplateFromFile("thanks.html");
      var htmlBody = htmlTemplate.evaluate().getContent();
      var message = {
        to: email,
        subject: "Thanks for being awesome!",
        body: ">Thank you for visiting.",
        bcc: "ravikumar2710999@gmail.com",
        replyTo: "ravikumar2710999@gmail.com",
        name: name,
        htmlBody: htmlBody
      }
      MailApp.sendEmail(message);
    }

  } catch (e) {
    // If error occurs, throw exception
    result = { "status": "FAILED" };
  }
  // Return result
  return ContentService
    .createTextOutput(JSON.stringify(result))
    .setMimeType(ContentService.MimeType.JSON);
}