/**
 * Created by IlarionTokarskyi on 10/25/2019.
 */

public with sharing class BoardController {
    @AuraEnabled
    public static List<Category__c> getNewBoard(String id) {
        return [
                SELECT Id, Name, Position__c, Board__c, (
                        SELECT Name, Description__c, Position__c
                        FROM TasksBoard__r
                        ORDER BY Position__c
                )
                FROM Category__c
                WHERE Board__c = :id
                ORDER BY Position__c
        ];
    }

    @AuraEnabled
    public static Category__c crateNewCategory(String id, String name) {
        Category__c category = new Category__c(Name = name, Board__c = id);
        List<AggregateResult> results = [SELECT MAX(Position__c) maxx FROM Category__c WHERE Board__c = :id];
        category.Position__c = Integer.valueOf(results[0].get('maxx')) + 1;
        insert category;
        return category;
    }

    @AuraEnabled
    public static void updateCategoriesPosition(Category__c category, Integer position) {
        category.Position__c = position;
        update category;
        List<Category__c> toUpdate = [
                SELECT Position__c
                FROM Category__c
                WHERE Board__c = :category.Board__c AND Id != :category.Id
                ORDER BY Position__c
        ];
        for (Integer i = 0; i < toUpdate.size(); i++) {
            if (toUpdate[i].Position__c < position) {
                toUpdate[i].Position__c = i;
            } else {
                toUpdate[i].Position__c = i + 1;
            }
        }
        update toUpdate;
    }
}