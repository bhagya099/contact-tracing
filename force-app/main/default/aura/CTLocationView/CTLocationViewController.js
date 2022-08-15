({
  locationSelectHandler: function (component, event, helper) {
    console.log("clicked from ");
    const recordId = event.getParam("recordId");
    const stauts = event.getParam("status");
    component.set("v.recordId", recordId);
    component.set("v.status", stauts);
  }
});
