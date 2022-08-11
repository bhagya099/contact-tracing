public with sharing class CTPersonController {

       public static String getToken(String mobileNo) {
        Blob value = Blob.valueOf(mobileNo);
        Blob hash = Crypto.generateDigest('MD5', value);

        //get the string value of hash blob
        return EncodingUtil.base64Encode(hash);
        }


         /*
         get 100 contacts with recent health status change
         return type is list>person__c>
         */
         public static List<Person__c> getRecentHealthChanges() {
          return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c
                  FROM Person__c 
                  ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100] ;
             
          }
        // getting all the field by passing the values
        public static List<Person__c> searchPeople(String searchTerm) {
            searchTerm = searchTerm + '%';
            return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c  
                    FROM Person__c 
                    WHERE Name LIKE :searchTerm OR Mobile__c LIKE :searchTerm OR Token__c LIKE :searchTerm
                    ORDER BY Status_Update_Date__c DESC NULLS LAST];
          }
         //   getting result searchiung by id
         public static Person__c getPersonById(String personId) {
          List<Person__c> people =   [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c FROM Person__c WHERE Id =:personId];
           if(people != null && people.size() > 0) {
            return people[0];

           }
           return null;
          
          }

         public static Map<String,Integer> getHealthStatusCount() {
             Map<String,Integer> healthCountMap = new Map<String,Integer>();
             for(AggregateResult arr :  [SELECT Health_Status__c, COUNT(Id) total 
                                          FROM Person__c  
                                          GROUP BY Health_Status__c]) {
                        // putting the calues in variable and convert thier output in integer and string
                     healthCountMap.put(String.valueOf(arr.get('Health_Status__c')),Integer.valueOf(arr.get('total')));
                 }

           return healthCountMap;
        }
         

        public static Set<Id> getCohabitants(Set<Id> personIds,Set<Id> alreadyProcessed) {
            List<String> healthStatus = new List<String>{'Green', 'Yellow'};
            List<People_Tracing__c> peopletrace = [SELECT Id, Person_1__c, Person_2__c FROM People_Tracing__c 
                                                  WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds) 
                                                  AND Contact_Type__c = 'Cohabitant'
                                                  AND (Person_1__r.Health_Status__c IN : healthStatus OR Person_2__r.Health_Status__c IN :healthStatus)];
            set<Id> cohabitans = new Set<Id>();
            for(People_Tracing__c pt:peopletrace) {
               if(!alreadyProcessed.contains(pt.Person_1__c)) {
                  cohabitans.add(pt.Person_1__c);
                  alreadyProcessed.add(pt.Person_1__c);
               }
               if(!alreadyProcessed.contains(pt.Person_2__c)) {
                  cohabitans.add(pt.Person_2__c);
                  alreadyProcessed.add(pt.Person_2__c);
               }
            }

            return cohabitans;
        }
       
         //getting neighbours id
       public static Set<Id> getNeighbours(Set<Id> personIds, Set<Id> alreadyProcessed) {
         
         List<People_Tracing__c> peopletrace = [SELECT Id, Person_1__c, Person_2__c FROM People_Tracing__c 
                                               WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds) 
                                               AND Contact_Type__c = 'Neighbour'
                                               AND (Person_1__r.Health_Status__c = 'Green'  OR Person_2__r.Health_Status__c = 'Green')];
         set<Id> neighbour = new Set<Id>();
         for(People_Tracing__c pt:peopletrace) {
            if(!alreadyProcessed.contains(pt.Person_1__c)) {
               neighbour.add(pt.Person_1__c);
               alreadyProcessed.add(pt.Person_1__c);
            }
            if(!alreadyProcessed.contains(pt.Person_2__c)) {
               neighbour.add(pt.Person_2__c);
               alreadyProcessed.add(pt.Person_2__c);
            }
          }

         return neighbour;
         }

     //get rpimary contacts

        public static Set<Id> getPrimary(Set<Id> personIds, Set<Id> alreadyProcessed) {
          List<String> healthStatus = new List<String>{'Green', 'Yellow'};
          List<People_Tracing__c> peopletrace = [SELECT Id, Person_1__c, Person_2__c FROM People_Tracing__c 
                                            WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds) 
                                            AND Contact_Type__c = 'Other'
                                            AND Contact_Date__c = LAST_N_DAYS:10
                                            AND (Person_1__r.Health_Status__c In :healthStatus  OR Person_2__r.Health_Status__c In :healthStatus)];
           set<Id> primaryContacts = new Set<Id>();
           for(People_Tracing__c pt:peopletrace) {
               if(!alreadyProcessed.contains(pt.Person_1__c)) {
                  primaryContacts.add(pt.Person_1__c);
                  alreadyProcessed.add(pt.Person_1__c);
                }
               if(!alreadyProcessed.contains(pt.Person_2__c)) {
                  primaryContacts.add(pt.Person_2__c);
                  alreadyProcessed.add(pt.Person_2__c);
              }
            }   

            return primaryContacts;
          }  

          //get secondary contacts

        public static Set<Id> getSecondary(Set<Id> primaryContactIds, Set<Id> alreadyProcessed) {
         List<String> healthStatus = new List<String>{'Green', 'Yellow'};
         List<People_Tracing__c> peopletrace = [SELECT Id, Person_1__c, Person_2__c FROM People_Tracing__c 
                                           WHERE (Person_1__c IN :primaryContactIds OR Person_2__c IN :primaryContactIds) 
                                           AND Contact_Type__c = 'Other'
                                           AND Contact_Date__c = LAST_N_DAYS:10
                                           AND (Person_1__r.Health_Status__c In :healthStatus  OR Person_2__r.Health_Status__c In :healthStatus)];
          set<Id> secondaryContacts = new Set<Id>();
          for(People_Tracing__c pt:peopletrace) {
              if(!alreadyProcessed.contains(pt.Person_1__c)) {
               secondaryContacts.add(pt.Person_1__c);
               alreadyProcessed.add(pt.Person_1__c);
               }
              if(!alreadyProcessed.contains(pt.Person_2__c)) {
               secondaryContacts.add(pt.Person_2__c);
               alreadyProcessed.add(pt.Person_2__c);
               }
           }   

           return secondaryContacts;
         }  
 }
  