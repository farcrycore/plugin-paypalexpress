<cfcomponent displayname="PayPal Express Checkout" extends="farcry.core.packages.forms.forms" output="false"
	key="paypal" hint="Configuration for PayPal Express Checkout / In-Context Checkout">

	<!--- endpoint --->

	<cfproperty name="endpointType" type="string"
		ftSeq="1" ftFieldset="PayPal API Endpoint" ftLabel="API Endpoint"
		ftType="list" ftList="sandbox:Sandbox API Endpoint,live:Live API Endpoint"
		ftDefault="live" default="live"
		ftHint="The default endpoint to use when making API requests">

	<!--- live --->

	<cfproperty name="liveUsername" type="string"
		ftSeq="10" ftFieldset="Live API Credentials" ftLabel="Username">

	<cfproperty name="livePassword" type="string"
		ftSeq="11" ftFieldset="Live API Credentials" ftLabel="Password">

	<cfproperty name="liveSignature" type="string"
		ftSeq="12" ftFieldset="Live API Credentials" ftLabel="Signature">

	<cfproperty name="liveMerchantID" type="string"
		ftSeq="13" ftFieldset="Live API Credentials" ftLabel="Merchant ID">

	<!--- sandbox --->

	<cfproperty name="sandboxUsername" type="string"
		ftSeq="20" ftFieldset="Sandbox API Credentials" ftLabel="Username">

	<cfproperty name="sandboxPassword" type="string"
		ftSeq="21" ftFieldset="Sandbox API Credentials" ftLabel="Password">

	<cfproperty name="sandboxSignature" type="string"
		ftSeq="22" ftFieldset="Sandbox API Credentials" ftLabel="Signature">

	<cfproperty name="sandboxMerchantID" type="string"
		ftSeq="23" ftFieldset="Sandbox API Credentials" ftLabel="Merchant ID">

	<!--- proxy --->

	<cfproperty name="proxy" type="string"
		ftSeq="30" ftFieldset="Proxy" ftLabel="Proxy"
		ftHint="The proxy to use for API requests, in the format of <code>[username:password@]hostname[:port]</code>" />

</cfcomponent>