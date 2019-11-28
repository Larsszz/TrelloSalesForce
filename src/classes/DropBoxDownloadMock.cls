/**
 * Created by IlarionTokarskyi on 11/28/2019.
 */

public with sharing class DropBoxDownloadMock implements HttpCalloutMock{
    public HttpResponse respond(HttpRequest param1) {
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setBody('{"url": "https://www.dropbox.com/s/470vsc1j01myos1/234.docx?dl=0", "visibility": {".tag": "public"}, "path": "/a023X00001ovB7qQAE/234.docx"}');
        return response;
    }

}