public with sharing class CTPersonTriggerHandler {
    public static void beforeInsert(List<Person__c> newPerson) {
        // todo update health status to green
            //generate the unique token 
            for(Person__c persons: newPerson) {
                persons.Health_Status__c = 'Green';
               persons.Token__c = CTPersonController.getToken(persons.Mobile__c);
            }
    }

    public static void beforeUpdate(List<Person__c> newRecords, Map<Id, Person__c> oldRecord) {
        for(Person__c persons: newRecords) {
          if(persons.Health_Status__c != oldRecord.get(persons.Id).Health_Status__c) {
            persons.Status_Update_Date__c = Date.today();
          }
        }
    }

    public static void afterUpdate(List<Person__c> newRecords, Map<Id, Person__c> oldRecord) {
        Set<Id> statusChange =new Set<Id> () ;
        Set<Id> redStatus = new  Set<Id>();
        for(Person__c persons: newRecords) {
            if(persons.Health_Status__c != oldRecord.get(persons.Id).Health_Status__c) {
                  statusChange.add(persons.Id);
            }

            if(persons.Health_Status__c == 'Red' && oldRecord.get(persons.Id).Health_Status__c != 'Red') {
                   redStatus.add(persons.Id);
            }
        }
        Set<Id> alreadyProcessed = new Set<Id>();
        alreadyProcessed.addAll(redStatus);

        Set<Id> orangeStatus = new Set<Id>();
        Set<Id> yellowStatus = new Set<Id>();


        List<Person__c> peopleToUpdate = new List<Person__c>();

        
        //adding cohabitants ids in orangestatus who's health status is red
        orangeStatus.addAll(CTPersonController.getCohabitants(redStatus, alreadyProcessed));

        //getting priamry contact ID who is red and storing it to variable 
        Set<Id> primaryContact = CTPersonController.getPrimary(redStatus, alreadyProcessed);

        //aading priamry contact to orange who is red
        orangeStatus.addAll(primaryContact);

         //adding neighbours ids in yellow who's health staus is red
         yellowStatus.addAll(CTPersonController.getNeighbours(redStatus, alreadyProcessed));

        //aading secondary contact to orange who is contacted to primary contact
        yellowStatus.addAll(CTPersonController.getSecondary(primaryContact, alreadyProcessed));

        for(Id pId:orangeStatus) {
            peopleToUpdate.add(new Person__c(Id=pId, Health_Status__c = 'Orange'));
        }

        for(Id pId:yellowStatus) {
            peopleToUpdate.add(new Person__c(Id=pId, Health_Status__c = 'Yellow'));
        }
        
       
        if(peopleToUpdate.size()> 0) {
            update peopleToUpdate;
           } 

        List<Location_Tracing__c> locationtraces = CTLocationTracingController.getLocationByPersonIds(statusChange);
        if(locationtraces != null && locationtraces.size() > 0) {
            Set<Id> locationIds = new Set<Id>();
            for(Location_Tracing__c location:locationtraces) {
                locationIds.add(location.Location__c);
            }
             CTLocationController.updateRedScore(locationIds);

        } 
    }
        
}
