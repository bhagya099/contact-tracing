({
  doInit: function (component, event, helper) {
    const scope = component.get("v.scope");
    if (scope === "person") {
      component.set("v.columns", [
        {
          label: "Name",
          fieldName: "Name",
          type: "text"
        },
        { label: "Mobile Number", fieldName: "Mobile__c", type: "text" },
        { label: "Token", fieldName: "Token__c", type: "text" },
        {
          label: "Health Status",
          fieldName: "Health_Status__c",
          type: "text"
        },

        {
          label: "Status Update date",
          fieldName: "Status_Update_Date__c",
          type: "date"
        },
        {
          label: "View",
          type: "button",
          initialWidth: 135,
          typeAttributes: {
            label: "View/Update",
            name: "view_details",
            title: "Click to View Details"
          }
        }
      ]);
    } else {
      component.set("v.columns", [
        {
          label: "Name",
          fieldName: "Name",
          type: "text"
        },
        {
          label: "Status",
          fieldName: "Status__c",
          type: "text"
        },
        { label: "Address", fieldName: "Address__c", type: "text" },
        { label: "Pincode", fieldName: "Pincode__c", type: "text" },
        {
          label: "Red Score",
          fieldName: "Red_Score__c",
          type: "number"
        },

        {
          label: "Status Update date",
          fieldName: "Status_Update_Date__c",
          type: "date"
        },
        {
          label: "View",
          type: "button",
          initialWidth: 135,
          typeAttributes: {
            label: "View/Update",
            name: "view_details",
            title: "Click to View Details"
          }
        }
      ]);
    }

    helper.fetchRecentHealthChanges(component);
  },

  handleKeyUp: function (component, event, helper) {
    let isEnterKey = event.keyCode === 13;
    let queryTerm = component.find("enter-search").get("v.value");
    if (!queryTerm) {
      console.log("frpm intial value");
      console.log(component.get("v.intialResponse"));
      component.set("v.data", component.get("v.intialResponse"));
    }
    if (isEnterKey) {
      component.set("v.issearching", true);
      helper.serachRecord(component, queryTerm);
    }
  },
  handleRowAction: function (component, event, helper) {
    console.log("from hadle row action");
    let action = event.getParam("action");
    let row = event.getParam("row");
    const scope = component.get("v.scope");
    switch (action.name) {
      case "view_details":
        const appEvent =
          scope === "person"
            ? $A.get("e.c:CTPersonSelectEvent")
            : $A.get("e.c:CTLocationSelectEvent");
        appEvent.setParams({
          recordId: row.Id,
          status: scope === "person" ? row.Health_Status__c : row.Status__c
        });

        appEvent.fire();
        break;
    }
  }
});
