/**
 * Created by IlarionTokarskyi on 11/1/2019.
 */

public with sharing class TaskBoardController {
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
        return Select_Utility.getAttachmentsByTaskId(id);
    }

    @AuraEnabled
    public static Attachment__c uploadFile(String fileName, String fileBase64, Id taskId) {
        String path = '/' + taskId + '/' + fileName;
        Blob fileBlob = EncodingUtil.base64Decode(fileBase64.split(',')[1]);
        Integer statusCode = DropBoxController.uploadFile(path, fileBlob);
        if (statusCode == 200) {
            Attachment__c attachment = new Attachment__c(Name = fileName, Link__c = path, TaskBoard__c = taskId);
            insert attachment;
            return attachment;
        }
        return null;
    }

    @AuraEnabled
    public static void deleteFile(Attachment__c attachment) {
        Integer responseCode = DropBoxController.deleteFileOrFolder(attachment.Link__c);
        if (responseCode == 200) {
            delete attachment;
        }
    }

    @AuraEnabled
    public static String downloadFile(Attachment__c attachment) {
        String downloadLink = DropBoxController.downloadFile(attachment.Link__c);
        return downloadLink;
    }

}