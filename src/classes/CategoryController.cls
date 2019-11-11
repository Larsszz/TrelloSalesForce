/**
 * Created by IlarionTokarskyi on 10/28/2019.
 */

public with sharing class CategoryController {
    @AuraEnabled
    public static void deleteCategoryById(String id) {
        Category__c toDelete = [
                SELECT Id,
                        Name
                FROM Category__c
                WHERE Id = :id
        ];
        List<TaskBoard__c> tasksToDelete = [
                SELECT Id
                FROM TaskBoard__c
                WHERE Category__c = :id
        ];
        delete toDelete;
        delete tasksToDelete;
    }

    @AuraEnabled
    public static TaskBoard__c addTaskByInput(String name, String description, String idCategory) {
        TaskBoard__c task = new TaskBoard__c(Name = name, Description__c = description, Category__c = idCategory);
        List<AggregateResult> results = [
                SELECT MAX(Position__c) maxx
                FROM TaskBoard__c
                WHERE Category__c = :idCategory
        ];
        if (results[0].get('maxx') == null) {
            task.Position__c = 0;
        } else {
            task.Position__c = Integer.valueOf(results[0].get('maxx')) + 1;
        }
        insert task;
        return task;
    }

    @AuraEnabled
    public static void updateTaskCategory(TaskBoard__c task, Category__c category, Integer position) {
        task.Category__c = category.Id;
        task.Position__c = position;
        update task;
        List<TaskBoard__c> toUpdate = [
                SELECT Id, Position__c
                FROM TaskBoard__c
                WHERE Category__c = :category.Id AND Id != :task.Id
                ORDER BY Position__c
        ];
        toUpdate = BoardUtilities.updateObjectsInListPosition(toUpdate, position);
//        for (Integer i = 0; i < toUpdate.size(); i++) {
//            if (toUpdate[i].Position__c < position) {
//                toUpdate[i].Position__c = i;
//            } else {
//                toUpdate[i].Position__c = i + 1;
//            }
//        }
        update toUpdate;
    }

    @AuraEnabled
    public static void deleteTaskFromModal(TaskBoard__c taskBoard) {
        delete taskBoard;
    }
}