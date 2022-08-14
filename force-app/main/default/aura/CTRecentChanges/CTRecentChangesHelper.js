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
        component.set("v.intialResponse", data);
      }
    });

    $A.enqueueAction(action);
  },

  serachRecord: function (component, queryTerm) {
    let action =
      component.get("v.scope") === "person"
        ? component.get("c.searchPeople")
        : component.get("c.searchLocation");

    action.setParams({
      searchTerm: queryTerm
    });

    action.setCallback(this, function (response) {
      let state = response.getState();
      if (state === "SUCCESS") {
        const data = response.getReturnValue();

        if (data && data.length > 0) {
          component.set("v.data", data);
        }
        component.set("v.issearching", false);
      }
    });
    $A.enqueueAction(action);
  }
});
