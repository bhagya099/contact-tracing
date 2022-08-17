public with sharing class CTLocationTracingController {

    // getting the location tracing record bu locationid and getting health record by it's parent object(person)
    public static List<Location_Tracing__c> getVisitors(String locationId) {
        return [SELECT Id, Person__c, Location__c, Visit_Date__c, Person__r.Token__c, Person__r.Health_status__c 
                FROM Location_Tracing__c 
                WHERE Location__c =: locationId
                ORDER BY Visit_Date__c DESC];
    }


    // getting th location by person ids who is vivsted last 10days
    public static List<Location_Tracing__c> getLocationByPersonIds(Set<Id> personIds) {
        return [SELECT Id,  Person__c, Location__c  
                FROM Location_Tracing__c
                WHERE Person__c IN : personIds   //since it's a set so we are using IN to matches it
                AND Visit_Date__c = Last_N_DAYS:10];
    }

    // getting the recoed by location ids who health is green and visisted in last 10 days

    public static List<Location_Tracing__c> getLocationByLocationIds(Set<Id> locationIds ) {

             return [SELECT Id,  Person__c, Location__c 
                From Location_Tracing__c
                WHERE Location__c IN :locationIds
                AND Person__r.Health_status__c = 'Green'
                AND Visit_Date__c = Last_N_DAYS:10];
        
    }
    // checking the duplicate location tracing record before insert one

    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> newLocationTraces) {
        // ÷store unique location Ids
        Set<Id> locationIds = new Set<Id>();
        // store uniques person Ids
        Set<Id> personsIDs = new Set<Id>();
        for(Location_Tracing__c trace: newLocationTraces) {
          locationIds.add(trace.Location__c);
          personsIDs.add(trace.Person__c);
        }

        // Map of location id,set of person id
        Map<Id, Set<Id>> mapOfExistingRecords = new Map<Id, Set<Id>> () ;
        

        // query exisiting location tracing records
        List<Location_Tracing__c> existingRecords =  [SELECT Id,  Person__c, Location__c 
                                      From Location_Tracing__c
                                      WHERE Id =: locationIds
                                      AND Id =: personsIDs];


        // list of duplicate records
        List<Location_Tracing__c> duplicates = new List<Location_Tracing__c>();

        if(existingRecords != null & existingRecords.size()>0) {
            for(Location_Tracing__c trace:existingRecords) {
             if(!mapOfExistingRecords.containsKey(trace.Location__c)){
                mapOfExistingRecords.put(trace.Location__c, new Set<Id>());
             }
             System.debug(mapOfExistingRecords.get(trace.Location__c));
            //  location__c is adding in mao as a key and it's valus is set of persons 
            // so adding persons id to map set 
             mapOfExistingRecords.get(trace.Location__c).add(trace.Person__c);

            }
        //   loop over new tracing records
            for(Location_Tracing__c trace: newLocationTraces) {
            //    first check for location id
            // if id found in map then check for person id in set
            if(mapOfExistingRecords.containsKey(trace.Location__c)
              && mapOfExistingRecords.get(trace.Location__c).contains(trace.Person__c)
            ) {
                duplicates.add(trace);
               }
            }
        }            
        
        return duplicates;
    }
}
