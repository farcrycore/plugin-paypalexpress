<cfcomponent output="false">

	<!--- configuration helper methods --->

	<cffunction name="getEndpointURL" returntype="string" output="false">
		<cfargument name="endpointType" default="#application.fapi.getConfig('paypal', 'endpointType', '')#">

		<cfset var endpoint = "">

		<cfif arguments.endpointType eq "live">
			<cfset endpoint = "api-3t.paypal.com">
		<cfelseif arguments.endpointType eq "sandbox">
			<cfset endpoint = "api-3t.sandbox.paypal.com/nvp">
		</cfif>

		<cfreturn endpoint>
	</cffunction>

	<cffunction name="getEndpointUsername" returntype="string" output="false">
		<cfargument name="endpointType" default="#application.fapi.getConfig('paypal', 'endpointType', '')#">

		<cfset var username = application.fapi.getConfig("paypal", arguments.endpointType & "Username", "")>

		<cfreturn username>
	</cffunction>

	<cffunction name="getEndpointPassword" returntype="string" output="false">
		<cfargument name="endpointType" default="#application.fapi.getConfig('paypal', 'endpointType', '')#">

		<cfset var password = application.fapi.getConfig("paypal", arguments.endpointType & "Password", "")>

		<cfreturn password>
	</cffunction>

	<cffunction name="getEndpointSignature" returntype="string" output="false">
		<cfargument name="endpointType" default="#application.fapi.getConfig('paypal', 'endpointType', '')#">

		<cfset var signature = application.fapi.getConfig("paypal", arguments.endpointType & "Signature", "")>

		<cfreturn signature>
	</cffunction>

	<cffunction name="getEndpointMerchantID" returntype="string" output="false">
		<cfargument name="endpointType" default="#application.fapi.getConfig('paypal', 'endpointType', '')#">

		<cfset var merchantID = application.fapi.getConfig("paypal", arguments.endpointType & "MerchantID", "")>

		<cfreturn merchantID>
	</cffunction>

	<cffunction name="hasConfiguration" returntype="boolean" output="false">
		<cfargument name="endpointType" default="#application.fapi.getConfig('paypal', 'endpointType', '')#">

		<cfset bResult = true>

		<cfif NOT len(getEndpointURL(endpointType=arguments.endpointType))
			OR NOT len(getEndpointUsername(endpointType=arguments.endpointType))
			OR NOT len(getEndpointPassword(endpointType=arguments.endpointType))
			OR NOT len(getEndpointSignature(endpointType=arguments.endpointType))
			OR NOT len(getEndpointMerchantID(endpointType=arguments.endpointType))>

			<cfset bResult = false>

		</cfif>

		<cfreturn bResult>
	</cffunction>


	<!--- API request methods --->

	<cffunction name="makeAPIRequest" access="public" returntype="struct">
		<cfargument name="endpointType" type="string" required="false" default="#application.fapi.getConfig('paypal', 'endpointType')#">
		<cfargument name="endpointURL" type="string" required="false" default="#getEndpointURL(endpointType=arguments.endpointType)#">
		<cfargument name="username" type="string" required="false" default="#getEndpointUsername(endpointType=arguments.endpointType)#">
		<cfargument name="password" type="string" required="false" default="#getEndpointPassword(endpointType=arguments.endpointType)#">
		<cfargument name="signature" type="string" required="false" default="#getEndpointSignature(endpointType=arguments.endpointType)#">
		<cfargument name="proxy" type="string" required="false" default="#application.fapi.getConfig('paypal', 'proxy')#">
		<cfargument name="requestData" type="struct" required="true">

		<cfset var stAttributes = parseProxy(arguments.proxy)>
		<cfset var stHTTP = structnew()>
		<cfset var key = "">
		<cfset var wddx = "">

		<cfset arguments.requestData.USER = arguments.username>
		<cfset arguments.requestData.PWD = arguments.password>
		<cfset arguments.requestData.SIGNATURE = arguments.signature>
		<cfset arguments.requestData.SUBJECT = "">
		<cfset arguments.requestData.VERSION = "124.0">

		<cfhttp url="https://#arguments.endpointURL#" method="POST" timeout="60" result="stHTTP" attributeCollection="#stAttributes#">
			<cfloop collection="#arguments.requestData#" item="key">
				<cfhttpparam name="#key#" value="#arguments.requestData[key]#" type="FormField" encoded="YES">
			</cfloop>
		</cfhttp>

		<cfif not stHTTP.statuscode eq "200 OK">
			<cfwddx action="cfml2wddx" input="#arguments#" output="wddx">
			<cfthrow message="Error accessing API: #stHTTP.statuscode#" detail="#wddx#" extendedinfo="#stHTTP.filecontent#" type="api">
		<cfelse>
			<cfreturn getNVPResponse(stHTTP.FileContent)>
		</cfif>
	</cffunction>


	<!--- API helpers --->

	<cffunction name="searchTransactions" access="public" output="false" returntype="struct" hint="Searches transaction history for transactions that meet the specified criteria">
		<cfargument name="endpointType" type="string" required="false" default="#application.fapi.getConfig('paypal', 'endpointType')#">
		<cfargument name="endpointURL" type="string" required="false" default="#getEndpointURL(endpointType=arguments.endpointType)#">
		<cfargument name="username" type="string" required="false" default="#getEndpointUsername(endpointType=arguments.endpointType)#">
		<cfargument name="password" type="string" required="false" default="#getEndpointPassword(endpointType=arguments.endpointType)#">
		<cfargument name="signature" type="string" required="false" default="#getEndpointSignature(endpointType=arguments.endpointType)#">
		<cfargument name="proxy" type="string" required="false" default="#application.fapi.getConfig('paypal', 'proxy')#">

		<cfargument name="startDate" type="date" required="true">
		<cfargument name="endDate" type="date" required="false">
		<cfargument name="transactionID" type="string" required="false">
		<cfargument name="invoiceNo" type="string" required="false">
		<cfargument name="status" type="string" required="false" options="Pending,Processing,Success,Denied,Reversed">
		<cfargument name="firstname" type="string" required="false">
		<cfargument name="lastname" type="string" required="false">


		<cfset var stRequestData = structnew()>
		<cfset var stResponse = "">
		<cfset var key = "">
		<cfset var index = 0>


		<cfset stRequestData.METHOD = "TransactionSearch">
		<cfset stRequestData.STARTDATE = "#dateformat(arguments.startDate,'yyyy-mm-dd')#T#timeformat(arguments.startDate,'hh:mm:ss')#Z">

		<cfif structkeyexists(arguments,"endDate")>
			<cfset stRequestData.ENDDATE = "#dateformat(arguments.endDate,'yyyy-mm-dd')#T#timeformat(arguments.startDate,'hh:mm:ss')#Z">
		<cfelse>
			<cfset stRequestData.ENDDATE = "#dateformat(arguments.startDate,'yyyy-mm-dd')#T#timeformat(arguments.startDate,'hh:mm:ss')#Z">
		</cfif>

		<cfif structkeyexists(arguments,"transactionID")>
			<cfset stRequestData.TRANSACTIONID = arguments.transactionID>
		</cfif>

		<cfif structkeyexists(arguments,"invoiceNo")>
			<cfset stRequestData.INVNUM = arguments.invoiceNo>
		</cfif>

		<cfif structkeyexists(arguments,"status")>
			<cfset stRequestData.STATUS = arguments.status>
		</cfif>

		<cfif structkeyexists(arguments,"firstname")>
			<cfset stRequestData.FIRSTNAME = arguments.firstname>
		</cfif>

		<cfif structkeyexists(arguments,"lastname")>
			<cfset stRequestData.LASTNAME = arguments.lastname>
		</cfif>

		<cfset stResponse = makeAPIRequest(
			endpointURL=arguments.endpointURL,
			username=arguments.username,
			password=arguments.password,
			signature=arguments.signature,
			proxy=arguments.proxy,
			requestData=stRequestData)>

		<cfset stResponse = arrayify(stResponse,"errorcode,longmessage,severitycode,shortmessage","errors")>
		<cfset stResponse = arrayify(stResponse,"timestamp,timezone,type,email,name,transactionid,status,amt,currencycode,feeamt,netamt","transactions")>

		<cfreturn stResponse>
	</cffunction>


	<cffunction name="getTransactionDetails" access="public" output="false" returntype="struct" hint="Returns information about a specific transaction">
		<cfargument name="endpointType" type="string" required="false" default="#application.fapi.getConfig('paypal', 'endpointType')#">
		<cfargument name="endpointURL" type="string" required="false" default="#getEndpointURL(endpointType=arguments.endpointType)#">
		<cfargument name="username" type="string" required="false" default="#getEndpointUsername(endpointType=arguments.endpointType)#">
		<cfargument name="password" type="string" required="false" default="#getEndpointPassword(endpointType=arguments.endpointType)#">
		<cfargument name="signature" type="string" required="false" default="#getEndpointSignature(endpointType=arguments.endpointType)#">
		<cfargument name="proxy" type="string" required="false" default="#application.fapi.getConfig('paypal', 'proxy')#">

		<cfargument name="transactionID" type="string" required="true">

		<cfset var stRequestData = structnew()>
		<cfset var stResponse = structnew()>

		<cfset stRequestData.METHOD = "GetTransactionDetails">
		<cfset stRequestData.TRANSACTIONID = arguments.transactionID>

		<cfset stResponse = makeAPIRequest(
			endpointURL=arguments.endpointURL,
			username=arguments.username,
			password=arguments.password,
			signature=arguments.signature,
			proxy=arguments.proxy,
			requestData=stRequestData)>

		<cfreturn stResponse>
	</cffunction>


	<!--- logging --->

	<cffunction name="logAPIRequest" access="public" output="false" returntype="string">
		<cfargument name="requestData" type="struct" required="true">

		<cfargument name="description" type="string" required="false" default="">
		<cfargument name="invoiceNo" type="string" required="false" default="">
		<cfargument name="relatedTypename" type="string" required="false" default="">
		<cfargument name="relatedObjectUUID" type="string" required="false" default="">

		<cfargument name="objectid" type="uuid" required="false" default="#createUUID()#">
		<cfargument name="endpointType" type="string" required="false" default="#application.fapi.getConfig('paypal', 'endpointType')#">

		<cfset var stRequestData = duplicate(arguments.requestData)>
		<cfset var oLog = application.fapi.getContentType(typename="paypalTransactionLog")>
		<cfset var stLog = structNew()>

		<cfset stLog.typename = "paypalTransactionLog">
		<cfset stLog.objectid = arguments.objectid>
		<cfset stLog.endpointType = arguments.endpointType>
		<cfset stLog.requestData = serializeJSON(arguments.requestData)>

		<cfparam name="stRequestData.method" default="">
		<cfparam name="stRequestData.token" default="">
		<cfparam name="stRequestData.payerID" default="">

		<!--- common request properties --->
		<cfset stLog.method = stRequestData.method>
		<cfset stLog.token = stRequestData.token>
		<cfset stLog.payerID = stRequestData.payerID>

		<!--- custom properties --->
		<cfset stLog.description = arguments.description>
		<cfset stLog.invoiceNo = arguments.invoiceNo>
		<cfset stLog.relatedTypename = arguments.relatedTypename>
		<cfset stLog.relatedObjectUUID = arguments.relatedObjectUUID>

		<!--- create the log --->
		<cfset oLog.createData(stProperties=stLog)>

		<cfreturn arguments.objectid>
	</cffunction>

	<cffunction name="logAPIResponse" access="public" output="false" returntype="string">
		<cfargument name="responseData" type="struct" required="true">
		<cfargument name="objectid" type="uuid" required="true">

		<cfargument name="endpointType" type="string" required="false" default="#application.fapi.getConfig('paypal', 'endpointType')#">

		<cfset var stResponseData = duplicate(arguments.responseData)>
		<cfset var oLog = application.fapi.getContentType(typename="paypalTransactionLog")>
		<cfset var stLog = application.fapi.getContentObject(typename="paypalTransactionLog", objectid=arguments.objectid)>

		<cfset stLog.responseData = serializeJSON(arguments.responseData)>

		<cfparam name="stResponseData.ack" default="">
		<cfparam name="stResponseData.correlationID" default="">
		<cfparam name="stResponseData.timestamp" default="">
		<cfparam name="stResponseData.version" default="">
		<cfparam name="stResponseData.build" default="">

		<!--- common response properties --->
		<cfset stLog.ack = stResponseData.ack>
		<cfset stLog.correlationID = stResponseData.correlationID>
		<cfset stLog.timestamp = stResponseData.timestamp>
		<cfset stLog.version = stResponseData.version>
		<cfset stLog.build = stResponseData.build>

		<cfif structKeyExists(arguments.responseData, "PAYMENTINFO_0_TRANSACTIONID")>
			<cfset stLog.transactionID = arguments.responseData.PAYMENTINFO_0_TRANSACTIONID>
		</cfif>

		<!--- update the log --->
		<cfset oLog.setData(stProperties=stLog)>

	</cffunction>


	<!--- utility methods --->

	<cffunction name="arrayify" returntype="struct" output="false" access="public" hint="Looks for specified numbered properties and converts to an array of structs">
		<cfargument name="st" type="struct" required="true">
		<cfargument name="properties" type="string" required="true">
		<cfargument name="arrayname" type="string" required="true">

		<cfset var stResult = duplicate(arguments.st)>
		<cfset var thisprop = "">
		<cfset var regexp = "^L_(#replace(arguments.properties,',','|','all')#)\d+$">
		<cfset var index = 0>
		<cfset var key = "">

		<cfset stResult[arguments.arrayname] = arraynew(1)>

		<cfloop collection="#stResult#" item="key">
			<cfif refindnocase(regexp,key)>
				<cfset index = int(rereplace(key,"^[A-Z_]+(\d+)$","\1")) + 1>

				<cfif not arrayIsDefined(stResult[arguments.arrayname],index)>
					<cfset stResult[arguments.arrayname][index] = structnew()>
				</cfif>

				<cfset stResult[arguments.arrayname][index][rereplace(key,"^L_([A-Z_]+)\d+$","\1")] = stResult[key]>
				<cfset structdelete(stResult,key)>
			</cfif>
		</cfloop>

		<cfreturn stResult>
	</cffunction>

	<cffunction name="getNVPResponse" access="public" returntype="struct" hint="This method will take response from the API endpoint and return is as a struct">
		<cfargument name="nvpString" type="string" required="yes" >

		<cfset var responseStruct = StructNew()>
		<cfset var thisvalue = "">

		<cfloop list="#arguments.nvpString#" index="thisvalue" delimiters="&">
			<cfset responseStruct[trim(listfirst(thisvalue,"="))] = urldecode(trim(listlast(thisvalue,"=")))>
		</cfloop>

		<cfreturn responseStruct>
	</cffunction>

	<cffunction name="outputRequestData" returntype="string" output="false" hint="Returns the request data struct as a multi-line string">
		<cfargument name="st" type="struct" required="true">

		<cfset var output = "">
		<cfset var item = "">

		<cfloop list="#listSort(structKeyList(arguments.st), "text")#" item="item">
			<cfset output &= "#ucase(item)#=#arguments.st[item]#" & chr(13) & chr(10)>		
		</cfloop>

		<cfreturn output>
	</cffunction>

	<cffunction name="parseProxy" access="public" output="false" returntype="struct">
		<cfargument name="proxy" type="string" required="true">

		<cfset var stResult = structnew()>
		<cfset var temp = "">

		<cfif len(arguments.proxy)>
			<cfif listlen(arguments.proxy,"@") eq 2>
				<cfset temp = listfirst(arguments.proxy,"@")>
				<cfset stResult.proxyuser = listfirst(temp,":")>
				<cfset stResult.proxypassword = listlast(temp,":")>
			<cfelse>
				<cfset stResult.proxyuser = "">
				<cfset stResult.proxypassword = "">
			</cfif>
			<cfset temp = listlast(arguments.proxy,"@")>
			<cfset stResult.proxyserver = listfirst(temp,":")>
			<cfif listlen(temp,":") eq 2>
				<cfset stResult.proxyport = listlast(temp,":")>
			<cfelse>
				<cfset stResult.proxyport = "80">
			</cfif>
		</cfif>

		<cfreturn stResult>
	</cffunction>


</cfcomponent>