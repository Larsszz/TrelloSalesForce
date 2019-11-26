/**
 * Created by IlarionTokarskyi on 11/25/2019.
 */

public with sharing class DropBoxController {

    private static final String TOKEN = 'Bearer AHK8IISvWb0AAAAAAAAjY-m4Q7spoJbt33SuMX26S275gp8NUqc-rLPkvDshRgOT';

    public static Integer uploadFile(String path, Blob file) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://content.dropboxapi.com/2/files/upload');
        request.setMethod('POST');
        request.setHeader('Authorization',TOKEN);
        request.setHeader('Content-Type', 'application/octet-stream');
        request.setHeader('Dropbox-API-Arg','{"path":"' + path + '","mode":"add","autorename":true,"mute":false,"strict_conflict":false}');
        request.setBodyAsBlob(file);
        request.setTimeout(120000);

        HttpResponse response = http.send(request);
        return response.getStatusCode();
    }
}