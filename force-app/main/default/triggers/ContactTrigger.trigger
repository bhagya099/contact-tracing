trigger ContactTrigger on Contact (after insert, after update, after delete, after undelete) {
    switch on Trigger.operationType {
        when  AFTER_INSERT{
            List<Account> accounts = new List<Account>();
            Set<Id> accountIds = new Set<Id>();
            for(Contact con: Trigger.new) {
                
                if(String.isNotBlank(con.AccountId)) {
                    accountIds.add(con.AccountId);
                    
                }

            }
            List<AggregateResult> results = [SELECT AccountId, COUNT(Id) totalContacts 
                                                    FROM Contact 
                                                    WHERE Active__c = true 
                                                    AND AccountId IN : accountIds
                                                    GROUP BY AccountID];

             for(AggregateResult result:results) {
                    String accId = String.valueOf(result.get('AccountId'));
                    Integer totalContacts = Integer.valueOf(result.get('totalContacts'));
                    Account acc = new Account(Id = accId, Active_Contacts__c = totalContacts);
                    accounts.add(acc);

                    //  another way
                    // accounts.add(new Account(Id = accId, Active_Contacts__c = totalContacts));
            }
            update accounts;                                        
            
        }
        
    }
}