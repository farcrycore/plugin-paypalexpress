<cfsetting enablecfoutputonly="true">

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin">

<cfoutput>

	<style type="text/css">
		table { width:99%; }
		td, th { padding:5px; }
		th { font-weight:bold; text-align:left; }
		h3, h4 { font-weight:normal; }
		.status-good { color:##00CC00; }
		.status-bad { color:##FF0000; }
		td .status-good, td .status-bad { font-weight:bold; } 
	</style>

	<h1>PayPal API Status</h1>

	<cfif NOT application.fc.lib.db.isDeployed(typename="paypalTransactionLog",dsn=application.dsn)>

		<p><strong>Error: Transaction Log table undeployed</strong></p>
		<p>You need to deploy the PayPal Transaction Log table (Admin -> Developer Utilties -> COAPI Tools -> COAPI Content Types).</p>

	<cfelse>

		<cfloop list="Live,Sandbox" item="endpointType">

			<cfif NOT application.fc.lib.paypal.hasConfiguration(endpointType=endpointType)>

				<h3>
					#endpointType# API Endpoint &ndash; <span class="status-bad">Incomplete</span>
					<cfif application.fapi.getConfig("paypal", "endpointType") eq endpointType>(Default Endpoint)</cfif>
				</h3>
				<p>You need to add the #endpointType# API Credentials to the PayPal Express Checkout config (Admin -> General Admin -> Configuration).</p>

				<table class="status table table-striped">
					<thead>
						<tr>
							<th style="width:12.5em">Configuration</th>
							<th>Status</th>						
						</tr>
					</thead>
					<tr>
						<td>Username</td>
						<cfif NOT len(application.fc.lib.paypal.getEndpointUsername(endpointType=endpointType))>
							<td class="status-bad">Missing</td>
						<cfelse>
							<td class="status-good">Configured</td>
						</cfif>
					</tr>
					<tr>
						<td>Password</td>
						<cfif NOT len(application.fc.lib.paypal.getEndpointPassword(endpointType=endpointType))>
							<td class="status-bad">Missing</td>
						<cfelse>
							<td class="status-good">Configured</td>
						</cfif>
					</tr>
					<tr>
						<td>Signature</td>
						<cfif NOT len(application.fc.lib.paypal.getEndpointSignature(endpointType=endpointType))>
							<td class="status-bad">Missing</td>
						<cfelse>
							<td class="status-good">Configured</td>
						</cfif>
					</tr>
					<tr>
						<td>Merchant ID</td>
						<cfif NOT len(application.fc.lib.paypal.getEndpointMerchantID(endpointType=endpointType))>
							<td class="status-bad">Missing</td>
						<cfelse>
							<td class="status-good">Configured</td>
						</cfif>
					</tr>
				</table>

			<cfelse>

				<cfset bSuccess = true>
				<cftry>
					<cfset stResult = application.fc.lib.paypal.searchTransactions(endpointType=endpointType,startDate=now()-7,endDate=now())>

					<cfcatch>
						<cfset bSuccess = false>

						<h3>#endpointType# API Endpoint &ndash; <span class="status-bad">Error accessing API</span></h3>
						<p>There was an error while attempting to access recent transactions. There may be a problem with your credentials. [<a href="##more" onclick="$j('##more').toggle();return false;">More Information</a>]</p>
						<div id="more" style="display:none;"><cfdump var="#cfcatch#"><br></div>
					</cfcatch>
				</cftry>

				<cfif bSuccess>
					<h3>
						#endpointType# API Endpoint &ndash; <span class="status-good">Success</span>
						<cfif application.fapi.getConfig("paypal", "endpointType") eq endpointType>(Default Endpoint)</cfif>
					</h3>
					<h4>Recent Transactions</h4>

					<cfif NOT arrayLen(stResult.transactions)>
						<p><em>No transactions in the last week</em></p>
					<cfelse>
						<table class="table table-striped">
							<thead>
								<tr>
									<th>Date</th>
									<th>Type</th>
									<th>Name</th>
									<th>Email</th>
									<th>Amount</th>
									<th>Fee Amount</th>
									<th>Net Amount</th>
									<th>Transaction ID</th>
									<th>Status</th>
								</tr>
							</thead>
							<tbody>
								<cfloop from="1" to="#arrayLen(stResult.transactions)#" index="i">
									<tr>
										<td>#stResult.transactions[i].timestamp#</td>
										<td>#stResult.transactions[i].type#</td>
										<td>#stResult.transactions[i].name#</td>
										<td>#stResult.transactions[i].email#</td>
										<td>#stResult.transactions[i].amt#</td>
										<td>#stResult.transactions[i].feeamt#</td>
										<td>#stResult.transactions[i].netamt#</td>
										<td>#stResult.transactions[i].transactionid#</td>
										<td>#stResult.transactions[i].status#</td>
									</tr>
								</cfloop>
							</tbody>
						</table>
					</cfif>
				</cfif>

			</cfif>

		</cfloop>

	</cfif>


</cfoutput>

<cfsetting enablecfoutputonly="false">