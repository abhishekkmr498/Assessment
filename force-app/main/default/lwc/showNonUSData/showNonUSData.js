import { LightningElement, track, wire } from 'lwc';
import getNonUSZipcodeResponses from '@salesforce/apex/ZipCodeController.getNonUSZipcodeResponses';

const columns = [
    { label: 'Country ', fieldName: 'Country__c', type: 'text' },
    { label: 'Country Abbreviation', fieldName: 'Country_Abbreviation__c', type: 'text' },
    { label: 'Zip Code', fieldName: 'PostCode__c', type: 'text' },
    { label: 'State Name', fieldName: 'State_Name__c', type: 'text' },
    { label: 'Created Date', fieldName: 'CreatedDate', type: 'datetime' }
];

export default class showNonUSData extends LightningElement {
    @track nonUSResults;
    @track columns = columns;

    @wire(getNonUSZipcodeResponses)
    wiredResponses({ error, data }) {
        if (data) {
            this.nonUSResults = data;
        } else if (error) {
            this.nonUSResults = undefined;
            console.error('Error:', error);
        }
    }

    renderedCallback(){
        getNonUSZipcodeResponses()
        .then(result => {
            this.nonUSResults = result;
        })
        .catch(error => {
            this.nonUSResults = undefined;
            console.error('Error:', error);
        });
    }
}