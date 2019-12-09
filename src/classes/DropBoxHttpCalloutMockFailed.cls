/**
 * Created by IlarionTokarskyi on 12/9/2019.
 */


public with sharing class DropBoxHttpCalloutMockFailed implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest param1) {
        HttpResponse response = new HttpResponse();
        response.setStatusCode(400);
        response.setStatus('Bad Request');
        return response;
    }
}