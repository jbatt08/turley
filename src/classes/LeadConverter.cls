Public class LeadConverter
{
    @invocableMethod
    public static void LeadAssign(List<id> LeadIds){
        LeadStatus ConvertedLeadStatus = [SELECT id, MasterLabel From LeadStatus Where isConverted = true limit 1];
        List<Database.LeadConvert> lstConvert = new List<Database.LeadConvert>();
        
        for(id currentlead: LeadIds){
            Database.LeadConvert convertLead = new Database.LeadConvert();
            convertLead.setLeadId(currentlead);
            convertLead.setConvertedStatus(ConvertedLeadStatus.MasterLabel);
            lstConvert.add(convertLead);
        }
        
         if(!lstConvert.isEmpty()){
            List<Database.LeadConvertResult> ConvertedLeads = Database.convertLead(lstConvert);       
        }
       
        
       
    }
    
    
    }