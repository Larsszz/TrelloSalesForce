/**
 * Created by IlarionTokarskyi on 11/28/2019.
 */
@IsTest
public with sharing class TaskBoardControllerTest {
    @TestSetup
    static void setup() {
        TestUtilities.setup();
    }

    @IsTest
    static void testEditTaskBoard() {
        TaskBoard__c taskBoard = [SELECT Name, Description__c, Priority__c FROM TaskBoard__c LIMIT 1];

        Test.startTest();
        List<String> strings = new List<String>();
        strings.add('OS Task');
        strings.add('Urgent');
        taskBoard = TaskBoardController.editTaskBoard(taskBoard, 'new Name', 'new Description', strings);
        Test.stopTest();

        System.assertEquals('new Name', taskBoard.Name);
        System.assertEquals('new Description', taskBoard.Description__c);
        System.assertEquals('OS Task;Urgent', taskBoard.Priority__c);
    }

    @IsTest
    static void testGetAttachments() {
        TaskBoard__c taskBoard = [SELECT Id FROM TaskBoard__c LIMIT 1];
        List<Attachment__c> attachments = [SELECT Name, Link__c, TaskBoard__c FROM Attachment__c WHERE TaskBoard__c = :taskBoard.Id];

        Test.startTest();
        List<Attachment__c> attachments2 = TaskBoardController.getAttachmentsForTask(taskBoard.Id);
        Test.stopTest();

        System.assertEquals(attachments, attachments2);
    }

    @IsTest
    static void testUploadFile() {
        TaskBoard__c taskBoard = [SELECT Id, Name FROM TaskBoard__c LIMIT 1];

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DropBoxHttpCallOutMock());
        Attachment__c attachment = TaskBoardController.uploadFile('test.txt', ',cmVyZ2VnZWdlcmdlcmdncg==', taskBoard.Id);
        Test.stopTest();

        List<Attachment__c> attachments = [SELECT Name, Link__c, TaskBoard__c FROM Attachment__c WHERE TaskBoard__c =: taskBoard.Id];
        System.assertEquals(true,attachments.contains(attachment));
    }

    @IsTest
    static void testDownloadFile() {
        String fileLink = 'https://www.dropbox.com/s/470vsc1j01myos1/234.docx?dl=0';
        Attachment__c attachment = [SELECT Link__c FROM Attachment__c LIMIT 1];

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DropBoxDownloadMock());
        String linkFromController = TaskBoardController.downloadFile(attachment);
        Test.stopTest();

        System.assertEquals(fileLink, linkFromController);
    }

    @IsTest
    static void testDeleteFile() {
        TaskBoard__c taskBoard = [SELECT Id FROM TaskBoard__c LIMIT 1];

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DropBoxHttpCallOutMock());
        TaskBoardController.deleteFile([SELECT Link__c FROM Attachment__c WHERE TaskBoard__c =: taskBoard.Id]);
        Test.stopTest();

        List<Attachment__c> attachments = [SELECT Id FROM Attachment__c WHERE TaskBoard__c =: taskBoard.Id];
        System.assertEquals(0,attachments.size());
    }

}