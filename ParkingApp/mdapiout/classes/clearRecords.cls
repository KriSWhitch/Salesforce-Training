public class clearRecords {
    public static void clear() {
        List<Sensor__c> accs = new List<Sensor__c>();
        accs = [SELECT Name From Sensor__c];
        delete accs;
    }
}
