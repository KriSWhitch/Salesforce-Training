@isTest
public class IwnReadCsvFileControllerTest {    
    public static String str = 'BASE STATION,SENSOR ID,STATUS,SENSOR MODEL \n' +
        'Leeds,1,Enabled ,R8 \n' +
        'Glasgow Central,2,Enabled,R8';
@isTest
    public static void testIdLoadSuccesfull(){
    Base_Station__c newBS = new Base_Station__c(Name = 'Leeds');
    upsert newBS;
    Sensor__c newSensor = new Sensor__c (Name = '1', Sensor_Id__c = 1, Status__c = 'Enabled', Base_Station__c = newBs.id);
    insert newSensor;
    ContentVersion contentVersionInsert = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.csv',
            VersionData = Blob.valueOf(str),
            IsMajorVersion = true
    );
    insert contentVersionInsert;
    Id getId = [Select ContentDocumentId From ContentVersion Where Id =:contentVersionInsert.id and isLatest=true].ContentDocumentId;
    List<Sensor__c> result = lwnReadCsvFileController.readCSVFile(getId);
}
    
@isTest
public static void testIdLoadFailed(){
    List<Sensor__c> result = lwnReadCsvFileController.readCSVFile(null);
}
    
}