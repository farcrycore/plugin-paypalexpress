<cfcomponent displayname="PayPal Transaction Log" extends="farcry.core.packages.types.types" output="false">

	<!--- endpoint --->

	<cfproperty name="endpointType" type="string"
		ftSeq="1" ftWizardStep="Status" ftFieldset="Endpoint" ftLabel="Endpoint Type">

	<!--- common request properties --->

	<cfproperty name="method" type="string"
		ftSeq="11" ftWizardStep="Status" ftFieldset="Status" ftLabel="Method">

	<cfproperty name="token" type="string"
		ftSeq="12" ftWizardStep="Status" ftFieldset="Status" ftLabel="Token">

	<cfproperty name="payerID" type="string"
		ftSeq="13" ftWizardStep="Status" ftFieldset="Status" ftLabel="PayerID">

	<!--- common response properties --->

	<cfproperty name="ack" type="string"
		ftSeq="21" ftWizardStep="Status" ftFieldset="Status" ftLabel="ACK">

	<cfproperty name="correlationID" type="string"
		ftSeq="22" ftWizardStep="Status" ftFieldset="Status" ftLabel="Correlation ID">

	<cfproperty name="timestamp" type="string"
		ftSeq="23" ftWizardStep="Status" ftFieldset="Status" ftLabel="Timestamp">

	<cfproperty name="version" type="string"
		ftSeq="24" ftWizardStep="Status" ftFieldset="Status" ftLabel="Version">

	<cfproperty name="build" type="string"
		ftSeq="25" ftWizardStep="Status" ftFieldset="Status" ftLabel="Build">

	<!--- other response properties --->

	<cfproperty name="transactionID" type="string"
		ftSeq="31" ftWizardStep="Status" ftFieldset="Status" ftLabel="Transaction ID">

	<!--- custom properties --->

	<cfproperty name="invoiceNo" type="string"
		ftSeq="35" ftWizardStep="Status" ftFieldset="Status" ftLabel="Invoice Number">

	<cfproperty name="description" type="string"
		ftSeq="36" ftWizardStep="Status" ftFieldset="Status" ftLabel="Description">

	<cfproperty name="relatedTypename" type="string"
		ftSeq="41" ftWizardStep="Status" ftFieldset="Status" ftLabel="Related Typename">

	<cfproperty name="relatedObjectUUID" type="string"
		ftSeq="42" ftWizardStep="Status" ftFieldset="Status" ftLabel="Related Object">

	<!--- full request data --->

	<cfproperty name="requestData" type="longchar"
		ftSeq="51" ftWizardStep="Request" ftFieldset="Request" ftLabel="Request Data" ftShowLabel="false"
		ftType="longchar" ftLabelAlignment="block" ftEditMethod="ftDisplayRequestResponseData">

	<!--- full response data --->

	<cfproperty name="responseData" type="longchar"
		ftSeq="61" ftWizardStep="Response" ftFieldset="Response" ftLabel="Response Data" ftShowLabel="false"
		ftType="longchar" ftLabelAlignment="block" ftEditMethod="ftDisplayRequestResponseData">


	<!--- formtool methods --->

	<cffunction name="ftDisplayRequestResponseData" access="public" output="true" returntype="string" hint="This will return a string of formatted HTML text to enable the user to edit the data">
		<cfargument name="typename" required="true" type="string" hint="The name of the type that this field is part of.">
		<cfargument name="stObject" required="true" type="struct" hint="The object of the record that this field is part of.">
		<cfargument name="stMetadata" required="true" type="struct" hint="This is the metadata that is either setup as part of the type.cfc or overridden when calling ft:object by using the stMetadata argument.">
		<cfargument name="fieldname" required="true" type="string" hint="This is the name that will be used for the form field. It includes the prefix that will be used by ft:processform.">

		<cfset var html = "None" />
		<cfset var aData = "" />

		<cfif len(arguments.stMetadata.value) AND isJSON(arguments.stMetadata.value)>
			<cfsavecontent variable="html"><cfoutput>
				<div class="multiField">
					<pre>#application.fc.lib.paypal.outputRequestData(deserializeJSON(arguments.stMetadata.value))#</pre>
				</div>
			</cfoutput></cfsavecontent>
		</cfif>

		<cfreturn html>
	</cffunction>


</cfcomponent>