/**
 * Created by IlarionTokarskyi on 11/4/2019.
 */

({
    doInit: function (component, event, helper) {
        let priority = component.get("v.priority");
        let div = component.find("div");
        if (priority === "Urgent") {
            $A.util.addClass(div, "very_high");
        } else if (priority === "Client Request") {
            $A.util.addClass(div, "high");
        } else if (priority === "OS Task") {
            $A.util.addClass(div, "normal");
        } else if (priority === "New Project") {
            $A.util.addClass(div, "low");
        } else if (priority === "Stopped") {
            $A.util.addClass(div, "very_low");
        }
    }
});