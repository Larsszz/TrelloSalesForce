/**
 * Created by IlarionTokarskyi on 11/5/2019.
 */

public with sharing class CategoryTriggerHandler {
    public static void isAfterInsert() {
        EventBus.publish(new Change_board__e());
    }

    public static void isAfterUpdate() {
        EventBus.publish(new Change_board__e());
    }

    public static void isAfterDelete() {
        EventBus.publish(new Change_board__e());
    }
}