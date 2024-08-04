import { api, LightningElement, track } from 'lwc';

export default class ZipCodeResponse extends LightningElement {
    @api response; // passed from parent component
    showError;
    places;
    connectedCallback() {
        if (this.response?.statusCode != 200) {
            this.showError = true;
        }
        // console.log(this.response?.places[0]);
        // this.places = this.response?.places;
        // console.log(this.places);

        // this.response?.places?.array.forEach(element => {
        //     this.state = element.state;
        //     this.stateAbbreviation = element.stateAbbreviation;
        //     this.placeName = element.placeName;
        // });

    }
}