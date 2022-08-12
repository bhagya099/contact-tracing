public with sharing class CTRecentChangesController {
  @AuraEnabled
  public static List<Person__c> getRecentPersonHealthChnages(){
      return CTPersonController.getRecentHealthChanges();
  }

  @AuraEnabled
  public static List<Location__c> getRecentLocationHealthChnages(){
    return CTLocationController.getRecentStatusChanges();
  }

  @AuraEnabled
  public static List<Person__c> searchPeople(String searchTerm){
    return CTPersonController.searchPeople(searchTerm);
  }

  @AuraEnabled
  public static List<Location__c> searchLocation(String searchTerm){
    return CTLocationController.searchLocation(searchTerm);
  }
}
