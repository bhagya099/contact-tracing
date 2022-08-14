({
  fetchStatusCount: function (component) {
    let action =
      component.get("v.scope") === "person"
        ? component.get("c.getPersonHealthStatuscount")
        : component.get("c.getLocationHealthStatuscount");

    action.setCallback(this, function (response) {
      const state = response.getState();

      if (state === "SUCCESS") {
        component.set("v.count", response.getReturnValue());
        console.log(component.get("v.count"));
        console.log(component.get("v.scope"));
      }
    });

    $A.enqueueAction(action);
  }
});
