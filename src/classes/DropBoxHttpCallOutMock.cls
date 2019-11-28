/**
 * Created by IlarionTokarskyi on 11/28/2019.
 */
@IsTest
public with sharing class DropBoxHttpCallOutMock implements HttpCalloutMock{
    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        return response;
    }
}