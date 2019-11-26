/**
 * Created by IlarionTokarskyi on 11/12/2019.
 */

({
    getAttachment : function (component) {
        let action = component.get("c.getAttachmentsForTask");
        let task = component.get("v.task");
        action.setParams({"id": task.Id});
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.attachments", response.getReturnValue());
            } else {
                console.log('Failed init attachment with state:  ' + state);
            }
        });
        $A.enqueueAction(action);
    }
});