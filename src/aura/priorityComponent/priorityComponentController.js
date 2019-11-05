/**
 * Created by IlarionTokarskyi on 11/4/2019.
 */

({
    doInit: function (component, event, helper) {
        let priority = component.get("v.priority");
        let div = component.find("div");
        if (priority === "Very High") {
            $A.util.addClass(div, "very_high");
        } else if (priority === "High") {
            $A.util.addClass(div, "high");
        } else if (priority === "Normal") {
            $A.util.addClass(div, "normal");
        } else if (priority === "Low") {
            $A.util.addClass(div, "low");
        } else if (priority === "Very Low") {
            $A.util.addClass(div, "very_low");
        }
    }
});