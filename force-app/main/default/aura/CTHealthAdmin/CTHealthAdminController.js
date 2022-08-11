({
  tabSelectHandler: function (component, event, helper) {
    const selectedTabID = event.getParam("id");
    if (selectedTabID === "person_view") {
      component.set("v.headerTitel", "Person View");
    } else {
      component.set("v.headerTitel", "Location View");
    }
    component.set("v.scope", selectedTabID);
  }
});
