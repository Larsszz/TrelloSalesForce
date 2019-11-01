/**
 * Created by IlarionTokarskyi on 10/28/2019.
 */

({
    deleteCategory: function (component, event, helper) {
        let action = component.get("c.deleteCategoryById");
        let categoryId = component.get("v.category.Id");
        let category = component.get("v.category");
        let deleteEvent = component.getEvent("deleteEvent");
        action.setParams({"id": categoryId});
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let deleteEvent = component.getEvent("deleteEvent");
                deleteEvent.setParams({"category": category});
                deleteEvent.fire();
            } else {
                console.log('Failed init board with state:  ' + state);
            }
        });
        $A.enqueueAction(action);
    },

    showHideTask: function (component, event, helper) {
        let element = component.find("inputTask");
        if ($A.util.hasClass(element, "slds-hide")) {
            $A.util.removeClass(element, "slds-hide");
        } else {
            $A.util.addClass(element, "slds-hide");
        }
    },

    addTask: function (component, event, helper) {
        let action = component.get("c.addTaskByInput");
        let taskName = component.find("inputTaskName").get("v.value");
        let taskDesc = component.find("inputTaskDescription").get("v.value");
        const categoryId = component.get("v.category.Id");
        action.setParams({"name": taskName, "description": taskDesc, "idCategory": categoryId});
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let tasks = component.get("v.tasks");
                if (tasks === undefined) {
                    component.set("v.tasks", [response.getReturnValue()]);
                } else {
                    tasks.push(response.getReturnValue());
                    component.set("v.tasks", tasks);
                }
            } else {
                console.log('Failed init board with state:  ' + state);
            }
        });
        $A.enqueueAction(action);
    },

    allowDrop: function (component, event, helper) {
        event.preventDefault();
    },

    onDrop: function (component, event, helper) {
        //event.preventDefault();
        let tasks = component.get("v.tasks");
        let index = component.get("v.positionToTask");
        let taskToAdd = JSON.parse(event.dataTransfer.getData('task'));
        if (tasks !== undefined) {
            tasks.splice(index, 0, taskToAdd);
            component.set("v.tasks", tasks);

        } else {
            component.set("v.tasks", [taskToAdd]);
        }
        let action = component.get("c.updateTaskCategory");
        action.setParams({"task": taskToAdd, "category": component.get("v.category"),"position":index});
        $A.enqueueAction(action);
    },

    deleteByDrop: function (component, event, helper) {
        if (component.get("v.approvePosition")) {
            let index = event.getParam("index");
            let tasks = component.get("v.tasks");
            tasks.splice(index, 1);
            component.set("v.tasks", tasks);
            component.set("v.approvePosition", false);
        }
    },

    setPosition: function (component, event, helper) {
        let index = event.getParam("index");
        component.set("v.positionToTask", index);
    },

    correctlyDelete : function (component, event, helper) {
        component.set("v.approvePosition", true);
    },

    startDrag : function (component, event, helper) {
        event.dataTransfer.dropEffect = "move";
        let category = component.get("v.category");
        event.dataTransfer.setData('category', JSON.stringify(category));
    }
});