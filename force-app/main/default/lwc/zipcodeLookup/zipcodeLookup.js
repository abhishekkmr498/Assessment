import { LightningElement, track, wire } from 'lwc';
import saveNonUSZipcodeResponse from '@salesforce/apex/ZipCodeController.saveNonUSZipcodeResponse';
import doZipLookup from '@salesforce/apex/ZipCodeController.doZipLookupCallout';
import getPickListValues from '@salesforce/apex/ZipCodeController.getPickListValues';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ZipcodeLookup extends LightningElement {
    @track zipcode = '';
    @track country = 'IN';
    @track zipLookupResponse;
    showLoader = false;
    @track picklistValues;
    nonUSresults;

    //add toast message for error
    // add red message for no search found
    // add save non US response 
    // display datatable for non us data

    //on select of country value
    handleCountryChange(event) {
        this.country = event.target.value;
    }

    // on change of zip code 
    handleZipcodeChange(event) {
        this.zipcode = event.target.value;
    }

    //getting country values from picklist to allow dynamic url 
    @wire(getPickListValues, { customObjInfo: 'Contact', selectPicklistApi: 'OtherCountryCode' })
    wiredPicklistValues({ error, data }) {
        if (data) {
            console.log(data);
            this.picklistValues = data.map(item => {
                return { label: item.custFldlabel, value: item.custFldvalue };
            });
        } else if (error) {
            console.error('Error:', error);
        }
    }

    //Method to do callout 
    lookupZipcode() {
        //form validity 
        //console.log(this.checkFormValidity());
        if (!this.checkFormValidity()) {
            this.showErrorToast('Error', 'Please select country & enter zip code to search.', 'error', 'sticky');
            return;
        }

        //initiate loader
        this.showLoader = true;

        //reset response
        this.zipLookupResponse = null;
        this.nonUSresults=false;

        //call apex to do callout from named credentials
        doZipLookup({ country: this.country, zipCode: this.zipcode })
            .then(result => {
                console.log(result);
                this.zipLookupResponse = JSON.parse(result);
                console.log(this.zipLookupResponse);
                this.showLoader = false;

                //if non-us data save in object
                if(this.zipLookupResponse?.countryAbbreviation!=undefined 
                    && this.zipLookupResponse?.countryAbbreviation!=null 
                    && this.zipLookupResponse?.countryAbbreviation!="US"){

                    this.storeNonUSData(result);
                }
            })
            .catch(error => {
                this.showLoader = false;
                console.log('Errorured:- ' + error);
            });
    }

    //Method to save non us response
    storeNonUSData(data) {
        console.log('storeNonUSData',data);
        // Call Apex method to save data in a custom object
        saveNonUSZipcodeResponse({response: data})
        .then(result => {
            console.log('Data saved successfully',result);
            this.showErrorToast('Success',result, 'success', 'dismissable');
            this.nonUSresults=true;

        })
        .catch(error => {
            this.showErrorToast('Error',error, 'error', 'dismissable');
            console.error('Error:', error);
        });
    }
    //check form validity 
    checkFormValidity() {
        if (this.country == null || this.country == undefined || this.country == "" || this.zipcode == null || this.zipcode == undefined || this.zipcode == "") {
            return false;
        } else {
            return true;
        }
    }

    //variant error/success/warning/info
    showErrorToast(title, msg, variant, mode) {
        const evt = new ShowToastEvent({
            title: title,
            message: msg,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(evt);
    }
}