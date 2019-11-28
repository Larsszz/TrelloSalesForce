/**
 * Created by IlarionTokarskyi on 11/5/2019.
 */

public with sharing class TaskBoardTriggerHandler {
    public static void isAfterDelete(List<TaskBoard__c> taskBoards) {
        for (TaskBoard__c task: taskBoards) {
            TaskBoardTriggerHandler.callOut('/'+ task.Id);
        }
    }

    @Future(Callout=true)
    private static void callOut(String path){
        DropBoxController.deleteFileOrFolder(path);
    }
}