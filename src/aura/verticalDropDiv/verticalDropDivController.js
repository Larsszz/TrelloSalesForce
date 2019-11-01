/**
 * Created by IlarionTokarskyi on 10/30/2019.
 */

({
    allowDrop: function (component, event, helper) {
        event.preventDefault();
    },

    onDrop : function (component, event, helper) {
        let index = component.get("v.index");
        let action = component.getEvent("changeCategoryPosition");
        action.setParams({"index":index,"category":JSON.parse(event.dataTransfer.getData('category'))});
        action.fire();
    }
});