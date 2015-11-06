<cfsetting enablecfoutputonly="true">
<!--- @@displayname: PayPal Details --->

<cfif len(stObj.transactionID)>
	<cfset stTransaction = application.fc.lib.paypal.getTransactionDetails(transactionID=stObj.transactionID)>

	<cfoutput>
		<h2>PayPal Transaction ID #stObj.transactionID#</h2>
		<pre>#application.fc.lib.paypal.outputRequestData(stTransaction)#</pre>
	</cfoutput>

<cfelse>
	<cfoutput>Transaction ID not found.</cfoutput>
</cfif>

<cfsetting enablecfoutputonly="false">