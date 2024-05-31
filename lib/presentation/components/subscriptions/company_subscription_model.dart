import 'package:shuffle_components_kit/domain/data_uimodels/subscription_offer_model.dart';

class UiCompanySubscriptionModel {
  final String companyName;
  final String? nicheIconPath;
  final String nicheTitle;
  final String? companyLogoLink;
  final List<SubscriptionOfferModel> offers;
  final SubscriptionOfferModel? selectedInitialOffer;
  final String? offersTitle;
  final String termsOfServiceUrl;
  final String privacyPolicyUrl;

  UiCompanySubscriptionModel({
    required this.companyName,
    required this.nicheTitle,
    this.nicheIconPath,
    this.companyLogoLink,
    required this.offers,
    this.offersTitle,
    this.selectedInitialOffer,
    required this.termsOfServiceUrl,
    required this.privacyPolicyUrl,
  });
}
