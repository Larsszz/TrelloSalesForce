/**
 * Created by IlarionTokarskyi on 10/29/2019.
 */

({
    allowDrop: function (component, event, helper) {
        event.preventDefault();
        let index = component.get("v.index");
        if (index === undefined) index = 0;
        let changeEvent = component.getEvent("changePosition");
        changeEvent.setParams({"index": index});
        changeEvent.fire();
    },

    onDrop : function (component, event, helper) {
        let appEvent = $A.get("e.c:correctlyDelete");
        appEvent.fire();
    }
});