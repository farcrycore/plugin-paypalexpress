<cfsetting enablecfoutputonly="true">
<!--- @@displayname: Transaction ID Cell --->

<cfif len(stObj.transactionID)>
	<cfoutput><a href="##" onclick="$fc.objectAdminAction('PayPal Transaction', '#application.fapi.getLink(objectid=stObj.objectid,type=stobj.typename,view='webtopPageModal',bodyView='webtopOverviewTabPaypal')#');return false;">#stObj.transactionID#</a></cfoutput>
</cfif>

<cfsetting enablecfoutputonly="false">