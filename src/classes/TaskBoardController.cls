/**
 * Created by IlarionTokarskyi on 11/1/2019.
 */

public with sharing class TaskBoardController {
    @AuraEnabled
    public static void updateTaskName(TaskBoard__c task, String name) {
            task.Name = name;
            update task;
    }

    @AuraEnabled
    public static void updateTaskDescription(TaskBoard__c task, String description) {
        task.Description__c = description;
        update task;
    }
}