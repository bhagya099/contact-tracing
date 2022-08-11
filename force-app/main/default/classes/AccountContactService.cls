public with sharing class AccountContactService {
    public static void updateActiveContact(Set<Id> accountIds) {
  ///first solution
        List<AggregateResult> results = [SELECT AccountId, COUNT(Id) totalContacts 
                                                FROM Contact 
                                                WHERE Active__c = true 
                                                AND AccountId IN : accountIds
                                                GROUP BY AccountID ];
        
         Map<Id, Account> accounts = new Map<Id, Account>();
         for(AggregateResult result:results) {
                String accId = String.valueOf(result.get('AccountId'));
                Integer totalContacts = Integer.valueOf(result.get('totalContacts'));
                Account acc = new Account(Id = accId, Active_Contacts__c = totalContacts);
                accounts.put(accId, acc);

                //  another way
                // accounts.add(new Account(Id = accId, Active_Contacts__c = totalContacts));
        }
        for (Id accId : accountIds ) {
            if(!accounts.containsKey(accId)) {
                accounts.put(accId,new Account(Id = accId, Active_Contacts__c = 0));
            }
        }


        update accounts.values(); 



        //seconbd solution

        /*
         List<Account> UpdatedAccounts = New List<Account>();
        For(Account result:    [SELECT id, Active_Contacts__c,
                               (SELECT Id from contacts where Active__c = True)
                                FROM Account
                                WHERE Id in:AccountIDs]){ 
 
        String AccountId = result.id;
        Integer ConCount = 0;
        For(Contact Con : result.contacts){
 
            ConCount++;
        }
        Account UpdatedAccount = New Account(Id = AccountId, Active_Contacts__c = ConCount);
        UpdatedAccounts.add(UpdatedAccount);
 
          }
          Update UpdatedAccounts;

        */

    }
}
