/**
 * Created by IlarionTokarskyi on 11/5/2019.
 */

public with sharing class TaskBoardTriggerHandler {
    public static void isAfterDelete(List<TaskBoard__c> taskBoards) {
        for (TaskBoard__c task: taskBoards) {
            DropBoxController.deleteFileOrFolder('/'+ task.Id);
        }
    }
}