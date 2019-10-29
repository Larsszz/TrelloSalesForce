/**
 * Created by IlarionTokarskyi on 10/29/2019.
 */

({
    startDrag : function (component, event, helper) {
        event.dataTransfer.dropEffect = "move";
        let task = component.get("v.task");
        let index = component.get("v.index");
        event.dataTransfer.setData('task', JSON.stringify(task));
    },

    endDrag : function (component, event, helper) {
        let index = component.get("v.index");
        let dragEvent = component.getEvent("dragTask");
        dragEvent.setParams({"index": index});
        dragEvent.fire();
    }
});