public inherited sharing class lwnReadCsvFileController {

    @AuraEnabled
    public static list<Sensor__c> readCSVFile(Id idContentDocument){
        list<Sensor__c> lstSensToInsert = new list<Sensor__c>();
        if(idContentDocument != null) {
            
            // getting File Data based on document id 
            ContentVersion objVersion = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =:idContentDocument];
            // split the file data
            list<String> lstCSVLines = objVersion.VersionData.toString().split('\n');

            //creating Basic Stations records
            List<Base_Station__c> createdBSRec = [SELECT Name, Id  From Base_Station__c];
            List<Base_Station__c> newBSRec = new List<Base_Station__c>();
            Set<String> uniqueSet = new Set<String>();
            for ( Integer i = 1; i < lstCSVLines.size(); i++ ) {
                integer coincidences = 0; 
                list<String> csvRowData = lstCSVLines[i].split(',');
                for ( Base_Station__c rec : createdBSRec ) {
                    if (csvRowData[0] == rec.Name) {
                        coincidences++;
                    }
                }
                if ( coincidences == 0 ) {
                    uniqueSet.add(csvRowData[0]);
                }
            }
            List<String> uniquelist = new List<String>(uniqueSet);
            for (integer i = 0; i < uniquelist.size() ; i++) {
                Base_Station__c newBS = new Base_Station__c(Name = uniquelist[i]);
                NewBSRec.add(newBS);
            }
            upsert newBSRec;
            

            //creating Sensor records
            for(Integer i = 1; i < lstCSVLines.size(); i++){
                Sensor__c objRec = new Sensor__c();
                list<String> csvRowData = lstCSVLines[i].split(',');
                string tempBase = csvRowData[0];
                objRec.Name = csvRowData[1];
                objRec.Base_Station__c = [SELECT Id From Base_Station__c Where Name = :tempBase ].id;
                objRec.Sensor_ID__c = integer.valueof(csvRowData[1]);
                objRec.Status__c = csvRowData[2];
                objRec.Sensor_Model__c = csvRowData[3];
                lstSensToInsert.add(objRec);
            }
                if(!lstSensToInsert.isEmpty()) {
                    List<Sensor__c> createdSenRec = [SELECT Name, Sensor_ID__c  From Sensor__c];
                    for (Sensor__c sens : lstSensToInsert ) {
                        integer coincidences = 0;
                        for (Sensor__c rec : createdSenRec ) {
                            if (sens.Sensor_ID__c == rec.Sensor_ID__c) {
                                sens.id = rec.id;
                                update sens;
                                coincidences++;
                            }
                        }
                        if ( coincidences == 0 ) {
                            insert sens;
                        }
                    }
                }
        }
        return lstSensToInsert;    
    }
}