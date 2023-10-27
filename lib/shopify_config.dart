import 'package:graphql_flutter/graphql_flutter.dart';

class ShopifyConfig {
  /// Your own unique access key found on your Shopify dashboard under apps -> manage private apps -> your-app-name .
  static String? _storefrontAccessToken;

  /// Your own unique access key found on your Shopify dashboard under apps -> manage private apps -> your-app-name .
  static String? _adminAccessToken;

  /// Your store url.
  ///
  /// eg: "shopname.myshopify.com"
  static String? _storeUrl;

  /// Your store url.
  static String? get storeUrl => _storeUrl;

  /// The version of the Storefront API.
  static String _storefrontApiVersion = '';

  /// The GraphQlClient used for communication with the Storefront API.
  static GraphQLClient? _graphQLClient;

  /// The GraphQlClient used for communication with the Storefront API.
  static GraphQLClient? get graphQLClient => _graphQLClient;

  /// The GraphQlClient used for communication with the Storefront API.
  static GraphQLClient? _graphQLClientAdmin;

  /// The GraphQlClient used for communication with the Storefront API.
  static GraphQLClient? get graphQLClientAdmin => _graphQLClientAdmin;

  /// The Storefront API Version.
  static String get apiVersion => _storefrontApiVersion;

  /// Sets the config.
  ///
  /// IMPORTANT: preferably call this inside the main function or at least before instantiating other Shopify classes.
  ///
  /// [adminAccessToken] is optional, but required for some admin API calls like deleteCustomer.
  static void setConfig({
    required String storefrontAccessToken,
    required String storeUrl,
    String? adminAccessToken,
    String storefrontApiVersion = "2023-07",
  }) {
    _storefrontAccessToken = storefrontAccessToken;
    _adminAccessToken = adminAccessToken;
    _storeUrl = !storeUrl.contains('http') ? 'https://$storeUrl' : storeUrl;
    _storefrontApiVersion = storefrontApiVersion;
    _graphQLClient = GraphQLClient(
      link: HttpLink(
        '$_storeUrl/api/$_storefrontApiVersion/graphql.json',
        defaultHeaders: {
          'X-Shopify-Storefront-Access-Token': _storefrontAccessToken!,
          //'X-Shopify-Customer-Access-Token': _customerAccessToken ?? "", //Delete if not work
        },
      ),
      cache: GraphQLCache(),
    );

    _graphQLClientAdmin = _adminAccessToken == null
        ? null
        : GraphQLClient(
            link: HttpLink(
              '$_storeUrl/admin/api/$_storefrontApiVersion/graphql.json',
              defaultHeaders: {
                'X-Shopify-Access-Token': _adminAccessToken!,
              },
            ),
            cache: GraphQLCache(),
          );
  }
}
