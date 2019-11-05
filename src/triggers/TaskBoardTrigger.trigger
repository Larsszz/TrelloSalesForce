/**
 * Created by IlarionTokarskyi on 11/5/2019.
 */

trigger TaskBoardTrigger on TaskBoard__c (after insert, after update, after delete) {
    EventBus.publish(new Change_board__e());
}