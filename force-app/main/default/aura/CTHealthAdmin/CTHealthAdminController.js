({
  tabSelectHandler: function (component, event, helper) {
    const selectedTabID = event.getParam("id");
    if (selectedTabID === "person") {
      component.set("v.headerTitle", "Person View");
    } else {
      component.set("v.headerTitle", "Location View");
    }
    component.set("v.scope", selectedTabID);

    const healthHeaderComp = component.find("health-header");
    healthHeaderComp.fetchCount();
  }
});
