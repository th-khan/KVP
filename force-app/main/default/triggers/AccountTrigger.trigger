trigger AccountTrigger on Account(before insert, before update){
    
    if(trigger.isInsert && trigger.isBefore){

			Set<id> accountIds = new Set<Id>();
            Set<Id> existingId = new Set<id>();
            List<Contact> newContacts = new List<Contact>();
            for(Account a: trigger.new){
                if(a.Type == 'Customer' && a.Active__c){
                    accountIds.add(a.Id);
                }
            }
            
            List<Contact> contactList = [select id, Name, AccountId from Contact where AccountId in: accountIds];
            for(Contact c: contactList){
                existingId.add(c.AccountId);
            }
            
            for(Account a: trigger.new){
                if(!existingId.contains(a.Id)){
                    Contact c = new Contact();
                    c.FirstName = 'a.Name';
                    c.AccountId = a.Id;
                    c.LastName ='Customer Representative' + a.Name;
                    c.Phone = a.Phone;
                    newContacts.add(c);
                    
                }
            }
            if(!newContacts.isEmpty()){
                insert newContacts;
            }

        
        
    }
    
    if(trigger.isUpdate && trigger.isBefore){

        List<Contact> conList = [select id, LastName from Contact where AccountId in: trigger.newmap.keySet()];
        List<Contact> newList = new List<Contact>();
        Set<Id> accountIdWithContact = new Set<Id>();
        
        for(Contact c: conList){
            accountIdWithContact.add(c.AccountId);
        }
        
        for(Account a: trigger.new){
            if(a.Active__c && !accountIdWithContact.contains(a.Id) && a.Account_Activation_Summary__c != null){
                system.debug('validation success');
                Contact c = new Contact();
 				c.AccountId = a.Id;
				c.LastName ='Customer Representative ' + a.Name;
				newList.add(c);
            }
        }
        if(!newList.isEmpty()){
            insert newList;
        }
        
    }
    
}