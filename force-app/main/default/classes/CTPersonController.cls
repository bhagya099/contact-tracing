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
 
}
