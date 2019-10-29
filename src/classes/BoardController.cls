/**
 * Created by IlarionTokarskyi on 10/25/2019.
 */

public with sharing class BoardController {
    @AuraEnabled
    public static List<Category__c> getNewBoard(String id) {
        return [
                SELECT Id, Name, (SELECT Name, Description__c, Position__c FROM TasksBoard__r ORDER BY Position__c)
                FROM Category__c
                WHERE Board__c = :id
                ORDER BY CreatedDate
        ];
    }

    @AuraEnabled
    public static Category__c crateNewCategory(String id, String name) {
        Category__c category = new Category__c(Name = name, Board__c = id);
        insert category;
        return category;
    }
}