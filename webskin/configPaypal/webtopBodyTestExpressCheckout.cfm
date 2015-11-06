<cfsetting enablecfoutputonly="true">

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin">

<cfparam name="url.paypalReturn" default="0">
<cfparam name="url.paypalCancel" default="0">

<cfparam name="url.token" default="">
<cfparam name="url.payerID" default="">

<cfset amount = 10>
<cfset currencycode = "AUD">


<cfoutput>

	<h1>PayPal Express Checkout Test</h1>

	<cfif application.fc.lib.paypal.hasConfiguration(endpointType="sandbox")>

		<p>This is a basic Paypal Express Checkout test form.</p>

		<cfif url.paypalReturn eq 0 AND url.paypalCancel eq 0>

			<p>
				It will use the <strong>Sandbox API Endpoint</strong> to perform a test <strong>$10.00</strong> transaction.
				A <strong>custom logo</strong> will be displayed and the <strong>buyer note</strong> and <strong>shipping</strong> options will be turned off.
			</p>
			<br>

			<cfset var stRequestData = {
				METHOD="SetExpressCheckout",
				PAYMENTREQUEST_0_DESC="Express Checkout Test Item",
				PAYMENTREQUEST_0_ITEMAMT=numberFormat(amount, "0.00"),
				PAYMENTREQUEST_0_AMT=numberFormat(amount, "0.00"),
				PAYMENTREQUEST_0_CURRENCYCODE=currencycode,
				PAYMENTREQUEST_0_PAYMENTACTION="Sale",
				ALLOWNOTE=0,
				NOSHIPPING=1,
				LOGOIMG="#(cgi.https neq "on")?"http":"https"#://#cgi.http_host##application.url.webtop#/images/brand.png",
				RETURNURL="#(cgi.https neq "on")?"http":"https"#://#cgi.http_host##application.fapi.fixURL(addvalues="paypalReturn=1")#",
				CANCELURL="#(cgi.https neq "on")?"http":"https"#://#cgi.http_host##application.fapi.fixURL(addvalues="paypalCancel=1")#"
			}>

			<pre>#application.fc.lib.paypal.outputRequestData(stRequestData)#</pre>
			<br>

			<cfset stResponse = application.fc.lib.paypal.makeAPIRequest(endpointType="sandbox", requestData=stRequestData)>

			<p>
				<a href="https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&useraction=commit&token=#stResponse.TOKEN#" style="border:none;">
					<img src="https://www.paypal.com/en_US/i/btn/btn_xpressCheckout.gif" style="margin-right:7px;">
				</a>
			</p>
			<br>

			<cfdump var="#stResponse#" expand="false" label="SetExpressCheckout response">

		<cfelseif url.paypalReturn eq 1 AND url.paypalCancel eq 0>

			<p><strong>PayPal Checkout was completed.</strong></p>
			<p>
				Token = #url.token#<br>
				Payer ID = #url.payerID#
			</p>

			<cfset var stRequestData = {
				METHOD="DoExpressCheckoutPayment",
				TOKEN=url.token,
				PAYERID=url.payerID,
				PAYMENTREQUEST_0_DESC="Express Checkout Test Item",
				PAYMENTREQUEST_0_ITEMAMT=numberFormat(amount, "0.00"),
				PAYMENTREQUEST_0_AMT=numberFormat(amount, "0.00"),
				PAYMENTREQUEST_0_CURRENCYCODE=currencycode,
				PAYMENTREQUEST_0_PAYMENTACTION="Sale"
			}>

			<!--- log api request --->
			<cfset logUUID = application.fc.lib.paypal.logAPIRequest(endpointType="sandbox", description="PayPal Express Checkout Test", requestData=stRequestData)>

			<!--- make the api request --->
			<cfset stResponse = application.fc.lib.paypal.makeAPIRequest(endpointType="sandbox", requestData=stRequestData)>

			<!--- log api response --->
			<cfset application.fc.lib.paypal.logAPIResponse(endpointType="sandbox", objectid=logUUID, responseData=stResponse)>

			<p>
				<strong>Result: #stResponse.ACK#</strong><br>
			</p>
			<br>

			<cfdump var="#stResponse#" expand="false" label="DoExpressCheckoutPayment response">

		<cfelseif url.paypalCancel eq 1>

			<p><strong>PayPal Checkout was cancelled.</strong></p>
			<p>
				Token = #url.token#
			</p>

		</cfif>

		<br>

	<cfelse>
		<p>Before you can test Sandbox payments, you need to add the Sandbox API Credentials to the PayPal Express Checkout config (Admin -> General Admin -> Configuration).</p>
	</cfif>

</cfoutput>

<cfsetting enablecfoutputonly="false">