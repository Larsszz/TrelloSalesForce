/**
 * Created by IlarionTokarskyi on 11/5/2019.
 */

trigger CategoryTrigger on Category__c (after insert, after update, after delete) {
    if (Trigger.isInsert) {
        if (Trigger.isAfter) {
            CategoryTriggerHandler.isAfterInsert();
        }
    }
    if (Trigger.isUpdate) {
        if (Trigger.isAfter) {
            CategoryTriggerHandler.isAfterUpdate();
        }
    }
    if (Trigger.isDelete) {
        if (Trigger.isAfter) {
            CategoryTriggerHandler.isAfterDelete();
        }
    }
}