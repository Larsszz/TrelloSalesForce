/**
 * Created by IlarionTokarskyi on 11/28/2019.
 */
@IsTest
public with sharing class BoardControllerTest {
    @TestSetup
    static void setup() {
        TestUtilities.setup();
    }

    @IsTest
    static void testGetBoard() {
        Test.startTest();
        Board__c board = [SELECT Id FROM Board__c WHERE Name = 'Test Board' LIMIT 1];
        List<Category__c> listCategories = BoardController.getNewBoard(board.Id);
        Test.stopTest();

        for (Category__c category : listCategories) {
            System.assertEquals(board.Id, category.Board__c);
        }
    }

    @IsTest
    static void testCreateNewCategory() {
        Test.startTest();
        Board__c board = [SELECT Id FROM Board__c LIMIT 1];
        Category__c category = BoardController.crateNewCategory(board.Id, 'TestCategory');
        Test.stopTest();

        System.assertEquals(5, category.Position__c);
    }

    @IsTest
    static void testUpdateCatPosition() {
        Category__c beforeTest = [SELECT Name, Position__c, Board__c FROM Category__c WHERE Position__c = 1 LIMIT 1];

        Test.startTest();
        BoardController.updateCategoriesPosition(beforeTest, 3);
        Category__c afterTest = [SELECT Position__c FROM Category__c WHERE Id =: beforeTest.Id LIMIT 1];
        Test.stopTest();

        System.assertEquals(3,afterTest.Position__c);
    }
}