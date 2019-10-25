/**
 * Created by IlarionTokarskyi on 10/25/2019.
 */

public with sharing class BoardController {
    @AuraEnabled
    public static List<Category__c> getNewBoard(String id) {
        System.debug(id);
        return [
                SELECT Id, Name, (SELECT Name, Description__c FROM TasksBoard__r)
                FROM Category__c
                WHERE Board__c = :id
                ORDER BY CreatedDate ASC
        ];
    }
}