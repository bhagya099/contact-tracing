public with sharing class CTPeopleTracingController {


    public static List<People_Tracing__c> getTraces(String personID) {
        return [SELECT Id, Contact_Date__c, 
                   Person_1__r.Health_Status__c, Person_1__r.Token__c, Person_2__r.Health_Status__c, Person_2__r.Token__c 
                   FROM People_Tracing__c 
                   WHERE (Person_1__c =: personID OR Person_2__c =: personID)
                   AND Contact_Date__c = LAST_N_DAYS:30
                   ORDER BY Contact_Date__c DESC];
    }

    public static List<People_Tracing__c> checkDuplicates(List<People_Tracing__c> newPeopleTraces) {
        // unique personIDs
        Set<Id> personIds = new Set<Id>();
        for (People_Tracing__c trace: newPeopleTraces) {
            personIds.add(trace.Person_1__c);
            personIds.add(trace.Person_2__c);
        }

        // list duplicates record
        List<People_Tracing__c> duplicates = new List<People_Tracing__c>();

        // map id and set<id>
        Map<Id,Set<Id>> mapofExistRecords = new Map<Id,Set<Id>>() ;

        // query existing records
        List<People_Tracing__c> existingRecords= [SELECT Id, Person_1__c, Person_2__c FROM People_Tracing__c 
                                                   WHERE Person_1__c IN: personIDs
                                                   OR Person_2__c IN :personIDs];
         
        // for person1 person2
        if(existingRecords != null && existingRecords.size() > 0) {
            for(People_Tracing__c trace:existingRecords) {

                if(! mapofExistRecords.containsKey(trace.Person_1__c)) {
                    mapofExistRecords.put(trace.Person_1__c, new Set<Id>());
                }

                mapofExistRecords.get(trace.Person_1__c).add(trace.Person_2__c);

                // ÷forperson2
           
                    if(! mapofExistRecords.containsKey(trace.Person_2__c)) {
                        mapofExistRecords.put(trace.Person_2__c, new Set<Id>());
                    }
    
                    mapofExistRecords.get(trace.Person_2__c).add(trace.Person_1__c);
                
            }
                for(People_Tracing__c trace: newPeopleTraces) {
                    if((mapofExistRecords.containsKey(trace.Person_1__c) && mapofExistRecords.get(trace.Person_1__c).contains(trace.Person_2__c))
                    ||
                    (mapofExistRecords.containsKey(trace.Person_2__c) && mapofExistRecords.get(trace.Person_2__c).contains(trace.Person_1__c))) 
                  {
                    duplicates.add(trace);
                   }
            
                }
           
          
         }
         return duplicates;
    }
 
}