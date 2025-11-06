enum AdditionalService {
  wifi,
  tv,
  backgroundMusic,
  airConditioning,
  heating,
  coffeeTea,
  drinksSnacks,
  freeParking,
  paidParking,
  publicTransportAccess,
  wheelchairAccessible,
  childFriendly,
  shower,
  lockers,
  creditCardAccepted,
  mobilePayment,
  securityCameras,
  petFriendly,
  noPets,
  smokingAllowed,
  nonSmoking;


  static AdditionalService fromString(String value) {
    switch (value.toLowerCase().replaceAll(' ', '').replaceAll('_', '')) {
      case 'wifi':
        return AdditionalService.wifi;
      case 'tv':
        return AdditionalService.tv;
      case 'backgroundmusic':
        return AdditionalService.backgroundMusic;
      case 'airconditioning':
        return AdditionalService.airConditioning;
      case 'heating':
        return AdditionalService.heating;
      case 'coffeetea':
        return AdditionalService.coffeeTea;
      case 'drinkssnacks':
        return AdditionalService.drinksSnacks;
      case 'freeparking':
        return AdditionalService.freeParking;
      case 'paidparking':
        return AdditionalService.paidParking;
      case 'publictransportaccess':
        return AdditionalService.publicTransportAccess;
      case 'wheelchairaccessible':
        return AdditionalService.wheelchairAccessible;
      case 'childfriendly':
        return AdditionalService.childFriendly;
      case 'shower':
        return AdditionalService.shower;
      case 'lockers':
        return AdditionalService.lockers;
      case 'creditcardaccepted':
        return AdditionalService.creditCardAccepted;
      case 'mobilepayment':
        return AdditionalService.mobilePayment;
      case 'securitycameras':
        return AdditionalService.securityCameras;
      case 'petfriendly':
        return AdditionalService.petFriendly;
      case 'nopets':
        return AdditionalService.noPets;
      case 'smokingallowed':
        return AdditionalService.smokingAllowed;
      case 'nonsmoking':
        return AdditionalService.nonSmoking;
      default:
        throw ArgumentError('Invalid AdditionalService: $value');
    }
  }

  /// Pour sérialiser en JSON
  String toJson() => name;
}
