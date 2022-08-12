({
  fetchRecentHealthChanges: function (component) {
    let action =
      component.get("v.scope") === "person"
        ? component.get("c.getRecentPersonHealthChnages")
        : component.get("c.getRecentLocationHealthChnages");

    action.setCallback(this, function (response) {
      let state = response.getState();
      if (state === "SUCCESS") {
        const data = response.getReturnValue();
        component.set("v.data", data);
      }
    });

    $A.enqueueAction(action);
  }
});
