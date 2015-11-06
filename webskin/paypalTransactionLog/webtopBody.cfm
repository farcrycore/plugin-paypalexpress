<cfsetting enablecfoutputonly="true">

<cfimport taglib="/farcry/core/tags/formtools" prefix="ft">


<cfset aColumns = listToArray("description,method,ack,correlationID,transactionID,datetimelastupdated")>
<cfset aColumns[5] = structNew()>
<cfset aColumns[5].name = "transactionID">
<cfset aColumns[5].webskin = "cellTransactionID">
<cfset aColumns[5].title = "Transaction ID">


<ft:objectAdmin
	title="PayPal Transaction Log"
	typename="paypalTransactionLog"
	aCustomColumns="#aColumns#"
	columnList="description,method,ack,correlationID,datetimelastupdated"
	sortableColumns=""
	lFilterFields="description,correlationID,transactionID"
	sqlorderby="datetimelastupdated DESC"
	bPreviewCol="false"
	plugin="paypalexpress" />


<cfsetting enablecfoutputonly="false">