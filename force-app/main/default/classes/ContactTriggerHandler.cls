public with sharing class ContactTriggerHandler {

    public static void afterInsertHandler(List<Contact> newcontact) {
        Set<Id> accountIds = new Set<Id>();
        for(Contact con: newcontact) {
            
            if(String.isNotBlank(con.AccountId)) {
                accountIds.add(con.AccountId);
                
            }

        }
        AccountContactService.updateActiveContact(accountIds);
    }

    public static void afterUpdateHandler(List<Contact> newcontact, Map<Id,Contact> oldContactMap) {
        Set<Id> accountIds =new Set<Id>();
           
            for(Contact con:newcontact) {
                if (String.isNotBlank(con.AccountId) && oldContactMap.get(con.Id).Active__c != con.Active__c) {
                            accountIds.add(con.AccountId);
                } else if(oldContactMap.get(con.Id).AccountId != con.AccountId) {
                    accountIds.add(con.AccountId);
                    accountIds.add(oldContactMap.get(con.Id).AccountId);
                }
            } 

            AccountContactService.updateActiveContact(accountIds);
    }

    public static void afterDeleteHandler(List<Contact> oldContacts) {
        Set<Id> accountIds = new Set<Id>();
        for(Contact con: oldContacts) {
            
            if(String.isNotBlank(con.AccountId)) {
                accountIds.add(con.AccountId);
                
            }

        }
        AccountContactService.updateActiveContact(accountIds);
    }


    public static void afterUnDeleteHandler(List<Contact> newContacts) {
        Set<Id> accountIds = new Set<Id>();
        for(Contact con: newcontact) {
            
            if(String.isNotBlank(con.AccountId)) {
                accountIds.add(con.AccountId);
                
            }

        }
        AccountContactService.updateActiveContact(accountIds);
    }
}
