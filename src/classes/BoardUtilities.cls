/**
 * Created by IlarionTokarskyi on 11/11/2019.
 */

public with sharing class BoardUtilities {
    public static List<SObject> updateObjectsInListPosition(List<SObject> objects, Integer position) {
        if (objects.isEmpty()) {
            return null;
        }
        for (Integer i = 0; i < objects.size(); i++) {
            if ((Decimal) objects[i].get('Position__c') < position) {
                objects[i].put('Position__c', i);
            } else {
                objects[i].put('Position__c', i + 1);
            }
        }
        return objects;
    }
}