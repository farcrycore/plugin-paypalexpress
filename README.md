# PayPal Express Plugin

The PayPal Express Plugin is designed for [FarCry Core 7.0](http://www.farcrycore.org)
and above.

It supports the [PayPal Express Checkout][paypalexpresscheckout] product and
the more modern [In-Context Checkout][paypalincontextcheckout] option.

If you are looking for PayPal PayFlow Pro support to perform credit card
processing try the [PayFlow Pro Plugin][paypalplugin].


# Setup

1. Sign up for either a PayPal Business or [PayPal Personal account][paypalsignup]
   (you can use Personal accounts for Sandbox development but not for Live).
2. Install this plugin into `plugins/paypalexpress`, add `paypalexpress`
   to the `farcryConstructor.cfm` plugin list, and do an `updateall` to
   restart the application and deploy database schema changes.
3. Log in to the webtop and configure the plugin using your
   [Business account API Signature credentials][paypalcredentials] for Live
   or your [Developer account API Signature credentials][paypaldeveloperaccount]
   for the Sandbox;
   `Admin -> General Admin -> Configuration -> PayPal Express Checkout`
4. The `Username`, `Password` and `Signature` are requires for **Express Checkout**.
   For **In-Context Checkout** the `Merchant ID` (available from your PayPal
   profile page) is also required.
5. Check the PayPal API Status page in the webtop to see if your credentials
   are working;
   `Admin -> PayPal -> API Status`
6. Try testing the checkout process in the webtop using either the
   **Express Checkout** or **In-Context Checkout** pages (note: this requires
   the Sandbox credentials to be configured);
   `Admin -> PayPal -> Checkout Testing...`


# Development

There is an example **Sandbox** implementation of both the **Express Checkout**
and the **In-Context Checkout** which you can see in the following files;

- `plugins\paypalexpress\webskin\configPaypal\webtopBodyTestExpressCheckout.cfm`
- `plugins\paypalexpress\webskin\configPaypal\webtopBodyTestInContextCheckout.cfm`

A basic implementation of both checkout types will call 2 PayPal API methods;

1. `SetExpressCheckout` must be called with a payload that contains at least 1
   payment request and the cancel/return URLs, and upon success will return a
   `token` that can be used to initiate and confirm the transaction.
2. `DoExpressCheckoutPayment` must be called on the return URL to complete the
   transaction, by supplying the same `token` along with the `payerID` and the
   same payment request payload as the initial `SetExpressCheckout` request.

An API request can be made by supplying a request data struct to:
`application.fc.lib.paypal.makeAPIRequest()`

And endpoint type is optional (the examples always use the "sandbox" endpoint)
and in the absence of the `endpointType` parameter the default endpoint will
be used, as set in the PayPal Express Checkout configuration.

This is a portion of the request data struct showing the "payment request"
properties for a single AUD$10.00 test item:

    PAYMENTREQUEST_0_DESC="Express Checkout Test Item",
    PAYMENTREQUEST_0_ITEMAMT="10.00",
    PAYMENTREQUEST_0_AMT="10.00",
    PAYMENTREQUEST_0_CURRENCYCODE="AUD",
    PAYMENTREQUEST_0_PAYMENTACTION="Sale",

It is recommended to always log the API call payload before and after a
`DoExpressCheckoutPayment` API request to assist in debugging or reconciling
payments. There are two methods in the PayPal lib to assist;

- `application.fc.lib.paypal.logAPIRequest()` should be passed a `description`
  which describes the transaction and the `requestData` struct, and it will
  return a log UUID which can be used for updating the log with the response.
- `application.fc.lib.paypal.logAPIResponse()` should be passed the log UUID
  and the `responseData` struct.

The `logAPIRequest` method also accepts a related typename and UUID (objectid)
so that transactions can be related to another FarCry content object for easier
tracking.

The transaction log records can be viewed in the webtop, allowing you to see
the full request data and response data along with other useful properties;
`Admin -> PayPal -> Transaction Log`


[paypalplugin]: https://github.com/farcrycore/plugin-paypal
[paypalsignup]: https://www.paypal.com/signup/account
[paypalcredentials]: https://developer.paypal.com/docs/classic/api/apiCredentials/#creating-an-api-signature
[paypaldeveloperaccount]: https://developer.paypal.com/developer/accounts/
[paypalexpresscheckout]: https://developer.paypal.com/docs/classic/products/express-checkout/
[paypalincontextcheckout]: https://developer.paypal.com/docs/classic/express-checkout/in-context/

