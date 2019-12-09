/**
 * Created by IlarionTokarskyi on 12/9/2019.
 */

public with sharing class DropBoxDownloadMockFail implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest param1) {
        HttpResponse response = new HttpResponse();
        response.setStatus('Bad Request');
        response.setStatusCode(400);
        response.setBody('');
        return response;
    }
}