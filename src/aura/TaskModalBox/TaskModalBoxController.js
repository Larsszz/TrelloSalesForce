/**
 * Created by IlarionTokarskyi on 11/1/2019.
 */

({
    closeModel: function (component, event, helper) {
        let action = component.getEvent("closeModalEvent");
        action.fire();
    },

    startEditName: function (component, event, helper) {
        let oldName = component.find("oldNameField");
        let oldButton = component.find("oldNameButton");
        let newName = component.find("newNameField");
        let newButton = component.find("newNameButton");
        $A.util.addClass(oldName, "slds-hide");
        $A.util.addClass(oldButton, "slds-hide");
        $A.util.removeClass(newName, "slds-hide");
        $A.util.removeClass(newButton, "slds-hide");
    },

    endEditName: function (component, event, helper) {
        let oldName = component.find("oldNameField");
        let oldButton = component.find("oldNameButton");
        let newName = component.find("newNameField");
        let newButton = component.find("newNameButton");
        let action = component.get("c.updateTaskName");
        action.setParams({"task": component.get("v.task"), "name": newName.get("v.value")});
        $A.enqueueAction(action);
        $A.util.addClass(newName, "slds-hide");
        $A.util.addClass(newButton, "slds-hide");
        $A.util.removeClass(oldName, "slds-hide");
        $A.util.removeClass(oldButton, "slds-hide");
        action = component.getEvent("editTaskNameEvent");
        action.setParams({"name": newName.get("v.value")});
        action.fire();
    },

    startEditDescription: function (component, event, helper) {
        let oldDescription = component.find("oldDescriptionField");
        let oldButton = component.find("oldDescriptionButton");
        let newDescription = component.find("newDescriptionField");
        let newButton = component.find("newDescriptionButton");
        $A.util.addClass(oldDescription, "slds-hide");
        $A.util.addClass(oldButton, "slds-hide");
        $A.util.removeClass(newDescription, "slds-hide");
        $A.util.removeClass(newButton, "slds-hide");
    },

    endEditDescription: function (component, event, helper) {
        let oldDescription = component.find("oldDescriptionField");
        let oldButton = component.find("oldDescriptionButton");
        let newDescription = component.find("newDescriptionField");
        let newButton = component.find("newDescriptionButton");
        $A.util.addClass(newDescription, "slds-hide");
        $A.util.addClass(newButton, "slds-hide");
        $A.util.removeClass(oldDescription, "slds-hide");
        $A.util.removeClass(oldButton, "slds-hide");
        let action = component.get("c.updateTaskDescription");
        action.setParams({"task": component.get("v.task"), "description": newDescription.get("v.value")});
        $A.enqueueAction(action);
        action = component.getEvent("editTaskDescriptionEvent");
        action.setParams({"description": newDescription.get("v.value")});
        action.fire();
    },

    deleteTask: function (component, event, helper) {
        let action = component.getEvent("deleteTaskEvent");
        action.setParams({"task": component.get("v.task")});
        action.fire();
        action = component.get("c.closeModel");
        $A.enqueueAction(action);
    },

    doInit: function (component, event, helper) {
        let priorities = component.get("v.priorities");
        for (let i = 0; i < priorities.length; i++) {
            if (priorities[i] === "Very High") {
                let button = component.find("vhButton");
                button.set("v.variant", "neutral");
            } else if (priorities[i] === "High") {
                let button = component.find("hButton");
                button.set("v.variant", "neutral");
            } else if (priorities[i] === "Normal") {
                let button = component.find("nButton");
                button.set("v.variant", "neutral");
            } else if (priorities[i] === "Low") {
                let button = component.find("lButton");
                button.set("v.variant", "neutral");
            } else if (priorities[i] === "Very Low") {
                let button = component.find("vlButton");
                button.set("v.variant", "neutral");
            }

        }
    },

    addRemovePriority: function (component, event, helper) {
        let button = event.getSource();
        if (button.get("v.variant")==="brand") {
            let action = component.getEvent("addPriorityEvent");
            action.setParams({"priority":button.get("v.label")});
            action.fire();
            button.set("v.variant","neutral");
        } else {
            let action = component.getEvent("deletePriorityEvent");
            action.setParams({"priority":button.get("v.label")});
            action.fire();
            button.set("v.variant","brand");
        }
    }
});