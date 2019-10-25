/**
 * Created by IlarionTokarskyi on 10/25/2019.
 */

({
    doInit: function (component, event, helper) {
        let action = component.get("c.getNewBoard");
        let id = component.get("v.recordId");
        console.log("Id is     " + id);
        action.setParams({"id": id});
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.categories", response.getReturnValue());
            } else {
                console.log('Failed init board with state:  ' + state);
            }
        });
        $A.enqueueAction(action);
        let element = component.find("toHide");
        element.style.display = 'none';
    },

    addCategory: function (component, event, helper) {
        let element = component.find("toHide");
        if (element.style.display === 'none') {
            element.style.display = 'block';
        } else {
            element.style.display = 'none';
        }
    }
});