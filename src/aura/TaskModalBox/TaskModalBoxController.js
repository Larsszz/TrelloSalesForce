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
            $A.util.removeClass(component.find("uploadArea"), "slds-hide");
            $A.util.removeClass(buttons, "slds-hide");
            $A.util.addClass(oldName, "slds-hide");
            $A.util.removeClass(newName, "slds-hide");
            $A.util.addClass(oldDescription, "slds-hide");
            $A.util.removeClass(newDescription, "slds-hide");
            button.set('v.label', 'Save');
            component.set('v.disableDeleteButtons', false);
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
            helper.getAttachment(component);
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
            button.set('v.variant', 'neutral');
        } else {
            let index = priorities.indexOf(button.get('v.label'));
            priorities.splice(index, 1);
            button.set('v.variant', 'brand');
            component.set('v.priorities', priorities);
        }
    },

    startUpload: function (component, event, helper) {
        const file = event.getSource().get("v.files")[0];
        const reader = new FileReader();
        reader.onload = (ev) => {
            component.set("v.fileBase64", ev.target.result);
        };
        reader.readAsDataURL(file);
        component.set("v.approveUploadFile", false);
        component.set("v.fileName", file.name);
    },

    uploadToServer: function (component, event, helper) {
        let action = component.get("c.uploadFile");
        action.setParams({
            "fileName": component.get("v.fileName"),
            "fileBase64": component.get("v.fileBase64"),
            "taskId": component.get("v.task.Id")
        });
        let attachments = component.get('v.attachments');
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.approveUploadFile", true);
                if (attachments) {
                    attachments.push(response.getReturnValue());
                    component.set('v.attachments', attachments);
                } else {
                    component.set('v.attachments', [response.getReturnValue()]);
                }
            } else {
                console.log('Failed upload File with state:  ' + response.getState());
            }
        });
        $A.enqueueAction(action);
    },

    downloadFileFromTask: function (component, event, helper) {
        let attachment = event.getSource().get('v.value');
        let action = component.get("c.downloadFile");
        action.setParams({"attachment": attachment});
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                document.location.href = response.getReturnValue();
            } else {
                console.log('Failed download File with state:  ' + response.getState());
            }
        });
        $A.enqueueAction(action);
    },

    deleteFileFromTask: function (component, event, helper) {
        let attachment = event.getSource().get('v.value');
        let attachments = component.get('v.attachments');
        let action = component.get("c.deleteFile");
        action.setParams({"attachment": attachment});
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                attachments.splice(attachments.indexOf(attachment),1);
                component.set('v.attachments', attachments);
            } else {
                console.log('Failed delete File with state:  ' + response.getState());
            }
        });
        $A.enqueueAction(action);
    }
});