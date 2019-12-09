/**
 * Created by IlarionTokarskyi on 11/25/2019.
 */

global with sharing class DropBoxController {

    private static final String TOKEN = SelectUtility.getDropBoxToken();

    public HttpResponse sendPostHttpRequest(String endPoint, Map<String, String> headerMap, Object body) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setMethod('POST');
        request.setHeader('Authorization', TOKEN);
        Set<String> keys = headerMap.keySet();
        for (String key : keys) {
            request.setHeader(key, headerMap.get(key));
        }
        request = setBody(request, body);
        HttpResponse response = new Http().send(request);
        return response;
    }

    private HttpRequest setBody(HttpRequest request, Object body) {
        if (body instanceof String) {
            request.setBody((String) body);
            return request;
        } else if (body instanceof Blob) {
            request.setBodyAsBlob((Blob) body);
            return request;
        } else {
            return request;
        }
    }

    public HttpResponse uploadFile(String path, Blob file) {
        String endPoint = 'https://content.dropboxapi.com/2/files/upload';
        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put('Content-Type', 'application/octet-stream');
        headerMap.put('Dropbox-API-Arg', '{"path":"' + path
                + '","mode":"add","autorename":true,"mute":false,"strict_conflict":false}');
        HttpResponse response = sendPostHttpRequest(endPoint, headerMap, file);
        if (response.getStatus() == 'OK') {
            setNewCursor();
        }
        return response;
    }

    public HttpResponse deleteFileOrFolder(String path) {
        String endpoint = 'https://api.dropboxapi.com/2/files/delete_v2';
        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put('Content-Type', 'application/json');
        String body = '{"path": "' + path + '"}';
        HttpResponse response = sendPostHttpRequest(endpoint, headerMap, body);
        if (response.getStatus() == 'OK') {
            setNewCursor();
        }
        return response;
    }

    public String downloadFile(String path) {
        String endpoint = 'https://api.dropboxapi.com/2/sharing/create_shared_link';
        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put('Content-Type', 'application/json');
        String body = '{"path":"' + path + '","short_url":false}';
        HttpResponse response = sendPostHttpRequest(endpoint, headerMap, body);
        return getLinkFromResponse(response);
    }

    private String getLinkFromResponse(HttpResponse response) {
        if (String.isEmpty(response.getBody())) {
            return null;
        }
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        String link = responseMap.get('url').toString();
        return link;
    }

    public HttpResponse getLatestCursor() {
        String endpoint = 'https://api.dropboxapi.com/2/files/list_folder/get_latest_cursor';
        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put('Content-Type', 'application/json');
        String body = '{"path": "", "recursive": true}';
        return sendPostHttpRequest(endpoint, headerMap, body);
    }

    public String getCursor(HttpResponse response) {
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        String cursor = responseMap.get('cursor').toString();
        return cursor;
    }

    global void changeDataFromDB() {
        String endpoint = 'https://api.dropboxapi.com/2/files/list_folder/continue';
        String cursor = SelectUtility.getCursor().Data__c;
        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put('Content-Type', 'application/json');
        String body = '{"cursor": "' + cursor + '"}';
        HttpResponse response = sendPostHttpRequest(endpoint, headerMap, body);
        if (response.getStatus() == 'OK') {
            System.debug(response.getBody());
            new WebHookDBHandler(response);
            cursor = getCursor(response);
            changeCursor(cursor);
        }
    }

    public void setNewCursor() {
        HttpResponse response = getLatestCursor();
        String cursor = getCursor(response);
        changeCursor(cursor);
    }

    public void changeCursor(String cursor) {
        Cursor__c oldCursor = SelectUtility.getCursor();
        oldCursor.Data__c = cursor;
        update oldCursor;
    }
}