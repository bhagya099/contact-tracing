public with sharing class CTLocationTracingController {

    // getting the location tracing record bu locationid and getting health record by it's parent object(person)
    public static List<Location_Tracing__c> getVisitors(String locationId) {
        return [SELECT Id, Person__c, Location__c, Visit_Date__c, Person__r.Token__c, Person__r.Health_status__c 
                FROM Location_Tracing__c 
                WHERE Id =: locationId
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
}
