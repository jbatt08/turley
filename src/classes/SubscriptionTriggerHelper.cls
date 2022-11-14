public class SubscriptionTriggerHelper {
    public static void CreateSubscription(Object[] newTrigger){
        List<Subscription__c> lstSubscriptions = (List<Subscription__c>) newTrigger;
        List<Subscription__c> SubscriptionToUpdate = new List<Subscription__c>();
        List<Id> subIds = new List<Id>();
        
        Map<Id, List<OpportunityLineItemSchedule>> productToSchedule = new Map<Id, List<OpportunityLineItemSchedule>>();
        Map<Id, Subscription__c> mapSubscriptions = new Map<Id, Subscription__c>();
      
        try{  
        for(Subscription__c subcription: lstSubscriptions){
            if(Subcription.Opportunity_Product__c != null){
                subIds.add(Subcription.Opportunity_Product__c);          
                if(!mapSubscriptions.containsKey(Subcription.Opportunity_Product__c)) {
                    mapSubscriptions.put(subcription.Opportunity_Product__c, subcription);
                } 
                
            }
        }
        List<OpportunityLineItemSchedule> schedules = [Select Id, ScheduleDate, OpportunityLineItemId 
            FROM OpportunityLineItemSchedule  
            WHERE OpportunityLineItemId =: subIds  
            ];
            
        if(!schedules.isEmpty()){
            for(OpportunityLineItemSchedule lineItemSched : schedules){
                                
                if(productToSchedule.containsKey(lineItemSched.OpportunityLineItemId)) {
                    List<OpportunityLineItemSchedule> lineItemScheduleRecords = productToSchedule.get(lineItemSched.OpportunityLineItemId);
                    lineItemScheduleRecords.add(lineItemSched);
                    productToSchedule.put(lineItemSched.OpportunityLineItemId, lineItemScheduleRecords);
                } else {
                    productToSchedule.put(lineItemSched.OpportunityLineItemId, new List<OpportunityLineItemSchedule>{lineItemSched});
                }
                
            }
        }
        
        for (Id key : productToSchedule.keySet()) {
            List<Date> effectivityDates = new List<Date>();
            List<OpportunityLineItemSchedule> optyLineItems = productToSchedule.get(key);
            for(OpportunityLineItemSchedule lineItemSched : optyLineItems ){
                effectivityDates.add(lineItemSched.ScheduleDate);
            }
            
            effectivityDates.sort();
            Date endDate = effectivityDates.get(effectivityDates.size() - 1);
            
            
            Subscription__c sub = mapSubscriptions.get(key);
            sub.Active__c = true;
            sub.Opportunity_Product__c = optyLineItems[0].OpportunityLineItemId;
            sub.Subscription_Start_Date__c = effectivityDates[0];
            sub.Subscription_End_Date__c = endDate;
            SubscriptionToUpdate.add(sub);
        }
        
        } catch(exception ex){system.debug('User Debug ' + ex.getMessage());}   
    }
}