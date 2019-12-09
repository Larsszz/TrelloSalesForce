/**
 * Created by IlarionTokarskyi on 10/28/2019.
 */

public with sharing class CategoryController {
    @AuraEnabled
    public static void deleteCategoryById(String id) {
        Category__c toDelete = SelectUtility.getCategoryByIdForDelete(id);
        List<TaskBoard__c> tasksToDelete = SelectUtility.getTasksByCategoryIdForDelete(id);
        delete toDelete;
        delete tasksToDelete;
    }

    @AuraEnabled
    public static TaskBoard__c addTaskByInput(String name, String description, String idCategory) {
        TaskBoard__c task = new TaskBoard__c(Name = name, Description__c = description, Category__c = idCategory);
        List<AggregateResult> results = SelectUtility.getMaxPositionForTask(idCategory);
        if (results[0].get('maxPosition') == null) {
            task.Position__c = 0;
        } else {
            task.Position__c = Integer.valueOf(results[0].get('maxPosition')) + 1;
        }
        insert task;
        return task;
    }

    @AuraEnabled
    public static void updateTaskCategory(TaskBoard__c task, Category__c category, Integer position) {
        List<TaskBoard__c> toUpdate = SelectUtility.getOrderedTasksByPosition(category.Id, task.Id);
        if (position == toUpdate.size()) {
            toUpdate.add(task);
        } else {
            toUpdate.add(position, task);
        }
        for (Integer i = 0; i < toUpdate.size(); i++) {
            if (toUpdate[i] == task) {
                task.Category__c = category.Id;
                task.Position__c = position;
            } else {
                toUpdate[i].Position__c = i;
            }
        }
        update toUpdate;
    }

    @AuraEnabled
    public static void deleteTaskFromModal(TaskBoard__c taskBoard) {
        delete taskBoard;
    }
}