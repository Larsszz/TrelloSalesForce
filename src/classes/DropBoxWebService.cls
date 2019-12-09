/**
 * Created by IlarionTokarskyi on 12/2/2019.
 */

@RestResource(UrlMapping='/DropBox/*')
global with sharing class DropBoxWebService {

    @HttpGet
    global static void DropBoxVerification() {
        String challenge = RestContext.request.params.get('challenge');
        if (String.isNotBlank(challenge)) {
            RestContext.response.addHeader('Content-Type', 'text/plain');
            RestContext.response.responseBody = Blob.valueOf(challenge);
        }
    }

    @HttpPost
    global static void DropBoxNotification() {
        String dropBoxSignature = RestContext.request.headers.get('X-Dropbox-Signature');
        if (String.isNotBlank(dropBoxSignature)) {
            new DropBoxController().changeDataFromDB();
            RestContext.response.statusCode = 200;
        } else {
            RestContext.response.statusCode = 500;
        }
    }
}