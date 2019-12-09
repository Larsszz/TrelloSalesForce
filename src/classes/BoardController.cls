/**
 * Created by IlarionTokarskyi on 10/25/2019.
 */

public with sharing class BoardController {
    @AuraEnabled
    public static List<Category__c> getNewBoard(String id) {
        return SelectUtility.getBoardCategories(id);
    }

    @AuraEnabled
    public static Category__c crateNewCategory(String id, String name) {
        Category__c category = new Category__c(Name = name, Board__c = id);
        List<AggregateResult> results = SelectUtility.getMaxPositionForCategory(category.Board__c);
        try {
            category.Position__c = Integer.valueOf(results[0].get('maxPosition')) + 1;
        } catch (Exception ex) {
            category.Position__c = 0;
        }
        insert category;
        return category;
    }

    @AuraEnabled
    public static void updateCategoriesPosition(Category__c category, Integer position) {
        List<Category__c> toUpdate = SelectUtility.getOrderedCategoriesByPosition(category);
        if (position == toUpdate.size()) {
            toUpdate.add(category);
        } else {
            toUpdate.add(position, category);
        }
        for (Integer i = 0; i < toUpdate.size(); i++) {
            if (toUpdate[i] == category) {
                category.Position__c = position;
            } else {
                toUpdate[i].Position__c = i;
            }
        }
        update toUpdate;
    }
}