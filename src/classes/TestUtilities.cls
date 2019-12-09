/**
 * Created by IlarionTokarskyi on 11/28/2019.
 */

public with sharing class TestUtilities {
    public static void setup() {
        Board__c board = new Board__c(Name = 'Test Board');
        Cursor__c cursor = new Cursor__c(Name = 'First', Data__c = 'ergegrgege');
        insert cursor;
        insert board;
        List<Category__c> categories = new List<Category__c>();
        List<TaskBoard__c> taskBoards = new List<TaskBoard__c>();
        List<Attachment__c> attachments = new List<Attachment__c>();
        for (Integer i = 0; i < 5; i++) {
            categories.add(new Category__c(Name = 'Test category ' + i, Board__c = board.Id, Position__c = i));
        }
        insert categories;
        for (Category__c category : categories) {
            for (Integer i = 0; i < 5; i++) {
                taskBoards.add(new TaskBoard__c(Name = 'Test Task ' + i, Category__c = category.Id, Position__c = i));
            }
        }
        insert taskBoards;
        for (TaskBoard__c task : taskBoards) {
            attachments.add(new Attachment__c(Name = 'Test attachment' + task.Name, Link__c = 'link/' + task.Name, TaskBoard__c = task.Id));
        }
        insert attachments;
    }
}