/**
 * Created by IlarionTokarskyi on 11/1/2019.
 */

({
    closeModel: function (component, event, helper) {
        let action = component.getEvent("closeModalEvent");
        action.fire();
    },

    startEditTask: function (component, event, helper) {
        let oldName = component.find("oldNameField");
        let newName = component.find("newNameField");
        let oldDescription = component.find("oldDescriptionField");
        let newDescription = component.find("newDescriptionField");
        let buttons = component.find('labelButtons');
        let button = event.getSource();
        if (button.get("v.label") === "Edit") {
            $A.util.removeClass(buttons, "slds-hide");
            $A.util.addClass(oldName, "slds-hide");
            $A.util.removeClass(newName, "slds-hide");
            $A.util.addClass(oldDescription, "slds-hide");
            $A.util.removeClass(newDescription, "slds-hide");
            button.set('v.label', 'Save');
        } else if (button.get("v.label") === "Save") {
            let action = component.getEvent('editTaskEvent');
            action.setParams({
                'task': component.get('v.task'),
                'name': newName.get('v.value'),
                'description': newDescription.get('v.value'),
                'priorities': component.get('v.priorities')
            });
            action.fire();
            action = component.getEvent("closeModalEvent");
            action.fire();
        }

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
            if (priorities[i] === "Urgent") {
                let button = component.find("vhButton");
                button.set("v.variant", "neutral");
            } else if (priorities[i] === "Client Request") {
                let button = component.find("hButton");
                button.set("v.variant", "neutral");
            } else if (priorities[i] === "OS Task") {
                let button = component.find("nButton");
                button.set("v.variant", "neutral");
            } else if (priorities[i] === "New Project") {
                let button = component.find("lButton");
                button.set("v.variant", "neutral");
            } else if (priorities[i] === "Stopped") {
                let button = component.find("vlButton");
                button.set("v.variant", "neutral");
            }

        }
    },

    addRemovePriority: function (component, event, helper) {
        let button = event.getSource();
        let priorities = component.get('v.priorities');
        if (button.get("v.variant") === "brand") {
            if (priorities === undefined) {
                component.set('v.priorities', [button.get('v.label')]);
            } else {
                priorities.push(button.get("v.label"));
                component.set('v.priorities', priorities);
            }
            button.set('v.variant','neutral');
        } else {
            let index = priorities.indexOf(button.get('v.label'));
            priorities.splice(index,1);
            button.set('v.variant', 'brand');
            component.set('v.priorities', priorities);
        }
    }
});