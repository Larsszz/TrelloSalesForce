/**
 * Created by IlarionTokarskyi on 10/25/2019.
 */

({
    doInit: function (component, event, helper) {
        let action = component.get("c.getNewBoard");
        let id = component.get("v.recordId");
        action.setParams({"id": id});
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.categories", response.getReturnValue());
            } else {
                console.log('Failed init board with state:  ' + state);
            }
        });
        $A.enqueueAction(action);
        const empApi = component.find('empApi');
        const replayId = -1;
        empApi.subscribe('/event/Change_board__e', replayId, $A.getCallback(eventReceived => {
            action.setCallback(this, function (response) {
                let state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.categories", response.getReturnValue());
                } else {
                    console.log('Failed init board with state:  ' + state);
                }
            });
            $A.enqueueAction(action);
        }));
    },

    showHideAddStage: function (component, event, helper) {
        let element = component.find("toHide");
        let label = component.find('addButton');
        if ($A.util.hasClass(element, "slds-hide")) {
            $A.util.removeClass(element, "slds-hide");
            label.set('v.label', 'Close');
        } else {
            $A.util.addClass(element, "slds-hide");
            label.set('v.label', 'Add Stage');
        }
    },

    addStage: function (component, event, helper) {
        let inputName = component.find("inputStage").get("v.value");
        let id = component.get("v.recordId");
        let action = component.get("c.crateNewCategory");
        action.setParams({"id": id, "name": inputName});
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                let categories = component.get("v.categories");
                if (categories === undefined) {
                    component.set("v.categories", [response.getReturnValue()]);
                } else {
                    categories.push(response.getReturnValue());
                    component.set("v.categories", categories);
                }
            } else {
                console.log('Failed create stage with state:  ' + response.getState());
            }
        });
        $A.enqueueAction(action);
        action = component.get("c.showHideAddStage");
        $A.enqueueAction(action);
        let input = component.find("inputStage");
        input.set("v.value", "");

    },

    deleteStage: function (component, event, helper) {
        let category = event.getParam("category");
        let categories = component.get("v.categories");
        let index = -1;
        for (let i = 0; i < categories.length; i++) {
            if (Object.values(category)[0] === Object.values(categories[i])[0]) {
                index = i;
            }
        }
        if (index > -1) {
            categories.splice(index, 1);
            component.set("v.categories", categories);
        }
    },

    changeCategoryPosition: function (component, event, helper) {
        let categories = component.get("v.categories");
        let index = event.getParam("index");
        let categoryToUpdate = event.getParam("category");
        let oldIndex = -1;
        for (let i = 0; i < categories.length; i++) {
            if (JSON.stringify(categoryToUpdate) === JSON.stringify(categories[i])) {
                oldIndex = i;
            }
        }
        if (oldIndex > -1) {
            if (oldIndex === index) return;
            categories.splice(oldIndex, 1);
            if (index >= oldIndex) index = index - 1;
            let action = component.get("c.updateCategoriesPosition");
            action.setParams({"category": categoryToUpdate, "position": index});
            $A.enqueueAction(action);
            categoryToUpdate.Position__c = index;
            categories.splice(index, 0, categoryToUpdate);
            component.set("v.categories", categories);
        }
    }


});