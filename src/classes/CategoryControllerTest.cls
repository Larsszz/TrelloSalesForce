/**
 * Created by IlarionTokarskyi on 11/28/2019.
 */
@IsTest
public with sharing class CategoryControllerTest {
    @TestSetup
    static void setup() {
        TestUtilities.setup();
    }

    @IsTest
    static void testDeleteCategory() {
        Category__c category = [SELECT Id FROM Category__c LIMIT 1];

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DropBoxHttpCallOutMock());
        CategoryController.deleteCategoryById(category.Id);
        Test.stopTest();

        List<Category__c> afterTest = [SELECT Id FROM Category__c WHERE Id = :category.Id];
        List<TaskBoard__c> taskBoards = [SELECT Id FROM TaskBoard__c WHERE Category__c = :category.Id];

        System.assertEquals(0, afterTest.size());
        System.assertEquals(0, taskBoards.size());
    }

    @IsTest
    static void testAddTaskByInput() {
        Category__c category = [SELECT Id FROM Category__c LIMIT 1];

        Test.startTest();
        TaskBoard__c taskBoard = CategoryController.addTaskByInput('Test name', 'Test Desc', category.Id);
        Test.stopTest();

        System.assertEquals(5, taskBoard.Position__c);
    }

    @IsTest
    static void testUpdateTaskCategory() {
        Category__c category = [SELECT Id FROM Category__c LIMIT 1];
        TaskBoard__c taskBoard = [SELECT Category__c,Position__c,Name FROM TaskBoard__c WHERE Category__c != :category.Id LIMIT 1];

        Test.startTest();
        CategoryController.updateTaskCategory(taskBoard, category, 2);
        Test.stopTest();

        taskBoard = [SELECT Position__c,Category__c FROM TaskBoard__c WHERE Id = :taskBoard.Id];
        System.assertEquals(category.Id, taskBoard.Category__c);
        System.assertEquals(2, taskBoard.Position__c);
    }

    @IsTest
    static void testDeleteFromModal() {
        TaskBoard__c taskBoard = [SELECT Id FROM TaskBoard__c LIMIT 1];

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DropBoxHttpCallOutMock());
        CategoryController.deleteTaskFromModal(taskBoard);
        Test.stopTest();

        List<TaskBoard__c> listTasks = [SELECT Id FROM TaskBoard__c WHERE Id =: taskBoard.Id];
        System.assertEquals(0,listTasks.size());
    }
}