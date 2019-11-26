/**
 * Created by IlarionTokarskyi on 10/29/2019.
 */

({
    doInit: function(component, event, helper) {
        let priority = component.get("v.task.Priority__c");
        if (priority){
            let array = priority.split(';');
            component.set("v.priorities", array);
        }
    },

    startDrag: function (component, event, helper) {
        event.dataTransfer.dropEffect = "move";
        let task = component.get("v.task");
        event.dataTransfer.setData('task', JSON.stringify(task));
    },

    endDrag: function (component, event, helper) {
        let index = component.get("v.index");
        let dragEvent = component.getEvent("dragTask");
        dragEvent.setParams({"index": index});
        dragEvent.fire();
    },

    openModalBox: function (component, event, helper) {
        component.set("v.modalBoxIsOpen", true);
    },

    closeModalBox: function (component, event, helper) {
        component.set("v.modalBoxIsOpen", false);
    },

    updateTask: function (component, event, helper) {
        let name = event.getParam("name");
        let task = event.getParam('task');
        let description = event.getParam('description');
        let priorities = event.getParam('priorities');
        let action = component.get('c.editTaskBoard');
        action.setParams({'taskBoard': task, 'newName': name, 'newDescription': description, 'newPriorities': priorities});
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.task", response.getReturnValue());
            } else {
                console.log('Failed update Task with state:  ' + state);
            }
        });
        $A.enqueueAction(action);
    }
});