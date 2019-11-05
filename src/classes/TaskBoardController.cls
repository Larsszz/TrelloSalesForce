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

    @AuraEnabled
    public static TaskBoard__c addPriorityToTask(TaskBoard__c task, String priority) {
        if (task.Priority__c == null) {
            task.Priority__c = priority + ';';
            update task;
        } else {
            task.Priority__c += ';' + priority;
            update task;
        }
        return task;
    }

    @AuraEnabled
    public static TaskBoard__c deletePriorityFromTask(TaskBoard__c task, String priority) {
        List<String> oldPriorities = task.Priority__c.split(';');
        oldPriorities.remove(oldPriorities.indexOf(priority));
        task.Priority__c = '';
        for (String str: oldPriorities) {
            task.Priority__c += str + ';';

        }
        task.Priority__c = task.Priority__c.removeEnd(';');
        update task;
        return task;
    }
}