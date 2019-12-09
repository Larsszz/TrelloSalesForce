/**
 * Created by IlarionTokarskyi on 11/28/2019.
 */

public with sharing class SelectUtility {
    public static List<Category__c> getBoardCategories(String id) {
        return [
                SELECT Id,
                        Name,
                        Position__c,
                        Board__c, (
                        SELECT Name,
                                Description__c,
                                Position__c,
                                Priority__c
                        FROM TasksBoard__r
                        ORDER BY Position__c
                )
                FROM Category__c
                WHERE Board__c = :id
                ORDER BY Position__c
        ];
    }

    public static List<AggregateResult> getMaxPositionForCategory(String boardId) {
        return [
                SELECT MAX(Position__c) maxPosition
                FROM Category__c
                WHERE Board__c = :boardId
        ];
    }

    public static List<AggregateResult> getMaxPositionForTask(String categoryId) {
        return [
                SELECT MAX(Position__c) maxPosition
                FROM TaskBoard__c
                WHERE Category__c = :categoryId
        ];
    }

    public static List<Category__c> getOrderedCategoriesByPosition(Category__c category) {
        return [
                SELECT Position__c
                FROM Category__c
                WHERE Board__c = :category.Board__c
                AND Id != :category.Id
                ORDER BY Position__c
        ];
    }

    public static List<TaskBoard__c> getOrderedTasksByPosition(String categoryId, String taskId) {
        return [
                SELECT Id, Position__c
                FROM TaskBoard__c
                WHERE Category__c = :categoryId AND Id != :taskId
                ORDER BY Position__c
        ];
    }

    public static Category__c getCategoryByIdForDelete(String id) {
        return [
                SELECT Id,
                        Name
                FROM Category__c
                WHERE Id = :id
                LIMIT 1
        ];
    }

    public static List<TaskBoard__c> getTasksByCategoryIdForDelete(String id) {
        return [
                SELECT Id
                FROM TaskBoard__c
                WHERE Category__c = :id
        ];
    }
    public static List<Attachment__c> getAttachmentsByTaskId(Id taskId) {
        return [SELECT Name, Link__c, TaskBoard__c FROM Attachment__c WHERE TaskBoard__c = :taskId];
    }

    public static Cursor__c getCursor() {
        return [SELECT Data__c FROM Cursor__c WHERE Name = 'First' LIMIT 1];
    }

    public static List<Attachment__c> getAttachmentsByLinks(List<String> links) {
        return [SELECT Name, Link__c, TaskBoard__c FROM Attachment__c WHERE Link__c IN :links];
    }

    public static String getDropBoxToken() {
        return [SELECT Token__c FROM DropBox_Token__mdt WHERE Label = 'Drop Box Token'].Token__c;
    }
}