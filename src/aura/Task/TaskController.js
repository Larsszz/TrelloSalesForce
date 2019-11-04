/**
 * Created by IlarionTokarskyi on 10/29/2019.
 */

({
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
        console.log(task.Description__c);
        task.Description__c = description;
        component.set("v.task", task);
    }
});