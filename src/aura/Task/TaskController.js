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

    editName: function (component, event, helper) {
        let name = event.getParam("name");
        let task = component.get("v.task");
        task.Name = name;
        component.set("v.task", task);
    },

    editDescription: function (component, event, helper) {
        let description = event.getParam("description");
        let task = component.get("v.task");
        task.Description__c = description;
        component.set("v.task", task);
    },

    addPriority: function (component, event, helper) {
        let priority = event.getParam("priority");
        let priors = component.get("v.priorities");
        if (priors) {
            priors.push(priority);
            component.set("v.priorities",priors);
        } else {
            component.set("v.priorities",[priority]);
        }
        let action = component.get("c.addPriorityToTask");
        action.setParams({"task":component.get("v.task"),"priority":priority});
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.task", response.getReturnValue());
            } else {
                console.log('Failed add Priority with state:  ' + state);
            }
        });
        $A.enqueueAction(action);
    },

    deletePriority: function (component, event, helper) {
        let priority = event.getParam("priority");
        let priors = component.get("v.priorities");
        priors.splice(priors.indexOf(priority),1);
        component.set("v.priorities",priors);
        let action = component.get("c.deletePriorityFromTask");
        action.setParams({"task":component.get("v.task"),"priority":priority});
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.task", response.getReturnValue());
            } else {
                console.log('Failed delete Priority with state:  ' + state);
            }
        });
        $A.enqueueAction(action);
    }
});