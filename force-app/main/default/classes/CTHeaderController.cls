public with sharing class CTHeaderController {
    @AuraEnabled
    public static Map<String, Integer> getPersonHealthStatuscount(){
        return CTPersonController.getHealthStatusCount();
    }
     @AuraEnabled
    public static Map<String,Integer>  getLocationHealthStatuscount(){
        return CTLocationController.getHealthStatusCount();
    }
   
}
