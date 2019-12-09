/**
 * Created by IlarionTokarskyi on 11/1/2019.
 */

public with sharing class TaskBoardController {

    private static DropBoxController dbController = new DropBoxController();

    @AuraEnabled
    public static TaskBoard__c editTaskBoard(TaskBoard__c taskBoard, String newName, String newDescription, String[] newPriorities) {
        taskBoard.Name = newName;
        taskBoard.Description__c = newDescription;
        taskBoard.Priority__c = '';
        if (newPriorities != null) {
            for (Integer i = 0; i < newPriorities.size(); i++) {
                taskBoard.Priority__c += newPriorities[i] + ';';
            }
        }
        taskBoard.Priority__c = taskBoard.Priority__c.removeEnd(';');
        update taskBoard;
        return taskBoard;
    }

    @AuraEnabled
    public static List<Attachment__c> getAttachmentsForTask(Id id) {
        return SelectUtility.getAttachmentsByTaskId(id);
    }

    @AuraEnabled
    public static Attachment__c uploadFile(String fileName, String fileBase64, Id taskId) {
        String path = '/' + taskId + '/' + fileName;
        Blob fileBlob = EncodingUtil.base64Decode(fileBase64.split(',')[1]);
        HttpResponse response = dbController.uploadFile(path, fileBlob);
        if (response.getStatus() == 'OK') {
            Attachment__c attachment = new Attachment__c(Name = fileName, Link__c = path, TaskBoard__c = taskId);
            insert attachment;
            return attachment;
        } else {
            throw new DropBoxException('Failed upload file with status ' + response.getStatus());
        }
    }

    @AuraEnabled
    public static void deleteFile(Attachment__c attachment) {
        HttpResponse response = dbController.deleteFileOrFolder(attachment.Link__c);
        if (response.getStatus() == 'OK') {
            delete attachment;
        } else {
            throw new DropBoxException('Failed delete file with status ' + response.getStatus());
        }
    }

    @AuraEnabled
    public static String downloadFile(Attachment__c attachment) {
        String downloadLink = dbController.downloadFile(attachment.Link__c);
        if (downloadLink == null) {
            throw new DropBoxException('Failed open file');
        }
        return downloadLink;
    }

}