/**
 * Created by IlarionTokarskyi on 12/9/2019.
 */

@IsTest
private class DropBoxWebServiceTest {
    @TestSetup
    static void setup() {
        TestUtilities.setup();
    }

    public class WebHookDBMock implements HttpCalloutMock {

        public HttpResponse respond(HttpRequest param1) {
            HttpResponse response = new HttpResponse();
            response.setStatus('OK');
            response.setStatusCode(200);
            response.setBody('{"entries": [{".tag": "file", "name": "package.xml", "path_lower": "/a023x00001ovkw3qam/package.xml", "path_display": "/a023X00001ovKW3QAM/package.xml", "id": "id:p38ITQTxqPAAAAAAAAAAXw", "client_modified": "2019-12-09T15:26:56Z", "server_modified": "2019-12-09T15:26:56Z", "rev": "015994706a68584000000018f6f1770", "size": 1268, "is_downloadable": true, "content_hash": "7e83f73ec0155d05f478b185e250116b1046324ecc5a38b3014c61843d417306"},{".tag": "deleted", "name": "234.docx", "path_lower": "/a023x00001ovkw3qam/234.docx", "path_display": "/a023X00001ovKW3QAM/234.docx"}], "cursor": "AAF-AQqEra7_Ghv1a12DTK7Q8mNU9Mq0jI5uK1Pyuahqw_7IqePR3Cw2DkXrrPo0s1QiDuEWQuAVEaK9xBBjBtduVli4cJG89WGwG9lvukVwTRF8EbAIz-YnKIAPNIMAD_m3TXokNPBdQx6JFfVvt_nfyzsNpvr6EZ-ByXsVXMBYVQ", "has_more": false}');
            return response;
        }

    }

    @IsTest
    static void testValidation() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Dropbox/';
        req.httpMethod = 'GET';
        req.addParameter('challenge','123abc');

        RestContext.request = req;
        RestContext.response= res;

        Test.startTest();
        DropBoxWebService.DropBoxVerification();
        System.debug(res);
        Test.stopTest();
        System.assertNotEquals(res,null);

    }

    @IsTest
    static void testUpdateOrg() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Dropbox/';
        req.httpMethod = 'POST';
        req.addHeader('X-Dropbox-Signature','test');

        RestContext.request = req;
        RestContext.response= res;

        Test.setMock(HttpCalloutMock.class, new WebHookDBMock());
        Test.startTest();
        DropBoxWebService.DropBoxNotification();
        Test.stopTest();
        System.assertEquals(200, res.statusCode);
    }

    @IsTest
    static void testFiledUpdateOrg() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Dropbox/';
        req.httpMethod = 'POST';
        req.addHeader('X-Dropbox','test');

        RestContext.request = req;
        RestContext.response= res;

        Test.setMock(HttpCalloutMock.class, new WebHookDBMock());
        Test.startTest();
        DropBoxWebService.DropBoxNotification();
        Test.stopTest();
        System.assertEquals(500, res.statusCode);
    }

}