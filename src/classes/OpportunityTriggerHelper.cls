public class OpportunityTriggerHelper{
     public static void doCreateOpportunity(Object[] newTrigger){
         List<Opportunity> lstOppties = (List<Opportunity>) newTrigger;
         List<Subscription__c> lstSubscriptions = new List<Subscription__c>();
         List<Id> lstOpportunityIds = new List<Id>();
         List<Id> lstAccountIds = new List<Id>();
         //Key: OpportunityId
         Map<Id, Subscription__c> mapSubscriptionsToOpportunityId = new Map<Id, Subscription__c>();
         //Key: Subscription Id
         Map<Id, Opportunity> mapOpportunityToSubscriptionId = new Map<Id, Opportunity>();
         //Key: Account Id
         Map<Id, Opportunity> mapTriggerOpportunitiesToAccountId = new Map<Id, Opportunity>();
         Boolean createOpportunity = true;
         String closedWon = 'Closed Won';
         String needUtil = 'Need Utility Information';
         String errorMsg = 'Oops! You cannot create an opportunity with active an Subscription on the Account.';
                        
         for(Opportunity opp: lstOppties ){
             lstAccountIds.add(opp.AccountId);
              if(!mapTriggerOpportunitiesToAccountId .containsKey(opp.AccountId)) {
                    mapTriggerOpportunitiesToAccountId .put(opp.AccountId, opp);
                }
         }
         
         lstSubscriptions = [SELECT 
             Id, Active__c, Subscription_Start_Date__c, Subscription_End_Date__c,
             Opportunity_Product__c, Opportunity__c, Account__c 
             FROM Subscription__c
             WHERE Account__c =: lstAccountIds
         ];
         
         if(!lstSubscriptions.isEmpty()){
             for(Subscription__c sub: lstSubscriptions ){    
                lstOpportunityIds.add(sub.Opportunity__c);
                if(!mapSubscriptionsToOpportunityId.containsKey(sub.Opportunity__c)) {
                    mapSubscriptionsToOpportunityId.put(sub.Opportunity__c, sub);
                }
             }
             
             List<Opportunity> existingOpportunity = [SELECT Id, CloseDate, StageName, AccountId FROM Opportunity WHERE id =: lstOpportunityIds];
             
             if(!existingOpportunity.isEmpty()){
                 for(Opportunity opp: existingOpportunity ){
                      Subscription__c sub = mapSubscriptionsToOpportunityId.get(opp.Id);
                      if(!mapOpportunityToSubscriptionId.containsKey(sub.Id)) {
                        mapOpportunityToSubscriptionId.put(sub.Id, Opp);
                    }
                 }
             }
             
         
             for(Id subcriptionId: mapOpportunityToSubscriptionId.keySet()){
                 Opportunity existingOppty = mapOpportunityToSubscriptionId.get(subcriptionId); 
                 Subscription__c sub = mapSubscriptionsToOpportunityId.get(existingOppty.Id);
                 if(sub.Active__c == true 
                 && (existingOppty.StageName == closedWon 
                     || existingOppty.StageName == needUtil)
                 ){
                    Opportunity newOpportunity = mapTriggerOpportunitiesToAccountId.get(existingOppty.AccountId);
                    newOpportunity.addError(errorMsg);
                 }
                 
             }
         }
         
     }
     
}